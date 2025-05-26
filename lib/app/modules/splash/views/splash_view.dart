import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../../../core/values/assets.dart';
import '../controllers/splash_controller.dart';

/// Vista de la pantalla de splash/carga inicial
class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Espaciado superior
              const Spacer(flex: 2),

              // Logo y branding
              _buildBrandingSection(),

              const Spacer(flex: 1),

              // Indicador de carga y mensaje
              _buildLoadingSection(),

              const Spacer(flex: 2),

              // Footer con información universitaria
              _buildFooterSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Sección de branding con logo y título
  Widget _buildBrandingSection() {
    return Column(
      children: [
        // Logo de la Universidad
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              Assets.logoURL,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.school,
                  size: 60,
                  color: AppColors.primaryBlue,
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Título de la aplicación
        Text(
          Strings.appName,
          style: AppTextStyles.h1.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),

        const SizedBox(height: 8),

        // Subtítulo
        Text(
          Strings.tagline,
          style: AppTextStyles.subtitle1.copyWith(
            color: AppColors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Sección de carga con indicador y mensaje
  Widget _buildLoadingSection() {
    return Obx(
      () => Column(
        children: [
          // Indicador de carga circular
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.white.withOpacity(0.8),
              ),
              backgroundColor: AppColors.white.withOpacity(0.2),
            ),
          ),

          const SizedBox(height: 24),

          // Mensaje de carga
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              controller.loadingMessage.value,
              key: ValueKey(controller.loadingMessage.value),
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Sección footer con información universitaria
  Widget _buildFooterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          // Nombre de la universidad
          Text(
            Strings.universityName,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // Facultad
          Text(
            Strings.facultyName,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Versión de la app
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'v1.0.0 - MVP',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white.withOpacity(0.6),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
