import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/values/strings.dart';
import '../../controllers/tools_controller.dart';

/// Widget de tab para filtrar herramientas por categoría
class ToolCategoryTab extends GetView<ToolsController> {
  final ToolCategory? category;
  final bool isSelected;
  final int count;
  final VoidCallback onTap;
  
  const ToolCategoryTab({
    super.key,
    required this.category,
    required this.isSelected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? _getColor()
              : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? _getColor()
                : AppColors.cardBorder,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _getColor().withOpacity(0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono
            Icon(
              _getIcon(),
              size: 18,
              color: isSelected
                  ? AppColors.white
                  : _getColor(),
            ),
            
            const SizedBox(width: 8),
            
            // Texto
            Text(
              _getLabel(),
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.white
                    : AppColors.textPrimary,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.w500,
              ),
            ),
            
            // Contador
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.white.withOpacity(0.3)
                      : AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected
                        ? AppColors.white
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Obtener color según la categoría
  Color _getColor() {
    if (category == null) {
      return AppColors.primaryBlue;
    }
    
    return controller.getCategoryColor(category!);
  }
  
  /// Obtener ícono según la categoría
  IconData _getIcon() {
    if (category == null) {
      return Icons.all_inclusive;
    }
    
    return controller.getCategoryIcon(category!);
  }
  
  /// Obtener etiqueta según la categoría
  String _getLabel() {
    if (category == null) {
      return Strings.toolsFilterAll;
    }
    
    switch (category!) {
      case ToolCategory.manuales:
        return Strings.toolsFilterManual;
      case ToolCategory.electricas:
        return Strings.toolsFilterElectric;
      case ToolCategory.medicion:
        return Strings.toolsFilterMeasurement;
      case ToolCategory.seguridad:
        return Strings.toolsFilterSafety;
    }
  }
}