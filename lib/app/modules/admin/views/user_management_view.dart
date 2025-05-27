import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/constants.dart';
import '../../../core/values/strings.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/admin_controller.dart';
import 'widgets/user_list_item.dart';
import '../../../routes/app_routes.dart';

/// Vista de gestión de usuarios para administradores
class UserManagementView extends GetView<AdminController> {
  const UserManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.admin(
        'Gestión de Usuarios',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshUsers,
            tooltip: 'Actualizar lista',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchAndFilters(),
          Expanded(child: _buildUsersList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.CREATE_USER),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo Usuario'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundSecondary,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Administrar Usuarios', style: AppTextStyles.h5),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              'Total: ${controller.filteredUsers.length} usuarios',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: AppColors.backgroundPrimary,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Barra de búsqueda
          CustomTextField.search(
            hint: 'Buscar por nombre o carné...',
            controller: controller.searchController,
            onChanged: controller.updateSearch,
            onClear: controller.clearSearch,
          ),
          const SizedBox(height: 12),

          // Filtros por rol
          _buildRoleFilters(),
        ],
      ),
    );
  }

  Widget _buildRoleFilters() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildRoleFilterChip(
              label: 'Todos',
              isSelected: controller.selectedRoleFilter.value == null,
              onTap: () => controller.filterByRole(null),
              count: controller.users.length,
            ),
            const SizedBox(width: 8),
            ...UserRole.values.map((role) {
              final count =
                  controller.users.where((user) => user.role == role).length;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildRoleFilterChip(
                  label: role.displayName,
                  isSelected: controller.selectedRoleFilter.value == role,
                  onTap: () => controller.filterByRole(role),
                  count: count,
                  color: _getRoleColor(role),
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildRoleFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required int count,
    Color? color,
  }) {
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: color?.withOpacity(0.1),
      selectedColor: (color ?? AppColors.primaryBlue).withOpacity(0.2),
      checkmarkColor: color ?? AppColors.primaryBlue,
      labelStyle: AppTextStyles.labelMedium.copyWith(
        color:
            isSelected
                ? (color ?? AppColors.primaryBlue)
                : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildUsersList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return LoadingWidget.center(message: 'Cargando usuarios...');
      }

      final users = controller.filteredUsers;

      if (users.isEmpty) {
        if (controller.searchController.text.isNotEmpty) {
          return EmptyStateWidget.search(
            searchTerm: controller.searchController.text,
            onClearSearch: controller.clearSearch,
          );
        }

        return EmptyStateWidget.noUsers(
          onCreateUser: () => Get.toNamed(AppRoutes.CREATE_USER),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshUsers,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 80), // Space for FAB
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return UserListItem(
              user: user,
              onTap: () => _showUserDetails(user),
              onEdit: () => _editUser(user),
              onDelete: () => _confirmDeleteUser(user),
              showActions: true,
            );
          },
        ),
      );
    });
  }

  void _showUserDetails(user) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.mediumGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // User details
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detalles del Usuario', style: AppTextStyles.h5),
                  const SizedBox(height: 16),

                  UserListItem(user: user, showActions: false),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Get.back();
                            _editUser(user);
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Editar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (user.role != UserRole.admin)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.back();
                              _confirmDeleteUser(user);
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Eliminar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _editUser(user) {
    Get.toNamed(AppRoutes.CREATE_USER, arguments: {'user': user});
  }

  void _confirmDeleteUser(user) async {
    final confirmed = await CustomDialog.showDeleteConfirmation(
      itemName: user.fullName,
    );

    if (confirmed == true) {
      await controller.deleteUser(user.id);
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.estudiante:
        return AppColors.primaryBlue;
      case UserRole.docente:
        return AppColors.secondaryGreen;
      case UserRole.auxiliar:
        return AppColors.accentOrange;
      case UserRole.admin:
        return AppColors.error;
    }
  }
}
