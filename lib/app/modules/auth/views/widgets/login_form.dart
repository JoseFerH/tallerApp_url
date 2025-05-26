import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/values/strings.dart';
import '../../controllers/auth_controller.dart';

/// Widget del formulario de login
class LoginForm extends GetView<AuthController> {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Form(
        key: controller.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título del formulario
            _buildFormTitle(),
            
            const SizedBox(height: 24),
            
            // Campo de nombre completo
            _buildFullNameField(),
            
            const SizedBox(height: 16),
            
            // Campo de contraseña (carné)
            _buildPasswordField(),
            
            const SizedBox(height: 8),
            
            // Mensaje de error
            _buildErrorMessage(),
            
            const SizedBox(height: 16),
            
            // Checkbox recordar credenciales
            _buildRememberCredentials(),
            
            const SizedBox(height: 24),
            
            // Botón de login
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }
  
  /// Título del formulario
  Widget _buildFormTitle() {
    return Column(
      children: [
        Text(
          Strings.loginTitle,
          style: AppTextStyles.h5.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 3,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.accentOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
  
  /// Campo de nombre completo
  Widget _buildFullNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.usernameLabel,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.fullNameController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: Strings.usernameHint,
            prefixIcon: const Icon(Icons.person_outline),
            suffixIcon: Obx(() => controller.fullNameController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.fullNameController.clear();
                      controller.clearError();
                    },
                  )
                : const SizedBox.shrink(),
            ),
          ),
          validator: controller.validateFullName,
          onChanged: (_) => controller.clearError(),
        ),
      ],
    );
  }
  
  /// Campo de contraseña (carné)
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.passwordLabel,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextFormField(
          controller: controller.passwordController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          obscureText: !controller.isPasswordVisible.value,
          decoration: InputDecoration(
            hintText: Strings.passwordHint,
            prefixIcon: const Icon(Icons.badge_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
          validator: controller.validatePassword,
          onChanged: (_) => controller.clearError(),
          onFieldSubmitted: (_) => controller.login(),
        )),
      ],
    );
  }
  
  /// Mensaje de error
  Widget _buildErrorMessage() {
    return Obx(() {
      if (controller.errorMessage.value.isEmpty) {
        return const SizedBox.shrink();
      }
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.error.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                controller.errorMessage.value,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
  
  /// Checkbox para recordar credenciales
  Widget _buildRememberCredentials() {
    return Obx(() => Row(
      children: [
        Checkbox(
          value: controller.rememberCredentials.value,
          onChanged: (_) => controller.toggleRememberCredentials(),
          activeColor: AppColors.primaryBlue,
        ),
        Expanded(
          child: GestureDetector(
            onTap: controller.toggleRememberCredentials,
            child: Text(
              'Recordar mis credenciales',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    ));
  }
  
  /// Botón de login
  Widget _buildLoginButton() {
    return Obx(() => SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: controller.isLoading.value
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.login),
                  const SizedBox(width: 8),
                  Text(
                    Strings.loginButton,
                    style: AppTextStyles.buttonLarge,
                  ),
                ],
              ),
      ),
    ));
  }
}