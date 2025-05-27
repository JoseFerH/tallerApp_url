import 'package:get/get.dart';

/// Controlador para el módulo de horarios
class ScheduleController extends GetxController {
  // Estados reactivos
  final RxBool isLoading = false.obs; // ✅ Correcto
  final RxList<Map<String, dynamic>> scheduleData =
      <Map<String, dynamic>>[].obs; // ✅ Correcto
  final RxList<Map<String, dynamic>> specialSchedules =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadScheduleData();
  }

  /// Cargar datos de horarios
  void _loadScheduleData() {
    isLoading.value = true;

    // Horarios regulares
    scheduleData.value = [
      {
        'title': 'Lunes a Viernes',
        'subtitle': 'Horario Regular',
        'schedule': '7:00 AM - 6:00 PM',
        'icon': 'weekday',
        'zones': {
          'Área General': '7:00 AM - 6:00 PM',
          'Carpintería': '7:00 AM - 5:00 PM',
          'Metalurgia': '8:00 AM - 5:00 PM',
          'Corte Láser': '9:00 AM - 4:00 PM',
          'Impresión 3D': '8:00 AM - 6:00 PM',
          'Pintura': '8:00 AM - 4:00 PM',
        },
      },
      {
        'title': 'Sábados',
        'subtitle': 'Horario Reducido',
        'schedule': '8:00 AM - 2:00 PM',
        'icon': 'weekend',
        'zones': {
          'Área General': '8:00 AM - 2:00 PM',
          'Carpintería': '8:00 AM - 1:00 PM',
          'Impresión 3D': '9:00 AM - 1:00 PM',
        },
      },
      {
        'title': 'Domingos',
        'subtitle': 'Cerrado',
        'schedule': 'Cerrado',
        'icon': 'closed',
        'zones': {},
      },
    ];

    // Horarios especiales
    specialSchedules.value = [
      {
        'title': 'Período de Exámenes',
        'description': 'Durante períodos de exámenes finales',
        'schedule': '8:00 AM - 4:00 PM',
        'dates': 'Según calendario académico',
        'type': 'exam_period',
      },
      {
        'title': 'Días Festivos',
        'description': 'Días feriados nacionales',
        'schedule': 'Cerrado',
        'dates': 'Según calendario oficial',
        'type': 'holiday',
      },
      {
        'title': 'Vacaciones',
        'description': 'Período de vacaciones estudiantiles',
        'schedule': '9:00 AM - 3:00 PM',
        'dates': 'Diciembre - Enero',
        'type': 'vacation',
      },
    ];

    isLoading.value = false;
  }

  /// Obtener horario de una zona específica
  String getZoneSchedule(String zoneName, String day) {
    try {
      final daySchedule = scheduleData.firstWhere(
        (schedule) => schedule['title'].toString().toLowerCase().contains(
          day.toLowerCase(),
        ),
      );

      final zones = daySchedule['zones'] as Map<String, dynamic>;
      return zones[zoneName] ?? 'No disponible';
    } catch (e) {
      return 'No disponible';
    }
  }

  /// Verificar si el taller está abierto ahora
  bool isCurrentlyOpen() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentDay = now.weekday;

    // Domingo (7) - cerrado
    if (currentDay == 7) return false;

    // Sábado (6) - horario reducido
    if (currentDay == 6) {
      return currentHour >= 8 && currentHour < 14;
    }

    // Lunes a viernes (1-5) - horario regular
    return currentHour >= 7 && currentHour < 18;
  }

  /// Obtener mensaje de estado actual
  String getCurrentStatusMessage() {
    if (isCurrentlyOpen()) {
      return '🟢 Taller Abierto';
    } else {
      final now = DateTime.now();
      final currentDay = now.weekday;

      if (currentDay == 7) {
        return '🔴 Cerrado - Domingos';
      } else if (currentDay == 6) {
        return '🔴 Cerrado - Sábado hasta 2:00 PM';
      } else {
        return '🔴 Cerrado - Horario: 7:00 AM - 6:00 PM';
      }
    }
  }

  /// Obtener próximo horario de apertura
  String getNextOpeningTime() {
    final now = DateTime.now();
    final currentDay = now.weekday;
    final currentHour = now.hour;

    if (currentDay == 7) {
      // Domingo
      return 'Mañana a las 7:00 AM';
    } else if (currentDay == 6) {
      // Sábado
      if (currentHour < 8) {
        return 'Hoy a las 8:00 AM';
      } else {
        return 'Lunes a las 7:00 AM';
      }
    } else {
      // Lunes a viernes
      if (currentHour < 7) {
        return 'Hoy a las 7:00 AM';
      } else if (currentHour >= 18) {
        if (currentDay == 5) {
          // Viernes
          return 'Lunes a las 7:00 AM';
        } else {
          return 'Mañana a las 7:00 AM';
        }
      }
    }

    return 'Consultar horarios';
  }

  /// Refrescar horarios
  Future<void> refreshSchedules() async {
    _loadScheduleData();
  }
}
