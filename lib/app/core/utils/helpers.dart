import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      'Domingo',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
    ];
    return days[date.weekday % 7];
  }

  /// Obtener nombre del mes en español
  static String getMonthName(DateTime date) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
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
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
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
            style:
                confirmColor != null
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

  /// Obtener primera letra del nombre para avatar
  static String getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    return 'U';
  }

  /// Formatear número de teléfono guatemalteco
  static String formatGuatemalaPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleanPhone.length == 8) {
      return '${cleanPhone.substring(0, 4)}-${cleanPhone.substring(4)}';
    }
    return phone;
  }

  /// Generar color basado en texto
  static Color generateColorFromText(String text) {
    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }

    final hue = (hash % 360).abs();
    return HSVColor.fromAHSV(1.0, hue.toDouble(), 0.7, 0.8).toColor();
  }

  /// Calcular días hábiles entre dos fechas
  static int calculateWorkingDays(DateTime start, DateTime end) {
    int workingDays = 0;
    DateTime current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if (!isWeekend(current)) {
        workingDays++;
      }
      current = current.add(const Duration(days: 1));
    }

    return workingDays;
  }

  /// Mostrar loading dialog
  static void showLoadingDialog([String? message]) {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message ?? 'Cargando...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Cerrar loading dialog
  static void hideLoadingDialog() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  /// Validar contraseña fuerte
  static bool isStrongPassword(String password) {
    // Al menos 8 caracteres, una mayúscula, una minúscula, un número
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
  }

  /// Generar ID único simple
  static String generateSimpleId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Formatear tamaño de archivo
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
