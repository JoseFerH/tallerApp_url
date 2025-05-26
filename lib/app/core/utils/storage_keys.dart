/// Claves de almacenamiento local centralizadas
class StorageKeys {
  // ========== AUTENTICACIÓN ==========
  static const String currentUser = 'current_user';
  static const String isLoggedIn = 'is_logged_in';
  static const String lastLoginTime = 'last_login_time';
  static const String rememberCredentials = 'remember_credentials';
  static const String savedUsername = 'saved_username';
  static const String savedPassword = 'saved_password';

  // ========== USUARIOS ==========
  static const String usersList = 'users_list';
  static const String usersBackup = 'users_backup';

  // ========== HERRAMIENTAS ==========
  static const String toolsList = 'tools_list';
  static const String toolsBackup = 'tools_backup';
  static const String toolsLastUpdate = 'tools_last_update';

  // ========== RESERVACIONES ==========
  static const String reservationsList = 'reservations_list';
  static const String reservationsBackup = 'reservations_backup';
  static const String userReservationsCache = 'user_reservations_cache';

  // ========== NOTIFICACIONES ==========
  static const String notificationsList = 'notifications_list';
  static const String notificationsRead = 'notifications_read';
  static const String lastNotificationCheck = 'last_notification_check';

  // ========== INDUCCIÓN ==========
  static const String inductionCompleted = 'induction_completed';
  static const String watchedVideos = 'watched_videos';
  static const String inductionProgress = 'induction_progress';

  // ========== CONFIGURACIONES ==========
  static const String appSettings = 'app_settings';
  static const String isFirstTime = 'is_first_time';
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String notificationsEnabled = 'notifications_enabled';

  // ========== CACHE ==========
  static const String searchHistory = 'search_history';
  static const String favoriteTools = 'favorite_tools';
  static const String recentViews = 'recent_views';

  // ========== BACKUP Y SYNC ==========
  static const String lastBackupDate = 'last_backup_date';
  static const String dataVersion = 'data_version';
  static const String pendingSync = 'pending_sync';

  // ========== ESTADÍSTICAS ==========
  static const String appUsageStats = 'app_usage_stats';
  static const String userActivityLog = 'user_activity_log';

  // ========== FILTROS Y PREFERENCIAS ==========
  static const String toolsFilterPreferences = 'tools_filter_preferences';
  static const String reservationsFilterPreferences =
      'reservations_filter_preferences';
  static const String dashboardLayout = 'dashboard_layout';

  /// Generar clave de usuario específica
  static String userSpecific(String baseKey, String userId) {
    return '${baseKey}_$userId';
  }

  /// Generar clave con timestamp
  static String withTimestamp(String baseKey) {
    return '${baseKey}_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Generar clave de backup
  static String backup(String baseKey) {
    return '${baseKey}_backup';
  }

  /// Todas las claves para limpieza
  static List<String> get allKeys => [
    currentUser,
    isLoggedIn,
    lastLoginTime,
    rememberCredentials,
    savedUsername,
    savedPassword,
    usersList,
    usersBackup,
    toolsList,
    toolsBackup,
    toolsLastUpdate,
    reservationsList,
    reservationsBackup,
    userReservationsCache,
    notificationsList,
    notificationsRead,
    lastNotificationCheck,
    inductionCompleted,
    watchedVideos,
    inductionProgress,
    appSettings,
    isFirstTime,
    themeMode,
    language,
    notificationsEnabled,
    searchHistory,
    favoriteTools,
    recentViews,
    lastBackupDate,
    dataVersion,
    pendingSync,
    appUsageStats,
    userActivityLog,
    toolsFilterPreferences,
    reservationsFilterPreferences,
    dashboardLayout,
  ];

  /// Claves críticas que no deben eliminarse
  static List<String> get criticalKeys => [
    usersList,
    toolsList,
    reservationsList,
    appSettings,
    dataVersion,
  ];

  /// Claves que deben respaldarse
  static List<String> get backupKeys => [
    usersList,
    toolsList,
    reservationsList,
    notificationsList,
    inductionCompleted,
    watchedVideos,
  ];
}
