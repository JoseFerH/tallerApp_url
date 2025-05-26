import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../controllers/home_controller.dart';

/// Widget de tarjeta especial para funciones de administración
class AdminMenuCard extends GetView<HomeController> {
  const AdminMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlueDark,
          ],
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
            child: Column(
              children: [
                // Header con ícono y título
                Row(
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
                
                const SizedBox(height: 20),
                
                // Accesos rápidos del admin
                _buildAdminQuickActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Accesos rápidos para administrador
  Widget _buildAdminQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.people,
            label: 'Usuarios',
            onTap: () {
              // Navegar directamente a gestión de usuarios
              Get.toNamed('/admin/users');
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.bar_chart,
            label: 'Estadísticas',
            onTap: controller.navigateToAdminPanel,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.settings,
            label: 'Configuración',
            onTap: controller.navigateToAdminPanel,
          ),
        ),
      ],
    );
  }
  
  /// Botón de acción rápida
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.white,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}