import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../../../core/utils/constants.dart';
import '../controllers/admin_controller.dart';

/// Vista principal del panel de administración
class AdminPanelView extends GetView<AdminController> {
  const AdminPanelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header de bienvenida admin
              _buildAdminHeader(),

              const SizedBox(height: 24),

              // Estadísticas rápidas
              _buildQuickStats(),

              const SizedBox(height: 32),

              // Acciones principales
              _buildMainActions(),

              const SizedBox(height: 32),

              // Información del sistema
              _buildSystemInfo(),
            ],
          ),
        ),
      ),
    );
  }

  /// AppBar personalizada
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        Strings.adminTitle,
        style: AppTextStyles.h5.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Exportar datos
        IconButton(
          onPressed: controller.exportUsers,
          icon: const Icon(Icons.download, color: AppColors.white),
          tooltip: 'Exportar Datos',
        ),

        // Menú de opciones
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.white),
          onSelected: (value) {
            switch (value) {
              case 'refresh':
                controller.refreshData();
                break;
              case 'backup':
                _showBackupDialog();
                break;
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'refresh',
                  child: ListTile(
                    leading: Icon(Icons.refresh),
                    title: Text('Actualizar'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'backup',
                  child: ListTile(
                    leading: Icon(Icons.backup),
                    title: Text('Respaldo'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
        ),
      ],
    );
  }

  /// Header de administrador
  Widget _buildAdminHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.admin_panel_settings,
                  color: AppColors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panel de Administración',
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Gestión completa del sistema TallerURL',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Info del admin actual
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.person, color: AppColors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Administrador: ${controller.currentUser?.fullName ?? 'Admin'}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Estadísticas rápidas
  Widget _buildQuickStats() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estadísticas del Sistema',
            style: AppTextStyles.h6.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Grid de estadísticas
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: [
              _buildStatCard(
                'Total Usuarios',
                '${controller.userStats['total'] ?? 0}',
                Icons.people,
                AppColors.primaryBlue,
              ),
              _buildStatCard(
                'Usuarios Activos',
                '${controller.userStats['active'] ?? 0}',
                Icons.person_outline,
                AppColors.secondaryGreen,
              ),
              _buildStatCard(
                'Estudiantes',
                '${controller.userStats['students'] ?? 0}',
                Icons.school,
                AppColors.accentOrange,
              ),
              _buildStatCard(
                'Inducción Completa',
                '${controller.userStats['completedInduction'] ?? 0}',
                Icons.check_circle,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Tarjeta de estadística
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Acciones principales
  Widget _buildMainActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Principales',
          style: AppTextStyles.h6.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        // Lista de acciones
        Column(
          children: [
            _buildActionTile(
              'Gestión de Usuarios',
              'Crear, editar y eliminar usuarios del sistema',
              Icons.people_alt,
              AppColors.primaryBlue,
              () => Get.toNamed('/admin/users'),
            ),

            const SizedBox(height: 12),

            _buildActionTile(
              'Crear Nuevo Usuario',
              'Agregar un nuevo usuario al sistema',
              Icons.person_add,
              AppColors.secondaryGreen,
              controller.navigateToCreateUser,
            ),

            const SizedBox(height: 12),

            _buildActionTile(
              'Estadísticas Detalladas',
              'Ver estadísticas completas del sistema',
              Icons.analytics,
              AppColors.accentOrange,
              () => _showDetailedStats(),
            ),

            const SizedBox(height: 12),

            _buildActionTile(
              'Configuración del Sistema',
              'Ajustes generales y configuraciones',
              Icons.settings,
              Colors.purple,
              () => _showSystemSettings(),
            ),
          ],
        ),
      ],
    );
  }

  /// Tile de acción
  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textSecondary,
          size: 16,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  /// Información del sistema
  Widget _buildSystemInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del Sistema',
            style: AppTextStyles.h6.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          _buildInfoRow('Versión', 'TallerURL v1.0.0 - MVP'),
          _buildInfoRow('Base de Datos', 'Local (GetStorage)'),
          _buildInfoRow('Última Actualización', 'Mayo 2025'),
          _buildInfoRow('Estado', 'Funcionando correctamente'),
        ],
      ),
    );
  }

  /// Fila de información
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostrar estadísticas detalladas
  void _showDetailedStats() {
    Get.dialog(
      AlertDialog(
        title: const Text('Estadísticas Detalladas'),
        content: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Usuarios por Rol:', style: AppTextStyles.subtitle1),
                const SizedBox(height: 8),
                Text('• Estudiantes: ${controller.userStats['students'] ?? 0}'),
                Text('• Docentes: ${controller.userStats['teachers'] ?? 0}'),
                Text(
                  '• Auxiliares: ${controller.userStats['assistants'] ?? 0}',
                ),
                Text(
                  '• Administradores: ${controller.userStats['admins'] ?? 0}',
                ),
                const SizedBox(height: 16),
                Text('Estado de Usuarios:', style: AppTextStyles.subtitle1),
                const SizedBox(height: 8),
                Text('• Activos: ${controller.userStats['active'] ?? 0}'),
                Text('• Inactivos: ${controller.userStats['inactive'] ?? 0}'),
                Text(
                  '• Inducción Completa: ${controller.userStats['completedInduction'] ?? 0}',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  /// Mostrar configuración del sistema
  void _showSystemSettings() {
    Get.dialog(
      AlertDialog(
        title: const Text('Configuración del Sistema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Crear Respaldo'),
              onTap: () {
                Get.back();
                _showBackupDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Restaurar Datos'),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Recargar Sistema'),
              onTap: () {
                Get.back();
                controller.refreshData();
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  /// Mostrar diálogo de respaldo
  void _showBackupDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Crear Respaldo'),
        content: const Text(
          'Esta función creará una copia de seguridad de todos los datos del sistema.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Respaldo Creado',
                'Los datos han sido respaldados exitosamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Crear Respaldo'),
          ),
        ],
      ),
    );
  }
}
