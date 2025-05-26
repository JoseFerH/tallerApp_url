import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Funciones de ayuda para toda la aplicación
class Helpers {
  
  /// Formatear fecha a texto legible
  static String formatDate(DateTime date, {String pattern = 'dd/MM/yyyy'}) {
    try {
      return DateFormat(pattern, 'es_ES').format(date);
    } catch (e) {
      return DateFormat(pattern).format(date);
    }
  }
  
  /// Formatear fecha y hora
  static String formatDateTime(DateTime dateTime) {
    try {
      return DateFormat('dd/MM/yyyy HH:mm', 'es_ES').format(dateTime);
    } catch (e) {
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    }
  }
  
  /// Formatear solo la hora
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
  
  /// Obtener nombre del día en español
  static String getDayName(DateTime date) {
    const days = [
      'Domingo', 'Lunes', 'Martes', 'Miércoles', 
      'Jueves', 'Viernes', 'Sábado'
    ];
    return days[date.weekday % 7];
  }
  
  /// Obtener nombre del mes en español
  static String getMonthName(DateTime date) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[date.month - 1];
  }
  
  /// Calcular tiempo transcurrido
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} semana${difference.inDays > 13 ? 's' : ''}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Ahora';
    }
  }
  
  /// Validar email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  /// Validar teléfono guatemalteco
  static bool isValidGuatemalaPhone(String phone) {
    // Formato: 8 dígitos, puede empezar con +502
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return RegExp(r'^(\+502)?[0-9]{8}$').hasMatch(cleanPhone);
  }
  
  /// Limpiar texto para búsqueda
  static String cleanTextForSearch(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll('ñ', 'n')
        .trim();
  }
  
  /// Capitalizar primera letra de cada palabra
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
  
  /// Mostrar snackbar de éxito
  static void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Éxito',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
      icon: const Icon(Icons.check_circle, color: Colors.green),
      duration: const Duration(seconds: 3),
    );
  }
  
  /// Mostrar snackbar de error
  static void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      icon: const Icon(Icons.error, color: Colors.red),
      duration: const Duration(seconds: 4),
    );
  }
  
  /// Mostrar snackbar de advertencia
  static void showWarningSnackbar(String message) {
    Get.snackbar(
      'Advertencia',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.1),
      colorText: Colors.orange,
      icon: const Icon(Icons.warning, color: Colors.orange),
      duration: const Duration(seconds: 3),
    );
  }
  
  /// Mostrar diálogo de confirmación
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Sí',
    String cancelText = 'No',
    Color? confirmColor,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: confirmColor != null
                ? ElevatedButton.styleFrom(backgroundColor: confirmColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
  
  /// Obtener color aleatorio para avatares
  static Color getRandomAvatarColor(String text) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    
    final index = text.hashCode % colors.length;
    return colors[index.abs()];
  }
  
  /// Debounce para búsquedas
  static Timer? _debounceTimer;
  static void debounce(VoidCallback callback, {int milliseconds = 500}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: milliseconds), callback);
  }
  
  /// Verificar si es fin de semana
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }
  
  /// Obtene