import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../../../core/values/assets.dart';
import '../controllers/auth_controller.dart';
import 'widgets/login_form.dart';
import 'widgets/url_logo.dart';

/// Vista de inicio de sesión
class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Logo y branding de la universidad
              const URLLogo(),
              
              const SizedBox(height: 40),
              
              // Título de bienvenida
              _buildWelcomeSection(),
              
              const SizedBox(height: 32),
              
              // Formulario de login
              const LoginForm(),
              
              const SizedBox(height: 24),
              
              // Información adicional
              _buildInfoSection(),
              
              const SizedBox(height: 40),
              
              // Footer con información de la app
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Sección de bienvenida
  Widget _buildWelcomeSection() {
    return Column(
      children: [
        Text(
          Strings.welcomeTitle,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        Text(
          Strings.welcomeSubtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  /// Sección de información
  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundAccent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Información de Acceso',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          _buildInfoItem(
            'Nombre Completo',
            'Usa tu nombre completo como aparece en el registro universitario',
          ),
          
          const SizedBox(height: 8),
          
          _buildInfoItem(
            'Carné Universitario',
            'Ingresa tu carné de 7 dígitos como contraseña',
          ),
          
          const SizedBox(height: 12),
          
          // Botones de acceso rápido para testing
          if (Get.isLogModeActive) ...[
            const Divider(),
            const SizedBox(height: 8),
            _buildQuickAccessButtons(),
          ],
        ],
      ),
    );
  }
  
  /// Item de información
  Widget _buildInfoItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Botones de acceso rápido (solo para testing)
  Widget _buildQuickAccessButtons() {
    return Column(
      children: [
        Text(
          'Acceso Rápido (Testing)',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => controller.autoLoginForTesting(userType: 'admin'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  'Admin',
                  style: AppTextStyles.labelSmall,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => controller.autoLoginForTesting(userType: 'student1'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  'Emily',
                  style: AppTextStyles.labelSmall,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => controller.autoLoginForTesting(userType: 'student2'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  'Eileen',
                  style: AppTextStyles.labelSmall,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// Footer con información de la app
  Widget _buildFooter() {
    return Column(
      children: [
        Divider(
          color: AppColors.cardBorder,
          thickness: 1,
        ),
        
        const SizedBox(height: 16),
        
        Text(
          'Desarrollado para',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        
        const SizedBox(height: 4),
        
        Text(
          Strings.universityName,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        
        Text(
          Strings.facultyName,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.mediumGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Versión 1.0.0 - MVP',
            style: AppTextStyles.overline.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}