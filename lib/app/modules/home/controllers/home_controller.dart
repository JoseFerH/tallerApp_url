// lib/app/modules/home/controllers/home_controller.dart
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/reservation_repository.dart';
import '../../../data/repositories/tool_repository.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';

/// Controlador simplificado para la pantalla principal
class HomeController extends GetxController {
  final AuthRepository authRepository;
  final ReservationRepository reservationRepository;
  final ToolRepository toolRepository;

  HomeController({
    required this.authRepository,
    required this.reservationRepository,
    required this.toolRepository,
  });

  // Variables simples (no observables para evitar problemas)
  UserModel? currentUser;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    _initializeHome();
  }

  /// Inicializar la pantalla de home
  void _initializeHome() {
    // Obtener usuario actual
    currentUser = authRepository.getCurrentUser();

    // Si no hay usuario, redirigir al login
    if (currentUser == null) {
      Get.offAllNamed(AppRoutes.LOGIN);
      return;
    }

    // Mostrar mensaje de bienvenida
    _showWelcomeMessage();
  }

  /// Mostrar mensaje de bienvenida
  void _showWelcomeMessage() {
    if (currentUser == null) return;

    final user = currentUser!;
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

  // ========== MÉTODOS DE NAVEGACIÓN ==========
  void navigateToTools() {
    Get.toNamed(AppRoutes.TOOLS_CATALOG);
  }

  void navigateToReservations() {
    Get.toNamed(AppRoutes.RESERVATIONS);
  }

  void navigateToMyReservations() {
    Get.toNamed(AppRoutes.MY_RESERVATIONS);
  }

  void navigateToSchedule() {
    Get.toNamed(AppRoutes.SCHEDULE);
  }

  void navigateToInduction() {
    Get.toNamed(AppRoutes.INDUCTION);
  }

  void navigateToNotifications() {
    Get.toNamed(AppRoutes.NOTIFICATIONS);
  }

  void navigateToAdminPanel() {
    if (isCurrentUserAdmin) {
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
      // Forzar navegación al login de todos modos
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  // ========== GETTERS SIMPLES ==========
  bool get isCurrentUserAdmin => currentUser?.isAdmin ?? false;

  bool get isCurrentUserStaff => currentUser?.isStaff ?? false;

  String get currentUserName => currentUser?.fullName ?? 'Usuario';

  String get currentUserRole => currentUser?.roleDescription ?? 'Estudiante';

  bool get hasCompletedInduction {
    try {
      return authRepository.hasCurrentUserCompletedInduction();
    } catch (e) {
      return false; // Por defecto false si hay error
    }
  }

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
}
