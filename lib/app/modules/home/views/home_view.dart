import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../controllers/home_controller.dart';
import 'widgets/welcome_header.dart';
import 'widgets/menu_card.dart';
import 'widgets/admin_menu_card.dart';

/// Vista principal de la aplicación
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header de bienvenida
              const WelcomeHeader(),
              
              const SizedBox(height: 24),
              
              // Mensaje de estado del usuario
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
              
              // Grid de acciones rápidas
              _buildQuickActionsGrid(),
              
              const SizedBox(height: 24),
              
              // Próximas reservaciones (si las hay)
              Obx(() {
                if (controller.upcomingReservations.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Próximas Reservaciones',
                        style: AppTextStyles.h6.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildUpcomingReservations(),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
              
              // Panel de admin (solo para administradores)
              Obx(() {
                if (controller.isCurrentUserAdmin) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Panel de Administración',
                        style: AppTextStyles.h6.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const AdminMenuCard(),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
              
              // Estadísticas rápidas (para staff)
              Obx(() {
                if (controller.isCurrentUserStaff && controller.quickStats.isNotEmpty) {
                  return Column(
                    children: [
                      _buildQuickStats(),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
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
        
        // Botón de perfil/menú
        Obx(() => PopupMenuButton<String>(
          icon: CircleAvatar(
            backgroundColor: AppColors.white,
            child: Text(
              controller.currentUserName.isNotEmpty 
                  ? controller.currentUserName[0].toUpperCase()
                  : 'U',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onSelected: (value) {
            switch (value) {
              case 'profile':
                // Navegar al perfil (futuro)
                break;
              case 'settings':
                // Navegar a configuración (futuro)
                break;
              case 'logout':
                controller.showLogoutDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Perfil'),
                subtitle: Text(controller.currentUserRole),
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configuración'),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        )),
      ],
    );
  }
  
  /// Drawer lateral
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header del drawer
          Obx(() => UserAccountsDrawerHeader(
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
                controller.currentUserName.isNotEmpty 
                    ? controller.currentUserName[0].toUpperCase()
                    : 'U',
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )),
          
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
          Obx(() {
            if (controller.isCurrentUserAdmin) {
              return ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Administración'),
                onTap: () {
                  Get.back();
                  controller.navigateToAdminPanel();
                },
              );
            }
            return const SizedBox.shrink();
          }),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              Get.back();
              controller.showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }
  
  /// Mensaje de estado del usuario
  Widget _buildStatusMessage() {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: controller.hasCompletedInduction 
            ? AppColors.success.withOpacity(0.1)
            : AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: controller.hasCompletedInduction 
              ? AppColors.success.withOpacity(0.3)
              : AppColors.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            controller.hasCompletedInduction 
                ? Icons.check_circle
                : Icons.warning,
            color: controller.hasCompletedInduction 
                ? AppColors.success
                : AppColors.warning,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.getUserStatusMessage(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: controller.hasCompletedInduction 
                    ? AppColors.success
                    : AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    ));
  }
  
  /// Grid de acciones rápidas
  Widget _buildQuickActionsGrid() {
    return Obx(() {
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
    });
  }
  
  /// Próximas reservaciones
  Widget _buildUpcomingReservations() {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.upcomingReservations.length,
      itemBuilder: (context, index) {
        final reservation = controller.upcomingReservations[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
              child: Icon(
                Icons.event,
                color: AppColors.primaryBlue,
              ),
            ),
            title: Text(
              reservation.zone.displayName,
              style: AppTextStyles.subtitle1,
            ),
            subtitle: Text(
              reservation.formattedDateTime,
              style: AppTextStyles.caption,
            ),
            trailing: Text(
              reservation.timeUntilReservation,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: controller.navigateToMyReservations,
          ),
        );
      },
    ));
  }
  
  /// Estadísticas rápidas
  Widget _buildQuickStats() {
    return Obx(() {
      final stats = controller.quickStats;
      if (stats.isEmpty) return const SizedBox.shrink();
      
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estadísticas del Taller',
                style: AppTextStyles.h6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (stats['totalTools'] != null) ...[
                    Expanded(
                      child: _buildStatItem(
                        'Herramientas',
                        '${stats['availableTools']}/${stats['totalTools']}',
                        Icons.build,
                        AppColors.primaryBlue,
                      ),
                    ),
                  ],
                  if (stats['todayReservations'] != null) ...[
                    Expanded(
                      child: _buildStatItem(
                        'Hoy',
                        '${stats['todayReservations']}',
                        Icons.today,
                        AppColors.secondaryGreen,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
  
  /// Item de estadística
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.h5.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}