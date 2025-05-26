/// Nombres de rutas para la navegación en la aplicación
abstract class AppRoutes {
  // Rutas de autenticación
  static const String SPLASH = '/splash';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  
  // Rutas principales
  static const String HOME = '/home';
  static const String PROFILE = '/profile';
  
  // Rutas del catálogo de herramientas
  static const String TOOLS_CATALOG = '/tools';
  static const String TOOL_DETAIL = '/tools/detail';
  
  // Rutas de reservaciones
  static const String RESERVATIONS = '/reservations';
  static const String RESERVATION_FORM = '/reservations/form';
  static const String MY_RESERVATIONS = '/reservations/my';
  static const String RESERVATION_DETAIL = '/reservations/detail';
  
  // Rutas de horarios
  static const String SCHEDULE = '/schedule';
  
  // Rutas de inducción
  static const String INDUCTION = '/induction';
  static const String VIDEO_PLAYER = '/induction/video';
  
  // Rutas de notificaciones
  static const String NOTIFICATIONS = '/notifications';
  
  // Rutas de administración (solo admin)
  static const String ADMIN_PANEL = '/admin';
  static const String USER_MANAGEMENT = '/admin/users';
  static const String CREATE_USER = '/admin/users/create';
  static const String EDIT_USER = '/admin/users/edit';
  
  // Rutas de configuración
  static const String SETTINGS = '/settings';
  static const String ABOUT = '/about';
  static const String HELP = '/help';
}