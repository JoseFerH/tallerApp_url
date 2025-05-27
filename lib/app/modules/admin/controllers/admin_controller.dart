import 'package:get/get.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';
import '../../../core/utils/constants.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/helpers.dart';

/// Controlador para el panel de administración
class AdminController extends GetxController {
  final UserRepository userRepository;
  final AuthRepository authRepository;

  AdminController({required this.userRepository, required this.authRepository});

  // Estados reactivos
  final RxBool isLoading = false.obs;
  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<UserRole?> selectedRoleFilter = Rx<UserRole?>(null);
  final RxBool showActiveOnly = true.obs;

  // Estadísticas
  final RxMap<String, int> userStats = <String, int>{}.obs;

  // Usuario actual (para verificar permisos)
  UserModel? currentUser;

  @override
  void onInit() {
    super.onInit();
    _initializeAdmin();
  }

  /// Inicializar panel de administración
  void _initializeAdmin() {
    currentUser = authRepository.getCurrentUser();

    // Verificar permisos de admin
    if (currentUser?.isAdmin != true) {
      Get.offAllNamed(AppRoutes.HOME);
      return;
    }

    loadAllUsers();
  }

  /// Cargar todos los usuarios
  Future<void> loadAllUsers() async {
    try {
      isLoading.value = true;

      final users = await userRepository.getAllUsers();
      allUsers.value = users;

      _applyFilters();
      _updateStats();
    } catch (e) {
      print('Error cargando usuarios: $e');
      Get.snackbar(
        'Error',
        'No se pudieron cargar los usuarios',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Aplicar filtros de búsqueda
  void _applyFilters() {
    List<UserModel> filtered = allUsers.toList();

    // Filtrar por búsqueda
    if (searchQuery.value.isNotEmpty) {
      filtered =
          filtered.where((user) {
            final query = searchQuery.value.toLowerCase();
            return user.fullName.toLowerCase().contains(query) ||
                user.id.toLowerCase().contains(query) ||
                user.roleDescription.toLowerCase().contains(query);
          }).toList();
    }

    // Filtrar por rol
    if (selectedRoleFilter.value != null) {
      filtered =
          filtered
              .where((user) => user.role == selectedRoleFilter.value)
              .toList();
    }

    // Filtrar solo activos
    if (showActiveOnly.value) {
      filtered = filtered.where((user) => user.isActive).toList();
    }

    // Ordenar por nombre
    filtered.sort((a, b) => a.fullName.compareTo(b.fullName));

    filteredUsers.value = filtered;
  }

  /// Actualizar estadísticas
  void _updateStats() {
    final stats = <String, int>{};

    stats['total'] = allUsers.length;
    stats['active'] = allUsers.where((u) => u.isActive).length;
    stats['inactive'] = allUsers.where((u) => !u.isActive).length;
    stats['students'] =
        allUsers.where((u) => u.role == UserRole.estudiante).length;
    stats['teachers'] =
        allUsers.where((u) => u.role == UserRole.docente).length;
    stats['assistants'] =
        allUsers.where((u) => u.role == UserRole.auxiliar).length;
    stats['admins'] = allUsers.where((u) => u.role == UserRole.admin).length;
    stats['completedInduction'] =
        allUsers.where((u) => u.hasCompletedInduction).length;

    userStats.value = stats;
  }

  /// Buscar usuarios
  void searchUsers(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  /// Filtrar por rol
  void filterByRole(UserRole? role) {
    selectedRoleFilter.value = role;
    _applyFilters();
  }

  /// Alternar filtro de activos
  void toggleActiveFilter() {
    showActiveOnly.value = !showActiveOnly.value;
    _applyFilters();
  }

  /// Limpiar filtros
  void clearFilters() {
    searchQuery.value = '';
    selectedRoleFilter.value = null;
    showActiveOnly.value = true;
    _applyFilters();
  }

  /// Navegar a crear usuario
  void navigateToCreateUser() {
    Get.toNamed(AppRoutes.CREATE_USER);
  }

  /// Navegar a editar usuario
  void navigateToEditUser(UserModel user) {
    Get.toNamed(AppRoutes.EDIT_USER, arguments: user);
  }

  /// Eliminar usuario
  Future<void> deleteUser(UserModel user) async {
    // Verificar que no sea el último admin
    if (user.isAdmin) {
      final activeAdmins =
          allUsers.where((u) => u.isAdmin && u.isActive).length;
      if (activeAdmins <= 1) {
        Get.snackbar(
          'Error',
          'No se puede eliminar el último administrador activo',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }
    }

    // Mostrar confirmación
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Eliminar Usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Estás seguro de eliminar a ${user.fullName}?'),
            const SizedBox(height: 8),
            Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final success = await userRepository.deleteUser(user.id);

      if (success) {
        Get.snackbar(
          'Usuario Eliminado',
          '${user.fullName} ha sido eliminado exitosamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );

        await loadAllUsers();
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el usuario',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error eliminando usuario: $e');
      Get.snackbar(
        'Error',
        'Ocurrió un error inesperado',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Activar/desactivar usuario
  Future<void> toggleUserStatus(UserModel user) async {
    try {
      final success = await userRepository.toggleUserStatus(user.id);

      if (success) {
        final newStatus = user.isActive ? 'desactivado' : 'activado';
        Get.snackbar(
          'Usuario ${newStatus.capitalizeFirst}',
          '${user.fullName} ha sido $newStatus',
          snackPosition: SnackPosition.BOTTOM,
        );

        await loadAllUsers();
      } else {
        Get.snackbar(
          'Error',
          'No se pudo cambiar el estado del usuario',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error cambiando estado de usuario: $e');
    }
  }

  /// Refrescar datos
  Future<void> refreshData() async {
    await loadAllUsers();
  }

  /// Exportar lista de usuarios
  Future<void> exportUsers() async {
    try {
      final exportData = await userRepository.exportUsersList();

      // En una implementación real, aquí se guardaría el archivo
      Get.snackbar(
        'Exportación Completada',
        'Lista de usuarios exportada exitosamente',
        snackPosition: SnackPosition.BOTTOM,
      );

      print('Datos exportados: ${exportData.keys}');
    } catch (e) {
      print('Error exportando usuarios: $e');
    }
  }

  /// Obtener color del rol
  Color getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.docente:
        return Colors.blue;
      case UserRole.auxiliar:
        return Colors.orange;
      case UserRole.estudiante:
      default:
        return Colors.green;
    }
  }

  /// Obtener icono del rol
  IconData getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.docente:
        return Icons.school;
      case UserRole.auxiliar:
        return Icons.build;
      case UserRole.estudiante:
      default:
        return Icons.person;
    }
  }

  /// Verificar si se pueden realizar acciones de admin
  bool get canPerformAdminActions => currentUser?.isAdmin == true;

  /// Obtener texto del filtro activo
  String get activeFilterText {
    List<String> filters = [];

    if (searchQuery.value.isNotEmpty) {
      filters.add('Búsqueda: "${searchQuery.value}"');
    }

    if (selectedRoleFilter.value != null) {
      filters.add('Rol: ${selectedRoleFilter.value!.displayName}');
    }

    if (!showActiveOnly.value) {
      filters.add('Incluye inactivos');
    }

    return filters.join(' • ');
  }

  /// Verificar si hay filtros activos
  bool get hasActiveFilters =>
      searchQuery.value.isNotEmpty ||
      selectedRoleFilter.value != null ||
      !showActiveOnly.value;

  get searchController => null;

  get clearSearch => null;

  get refreshUsers => null;

  get updateSearch => null;

  get users => null;

  Future<void> updateUser(UserModel user) async {}

  Future<void> createUser(UserModel user) async {}
}
