import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/values/strings.dart';
import '../../controllers/tools_controller.dart';

/// Widget de barra de búsqueda para herramientas
class ToolSearchBar extends GetView<ToolsController> {
  const ToolSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: Column(
        children: [
          // Campo de búsqueda principal
          _buildSearchField(),
          
          // Sugerencias de búsqueda (si el campo está vacío)
          Obx(() => controller.searchQuery.value.isEmpty
              ? _buildSearchSuggestions()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
  
  /// Campo de búsqueda principal
  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.searchTools,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: Strings.toolsSearchHint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
          ),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  onPressed: controller.clearSearch,
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
                  ),
                  tooltip: 'Limpiar búsqueda',
                )
              : const SizedBox.shrink()),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
  
  /// Sugerencias de búsqueda
  Widget _buildSearchSuggestions() {
    final suggestions = controller.getSearchSuggestions();
    
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Búsquedas sugeridas:',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) {
              return _buildSuggestionChip(suggestion);
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  /// Chip de sugerencia
  Widget _buildSuggestionChip(String suggestion) {
    return GestureDetector(
      onTap: () => controller.searchWithSuggestion(suggestion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 14,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 4),
            Text(
              suggestion,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}