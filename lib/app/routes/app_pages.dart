import 'package:get/get.dart';

// Importar bindings faltantes
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/tools/bindings/tools_binding.dart';
import '../modules/reservations/bindings/reservation_binding.dart';
import '../modules/schedule/bindings/schedule_binding.dart';
import '../modules/induction/bindings/induction_binding.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/admin/bindings/admin_binding.dart';

// Importar vistas faltantes
import '../modules/splash/views/splash_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/tools/views/tools_catalog_view.dart';
import '../modules/tools/views/tool_detail_view.dart';
import '../modules/reservations/views/calendar_view.dart';
import '../modules/reservations/views/reservation_form_view.dart';
import '../modules/reservations/views/my_reservations_view.dart';
import '../modules/schedule/views/schedule_view.dart';
import '../modules/induction/views/induction_view.dart';
import '../modules/induction/views/video_player_view.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/admin/views/admin_panel_view.dart';
import '../modules/admin/views/user_management_view.dart';
import '../modules/admin/views/create_user_view.dart';

import 'app_routes.dart';

/// Configuración de páginas y rutas de la aplicación
class AppPages {
  static const String INITIAL = AppRoutes.SPLASH;

  static final routes = [
    // Splash y autenticación
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.slideInUp,
    ),

    // Pantalla principal
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),

    // Catálogo de herramientas
    GetPage(
      name: AppRoutes.TOOLS_CATALOG,
      page: () => const ToolsCatalogView(),
      binding: ToolsBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.TOOL_DETAIL,
      page: () => const ToolDetailView(),
      binding: ToolsBinding(),
      transition: Transition.rightToLeft,
    ),

    // Reservaciones
    GetPage(
      name: AppRoutes.RESERVATIONS,
      page: () => const CalendarView(),
      binding: ReservationBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.RESERVATION_FORM,
      page: () => const ReservationFormView(),
      binding: ReservationBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.MY_RESERVATIONS,
      page: () => const MyReservationsView(),
      binding: ReservationBinding(),
      transition: Transition.rightToLeft,
    ),

    // Horarios
    GetPage(
      name: AppRoutes.SCHEDULE,
      page: () => const ScheduleView(),
      binding: ScheduleBinding(),
      transition: Transition.rightToLeft,
    ),

    // Inducción y videos
    GetPage(
      name: AppRoutes.INDUCTION,
      page: () => const InductionView(),
      binding: InductionBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.VIDEO_PLAYER,
      page: () => const VideoPlayerView(),
      binding: InductionBinding(),
      transition: Transition.rightToLeft,
    ),

    // Notificaciones
    GetPage(
      name: AppRoutes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      transition: Transition.rightToLeft,
    ),

    // Panel de administración (solo admin)
    GetPage(
      name: AppRoutes.ADMIN_PANEL,
      page: () => const AdminPanelView(),
      binding: AdminBinding(),
      transition: Transition.rightToLeft,
      middlewares: [AdminMiddleware()],
    ),

    GetPage(
      name: AppRoutes.USER_MANAGEMENT,
      page: () => const UserManagementView(),
      binding: AdminBinding(),
      transition: Transition.rightToLeft,
      middlewares: [AdminMiddleware()],
    ),

    GetPage(
      name: AppRoutes.CREATE_USER,
      page: () => const CreateUserView(),
      binding: AdminBinding(),
      transition: Transition.rightToLeft,
      middlewares: [AdminMiddleware()],
    ),

    // Ruta para editar usuario
    GetPage(
      name: AppRoutes.EDIT_USER,
      page: () => const CreateUserView(), // Reutiliza la misma vista
      binding: AdminBinding(),
      transition: Transition.rightToLeft,
      middlewares: [AdminMiddleware()],
    ),
  ];
}

/// Middleware para verificar permisos de administrador
class AdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // TODO: Implementar verificación de permisos admin
    // Por ahora permitimos el acceso
    return null;
  }
}
