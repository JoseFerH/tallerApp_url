// lib/app/modules/home/controllers/home_controller.dart
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/reservation_repository.dart';
import '../../../data/repositories/tool_repository.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/reservation_model.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final AuthRepository authRepository;
  final ReservationRepository reservationRepository;
  final ToolRepository toolRepository;

  HomeController({
    required this.authRepository,
    required this.reservationRepository,
    required this.toolRepository,
  });

  // ✅ CORREGIDO: Todas las propiedades observables
  final RxBool isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxList<ReservationModel> upcomingReservations =
      <ReservationModel>[].obs;
  final RxList<ReservationModel> todayReservations = <ReservationModel>[].obs;
  final RxMap<String, dynamic> quickStats = <String, dynamic>{}.obs;
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

  void _initializeHome() {
    currentUser.value = authRepository.getCurrentUser();

    if (currentUser.value == null) {
      Get.offAllNamed(AppRoutes.LOGIN);
      return;
    }

    _showWelcomeMessage();
  }

  Future<void> _loadDashboardData() async {
    try {
      isLoading.value = true;

      if (currentUser.value == null) return;

      await _loadUpcomingReservations();
      await _loadTodayReservations();
      await _loadQuickStats();
    } catch (e) {
      print('Error cargando datos del dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadUpcomingReservations() async {
    try {
      if (currentUser.value == null) return;

      final reservations = await reservationRepository
          .getFutureReservationsByUser(currentUser.value!.id);

      upcomingReservations.value = reservations.take(3).toList();
    } catch (e) {
      print('Error cargando reservaciones próximas: $e');
    }
  }

  Future<void> _loadTodayReservations() async {
    try {
      if (currentUser.value == null || !isCurrentUserStaff) return;

      final reservations = await reservationRepository.getTodayReservations();
      todayReservations.value = reservations;
    } catch (e) {
      print('Error cargando reservaciones de hoy: $e');
    }
  }

  Future<void> _loadQuickStats() async {
    try {
      Map<String, dynamic> stats = {};

      if (currentUser.value != null) {
        final userReservations = await reservationRepository
            .getReservationsByUser(currentUser.value!.id);
        stats['userReservations'] = userReservations.length;
        stats['activeReservations'] =
            userReservations.where((r) => r.isActive).length;

        if (isCurrentUserStaff) {
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

  // ✅ MÉTODOS DE NAVEGACIÓN
  void navigateToTools() => Get.toNamed(AppRoutes.TOOLS_CATALOG);
  void navigateToReservations() => Get.toNamed(AppRoutes.RESERVATIONS);
  void navigateToMyReservations() => Get.toNamed(AppRoutes.MY_RESERVATIONS);
  void navigateToSchedule() => Get.toNamed(AppRoutes.SCHEDULE);
  void navigateToInduction() => Get.toNamed(AppRoutes.INDUCTION);
  void navigateToNotifications() => Get.toNamed(AppRoutes.NOTIFICATIONS);

  void navigateToAdminPanel() {
    if (isCurrentUserAdmin) {
      Get.toNamed(AppRoutes.ADMIN_PANEL);
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      print('Error cerrando sesión: $e');
    }
  }

  Future<void> refreshDashboard() async {
    await _loadDashboardData();
  }

  // ✅ GETTERS CORREGIDOS
  bool get isCurrentUserAdmin => currentUser.value?.isAdmin ?? false;
  bool get isCurrentUserStaff => currentUser.value?.isStaff ?? false;
  String get currentUserName => currentUser.value?.fullName ?? 'Usuario';
  String get currentUserRole => currentUser.value?.roleDescription ?? 'Sin rol';
  bool get hasCompletedInduction =>
      authRepository.hasCurrentUserCompletedInduction();
  int get userTotalReservations => quickStats['userReservations'] ?? 0;
  int get userActiveReservations => quickStats['activeReservations'] ?? 0;

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
