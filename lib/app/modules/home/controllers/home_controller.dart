import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/reservation_repository.dart';
import '../../../data/repositories/tool_repository.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/reservation_model.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';

/// Controlador para la pantalla principal de la aplicación
class HomeController extends GetxController {
  final AuthRepository authRepository;
  final ReservationRepository reservationRepository;
  final ToolRepository toolRepository;

  HomeController({
    required this.authRepository,
    required this.reservationRepository,
    required this.toolRepository,
  });

  // Estados reactivos - CORREGIDO: Todas las propiedades que se usan en Obx deben ser observables
  final RxBool isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxList<ReservationModel> upcomingReservations =
      <ReservationModel>[].obs;
  final RxList<ReservationModel> todayReservations = <ReservationModel>[].obs;
  final RxMap<String, dynamic> quickStats = <String, dynamic>{}.obs;

  // Estado del drawer/menú
  final RxBool isDrawerOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeHome();
  }

  @override
  void onReady() {
    super.onReady();
    _loadDashboardData();
  }

  /// Inicializar la pantalla de home
  void _initializeHome() {
    // Obtener usuario actual
    currentUser.value = authRepository.getCurrentUser();

    // Si no hay usuario, redirigir al login
    if (currentUser.value == null) {
      Get.offAllNamed(AppRoutes.LOGIN);
      return;
    }

    // Mostrar mensaje de bienvenida si es necesario
    _showWelcomeMessage();
  }

  /// Cargar datos del dashboard
  Future<void> _loadDashboardData() async {
    try {
      isLoading.value = true;

      if (currentUser.value == null) return;

      // Cargar reservaciones próximas del usuario
      await _loadUpcomingReservations();

      // Cargar reservaciones de hoy
      await _loadTodayReservations();

      // Cargar estadísticas rápidas
      await _loadQuickStats();
    } catch (e) {
      print('Error cargando datos del dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Cargar reservaciones próximas del usuario
  Future<void> _loadUpcomingReservations() async {
    try {
      if (currentUser.value == null) return;

      final reservations = await reservationRepository
          .getFutureReservationsByUser(currentUser.value!.id);

      // Tomar solo las próximas 3 reservaciones
      upcomingReservations.value = reservations.take(3).toList();
    } catch (e) {
      print('Error cargando reservaciones próximas: $e');
    }
  }

  /// Cargar reservaciones de hoy (para staff)
  Future<void> _loadTodayReservations() async {
    try {
      if (currentUser.value == null || !currentUser.value!.isStaff) return;

      final reservations = await reservationRepository.getTodayReservations();
      todayReservations.value = reservations;
    } catch (e) {
      print('Error cargando reservaciones de hoy: $e');
    }
  }

  /// Cargar estadísticas rápidas
  Future<void> _loadQuickStats() async {
    try {
      Map<String, dynamic> stats = {};

      if (currentUser.value != null) {
        // Estadísticas del usuario
        final userReservations = await reservationRepository
            .getReservationsByUser(currentUser.value!.id);
        stats['userReservations'] = userReservations.length;
        stats['activeReservations'] =
            userReservations.where((r) => r.isActive).length;

        // Si es staff, mostrar estadísticas generales
        if (currentUser.value!.isStaff) {
          final toolStats = await toolRepository.getToolsStats();
          final reservationStats =
              await reservationRepository.getReservationsStats();

          stats['totalTools'] = toolStats['totalTools'] ?? 0;
          stats['availableTools'] = toolStats['availableTools'] ?? 0;
          stats['todayReservations'] =
              reservationStats['todayReservations'] ?? 0;
          stats['totalUsers'] = reservationStats['totalReservations'] ?? 0;
        }
      }

      quickStats.value = stats;
    } catch (e) {
      print('Error cargando estadísticas rápidas: $e');
    }
  }

  /// Mostrar mensaje de bienvenida
  void _showWelcomeMessage() {
    if (currentUser.value == null) return;

    final user = currentUser.value!;
    final timeOfDay = _getTimeOfDayGreeting();

    Get.snackbar(
      '$timeOfDay ${user.fullName.split(' ').first}',
      'Bienvenido a TallerURL',
      duration: const Duration(seconds: 2),
    );
  }

  /// Obtener saludo según la hora del día
  String _getTimeOfDayGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Buenos días';
    } else if (hour < 18) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  /// Navegar al catálogo de herramientas
  void navigateToTools() {
    Get.toNamed(AppRoutes.TOOLS_CATALOG);
  }

  /// Navegar a reservaciones
  void navigateToReservations() {
    Get.toNamed(AppRoutes.RESERVATIONS);
  }

  /// Navegar a mis reservaciones
  void navigateToMyReservations() {
    Get.toNamed(AppRoutes.MY_RESERVATIONS);
  }

  /// Navegar a horarios
  void navigateToSchedule() {
    Get.toNamed(AppRoutes.SCHEDULE);
  }

  /// Navegar a videos de inducción
  void navigateToInduction() {
    Get.toNamed(AppRoutes.INDUCTION);
  }

  /// Navegar a notificaciones
  void navigateToNotifications() {
    Get.toNamed(AppRoutes.NOTIFICATIONS);
  }

  /// Navegar al panel de administración (solo admin)
  void navigateToAdminPanel() {
    if (currentUser.value?.isAdmin == true) {
      Get.toNamed(AppRoutes.ADMIN_PANEL);
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    try {
      await authRepository.logout();
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      print('Error cerrando sesión: $e');
    }
  }

  /// Refrescar datos del dashboard
  Future<void> refreshDashboard() async {
    await _loadDashboardData();
  }

  // CORREGIDO: Convertir getters en propiedades observables
  /// Verificar si el usuario actual es admin
  bool get isCurrentUserAdmin => currentUser.value?.isAdmin ?? false;

  /// Verificar si el usuario actual es staff
  bool get isCurrentUserStaff => currentUser.value?.isStaff ?? false;

  /// Obtener nombre del usuario actual - DEBE SER OBSERVABLE
  String get currentUserName => currentUser.value?.fullName ?? 'Usuario';

  /// Obtener rol del usuario actual - DEBE SER OBSERVABLE
  String get currentUserRole => currentUser.value?.roleDescription ?? 'Sin rol';

  /// Verificar si ha completado la inducción
  bool get hasCompletedInduction =>
      authRepository.hasCurrentUserCompletedInduction();

  /// Obtener total de reservaciones del usuario
  int get userTotalReservations => quickStats['userReservations'] ?? 0;

  /// Obtener reservaciones activas del usuario
  int get userActiveReservations => quickStats['activeReservations'] ?? 0;

  /// Mostrar diálogo de confirmación para cerrar sesión
  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              logout();
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  /// Obtener acciones rápidas disponibles según el rol del usuario
  List<Map<String, dynamic>> getQuickActions() {
    List<Map<String, dynamic>> actions = [
      {
        'title': 'Catálogo de Herramientas',
        'subtitle': 'Explora las herramientas disponibles',
        'icon': Icons.build,
        'action': navigateToTools,
        'color': Colors.blue,
      },
      {
        'title': 'Reservar Espacio',
        'subtitle': 'Reserva espacios del taller',
        'icon': Icons.event_available,
        'action': navigateToReservations,
        'color': Colors.green,
      },
      {
        'title': 'Mis Reservaciones',
        'subtitle': 'Ver mis reservaciones activas',
        'icon': Icons.event_note,
        'action': navigateToMyReservations,
        'color': Colors.orange,
      },
      {
        'title': 'Horarios',
        'subtitle': 'Horarios de funcionamiento',
        'icon': Icons.access_time,
        'action': navigateToSchedule,
        'color': Colors.purple,
      },
    ];

    // Agregar inducción si no la ha completado
    if (!hasCompletedInduction) {
      actions.insert(0, {
        'title': 'Videos de Inducción',
        'subtitle': 'Completa tu inducción al taller',
        'icon': Icons.play_circle,
        'action': navigateToInduction,
        'color': Colors.red,
        'priority': true,
      });
    }

    // Agregar panel de admin si es administrador
    if (isCurrentUserAdmin) {
      actions.add({
        'title': 'Panel de Administración',
        'subtitle': 'Gestión de usuarios y sistema',
        'icon': Icons.admin_panel_settings,
        'action': navigateToAdminPanel,
        'color': Colors.indigo,
      });
    }

    return actions;
  }

  /// Obtener mensaje de estado del usuario
  String getUserStatusMessage() {
    if (!hasCompletedInduction) {
      return '⚠️ Completa tu inducción para acceder a todas las funciones';
    }

    if (upcomingReservations.isNotEmpty) {
      final nextReservation = upcomingReservations.first;
      return '📅 Próxima reservación: ${nextReservation.zone.displayName} - ${nextReservation.timeUntilReservation}';
    }

    return '✅ Todo al día';
  }
}
