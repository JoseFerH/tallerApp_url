// lib/app/modules/home/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../controllers/home_controller.dart';
import 'widgets/menu_card.dart';

/// Vista principal simplificada de la aplicación
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de bienvenida simplificado
            _buildWelcomeHeader(),

            const SizedBox(height: 24),

            // Mensaje de estado simplificado
            _buildStatusMessage(),

            const SizedBox(height: 24),

            // Título de acciones rápidas
            Text(
              Strings.quickActions,
              style: AppTextStyles.h5.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Grid de acciones rápidas - SIN OBX
            _buildQuickActionsGrid(),

            const SizedBox(height: 24),

            // Panel de admin (solo para administradores) - SIN OBX
            if (controller.isCurrentUserAdmin) ...[
              Text(
                'Panel de Administración',
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildAdminPanel(),
            ],
          ],
        ),
      ),
    );
  }

  /// AppBar simplificada
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        Strings.appName,
        style: AppTextStyles.h5.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Botón de notificaciones
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: controller.navigateToNotifications,
        ),

        // Botón de perfil simplificado
        PopupMenuButton<String>(
          icon: CircleAvatar(
            backgroundColor: AppColors.white,
            child: Text(
              controller.currentUser?.fullName.isNotEmpty == true
                  ? controller.currentUser!.fullName[0].toUpperCase()
                  : 'U',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onSelected: (value) {
            switch (value) {
              case 'logout':
                controller.showLogoutDialog();
                break;
            }
          },
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: 'profile',
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Perfil'),
                    subtitle: Text(controller.currentUserRole),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Cerrar Sesión',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
        ),
      ],
    );
  }

  /// Drawer simplificado
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header del drawer simplificado
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            accountName: Text(
              controller.currentUserName,
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              controller.currentUserRole,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white.withOpacity(0.8),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.white,
              child: Text(
                controller.currentUser?.fullName.isNotEmpty == true
                    ? controller.currentUser!.fullName[0].toUpperCase()
                    : 'U',
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Opciones del menú
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () => Get.back(),
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Herramientas'),
            onTap: () {
              Get.back();
              controller.navigateToTools();
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('Reservar'),
            onTap: () {
              Get.back();
              controller.navigateToReservations();
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_note),
            title: const Text('Mis Reservaciones'),
            onTap: () {
              Get.back();
              controller.navigateToMyReservations();
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Horarios'),
            onTap: () {
              Get.back();
              controller.navigateToSchedule();
            },
          ),
          ListTile(
            leading: const Icon(Icons.play_circle),
            title: const Text('Inducción'),
            onTap: () {
              Get.back();
              controller.navigateToInduction();
            },
          ),
          const Divider(),

          // Admin option (solo para administradores)
          if (controller.isCurrentUserAdmin)
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Administración'),
              onTap: () {
                Get.back();
                controller.navigateToAdminPanel();
              },
            ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Get.back();
              controller.showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  /// Header de bienvenida simplificado
  Widget _buildWelcomeHeader() {
    final greeting = _getTimeOfDayGreeting();
    final firstName =
        controller.currentUser?.fullName.split(' ').first ?? 'Usuario';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
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
          Text(
            '$greeting, $firstName',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                _getRoleIcon(),
                color: AppColors.white.withOpacity(0.9),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                controller.currentUserRole,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white.withOpacity(0.9),
                ),
              ),
              const Spacer(),
              if (!controller.hasCompletedInduction)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Inducción Pendiente',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 12,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Verificado',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Mensaje de estado simplificado
  Widget _buildStatusMessage() {
    String message;
    Color color;
    IconData icon;

    if (!controller.hasCompletedInduction) {
      message = '⚠️ Completa tu inducción para acceder a todas las funciones';
      color = AppColors.warning;
      icon = Icons.warning;
    } else {
      message = '✅ Todo al día - Bienvenido al taller';
      color = AppColors.success;
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  /// Grid de acciones rápidas - SIN OBX
  Widget _buildQuickActionsGrid() {
    final actions = controller.getQuickActions();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return MenuCard(
          title: action['title'],
          subtitle: action['subtitle'],
          icon: action['icon'],
          color: action['color'],
          onTap: action['action'],
          isPriority: action['priority'] ?? false,
        );
      },
    );
  }

  /// Panel de admin simplificado
  Widget _buildAdminPanel() {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.navigateToAdminPanel,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Panel de Administración',
                        style: AppTextStyles.subtitle1.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Gestión completa del sistema',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.white.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== MÉTODOS AUXILIARES ==========
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

  IconData _getRoleIcon() {
    final user = controller.currentUser;
    if (user?.isAdmin == true) {
      return Icons.admin_panel_settings;
    } else if (user?.isStaff == true) {
      return Icons.work;
    } else {
      return Icons.school;
    }
  }
}
