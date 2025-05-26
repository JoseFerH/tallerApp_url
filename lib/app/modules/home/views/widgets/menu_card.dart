import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Widget de tarjeta para el menú principal
class MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isPriority;
  final bool isEnabled;
  
  const MenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isPriority = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: isPriority
              ? Border.all(color: color, width: 2)
              : Border.all(color: AppColors.cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: isPriority
                  ? color.withOpacity(0.2)
                  : AppColors.cardShadow,
              offset: const Offset(0, 4),
              blurRadius: isPriority ? 12 : 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onTap : null,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Contenedor del ícono
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? color.withOpacity(0.1)
                          : AppColors.mediumGray.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: isEnabled
                          ? color
                          : AppColors.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Título
                  Text(
                    title,
                    style: AppTextStyles.subtitle1.copyWith(
                      color: isEnabled
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Subtítulo
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: isEnabled
                          ? AppColors.textSecondary
                          : AppColors.textLight,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Indicador de prioridad
                  if (isPriority) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '¡Importante!',
                        style: AppTextStyles.overline.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}