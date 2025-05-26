import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/values/strings.dart';
import '../../../../core/values/assets.dart';

/// Widget del logo de la Universidad Rafael Landívar
class URLLogo extends StatelessWidget {
  const URLLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Contenedor del logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              Assets.logoURL,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Widget de fallback si no se encuentra la imagen
                return Icon(
                  Icons.school,
                  size: 50,
                  color: AppColors.primaryBlue,
                );
              },
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Nombre de la universidad
        Text(
          Strings.universityName,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 4),
        
        // Nombre de la facultad
        Text(
          Strings.facultyName,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}