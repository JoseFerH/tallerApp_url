/// Constantes globales de la aplicación
class AppConstants {
  // Información de la aplicación
  static const String appName = 'TallerURL';
  static const String appVersion = '1.0.0';
  static const String universityName = 'Universidad Rafael Landívar';
  static const String facultyName = 'Facultad de Diseño Industrial';
  
  // Configuración de tiempo
  static const int splashDuration = 3; // segundos
  static const int sessionTimeoutMinutes = 30;
  static const int reminderMinutesBefore = 15;
  
  // Límites de la aplicación
  static const int maxUsernameLength = 50;
  static const int maxPasswordLength = 20;
  static const int maxReservationDaysAhead = 30;
  static const int maxActiveReservationsPerUser = 5;
  
  // Configuración de búsqueda
  static const int minSearchLength = 2;
  static const int searchDebounceMs = 500;
  
  // Configuración de paginación
  static const int defaultPageSize = 20;
  static const int maxItemsPerPage = 50;
  
  // URLs y contactos (para futuras versiones)
  static const String supportEmail = 'tallerurl@url.edu.gt';
  static const String universityWebsite = 'https://www.url.edu.gt';
  static const String helpDocumentationUrl = '';
  
  // Configuración de notificaciones
  static const String notificationChannelId = 'taller_url_notifications';
  static const String notificationChannelName = 'TallerURL Notificaciones';
  static const String notificationChannelDescription = 'Notificaciones del sistema TallerURL';
  
  // Tipos de archivo permitidos
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedVideoExtensions = ['mp4', 'avi', 'mov'];
  
  // Tamaños máximos
  static const int maxImageSizeMB = 5;
  static const int maxVideoSizeMB = 50;
}

/// Tipos de usuario del sistema
enum UserRole {
  estudiante('Estudiante'),
  docente('Docente'),
  auxiliar('Auxiliar de Taller'),
  admin('Administrador');
  
  const UserRole(this.displayName);
  final String displayName;
}

/// Estados de reservación
enum ReservationStatus {
  activa('Activa'),
  completada('Completada'),
  cancelada('Cancelada'),
  noShow('No se presentó');
  
  const ReservationStatus(this.displayName);
  final String displayName;
}

/// Zonas del taller
enum WorkshopZone {
  corteLaser('Corte Láser'),
  impresion3d('Impresión 3D'),
  carpinteria('Carpintería'),
  metalurgia('Metalurgia'),
  pintura('Pintura'),
  areaGeneral('Área General');
  
  const WorkshopZone(this.displayName);
  final String displayName;
}

/// Bloques de tiempo para reservaciones
enum TimeSlot {
  slot0700('07:00 - 09:00'),
  slot0900('09:00 - 11:00'),
  slot1100('11:00 - 13:00'),
  slot1400('14:00 - 16:00'),
  slot1600('16:00 - 18:00');
  
  const TimeSlot(this.displayName);
  final String displayName;
  
  DateTime getStartTime(DateTime date) {
    switch (this) {
      case TimeSlot.slot0700:
        return DateTime(date.year, date.month, date.day, 7, 0);
      case TimeSlot.slot0900:
        return DateTime(date.year, date.month, date.day, 9, 0);
      case TimeSlot.slot1100:
        return DateTime(date.year, date.month, date.day, 11, 0);
      case TimeSlot.slot1400:
        return DateTime(date.year, date.month, date.day, 14, 0);
      case TimeSlot.slot1600:
        return DateTime(date.year, date.month, date.day, 16, 0);
    }
  }
  
  DateTime getEndTime(DateTime date) {
    switch (this) {
      case TimeSlot.slot0700:
        return DateTime(date.year, date.month, date.day, 9, 0);
      case TimeSlot.slot0900:
        return DateTime(date.year, date.month, date.day, 11, 0);
      case TimeSlot.slot1100:
        return DateTime(date.year, date.month, date.day, 13, 0);
      case TimeSlot.slot1400:
        return DateTime(date.year, date.month, date.day, 16, 0);
      case TimeSlot.slot1600:
        return DateTime(date.year, date.month, date.day, 18, 0);
    }
  }
}

/// Categorías de herramientas
enum ToolCategory {
  manuales('Herramientas Manuales'),
  electricas('Herramientas Eléctricas'),
  medicion('Instrumentos de Medición'),
  seguridad('Equipo de Seguridad');
  
  const ToolCategory(this.displayName);
  final String displayName;
}

/// Estados de herramientas
enum ToolStatus {
  disponible('Disponible'),
  mantenimiento('En Mantenimiento'),
  noDisponible('No Disponible'),
  prestada('Prestada');
  
  const ToolStatus(this.displayName);
  final String displayName;
}