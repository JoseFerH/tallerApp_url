import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../../../core/utils/constants.dart';
import '../controllers/tools_controller.dart';
import 'widgets/tool_card.dart';
import 'widgets/tool_search_bar.dart';
import 'widgets/tool_category_tab.dart';

/// Vista del catálogo de herramientas
class ToolsCatalogView extends GetView<ToolsController> {
  const ToolsCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Barra de búsqueda
          const ToolSearchBar(),
          
          // Tabs de categorías
          _buildCategoryTabs(),
          
          // Lista de herramientas
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshTools,
              child: _buildToolsList(),
            ),
          ),
        ],
      ),
    );
  }
  
  /// AppBar personalizada
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        Strings.toolsTitle,
        style: AppTextStyles.h5.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Contador de herramientas
        Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.filteredToolsCount}/${controller.totalTools}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )),
        
        // Menú de opciones
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.white),
          onSelected: (value) {
            switch (value) {
              case 'clear_filters':
                controller.clearFilters();
                break;
              case 'refresh':
                controller.refreshTools();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'clear_filters',
              enabled: controller.hasActiveFilters,
              child: const ListTile(
                leading: Icon(Icons.clear_all),
                title: Text('Limpiar Filtros'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'refresh',
              child: ListTile(
                leading: Icon(Icons.refresh),
                title: Text('Actualizar'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// Tabs de categorías
  Widget _buildCategoryTabs() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Obx(() => ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Tab "Todas"
          ToolCategoryTab(
            category: null,
            isSelected: controller.selectedCategory.value == null,
            count: controller.totalTools,
            onTap: () => controller.filterByCategory(null),
          ),
          
          const SizedBox(width: 8),
          
          // Tabs por categoría
          ...ToolCategory.values.map((category) {
            final count = controller.categoryStats[category] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ToolCategoryTab(
                category: category,
                isSelected: controller.selectedCategory.value == category,
                count: count,
                onTap: () => controller.filterByCategory(category),
              ),
            );
          }),
        ],
      )),
    );
  }
  
  /// Lista de herramientas
  Widget _buildToolsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      
      if (controller.filteredTools.isEmpty) {
        return _buildEmptyState();
      }
      
      return Column(
        children: [
          // Información de filtros activos
          if (controller.hasActiveFilters) _buildActiveFiltersInfo(),
          
          // Lista de herramientas
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.filteredTools.length,
              itemBuilder: (context, index) {
                final tool = controller.filteredTools[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ToolCard(
                    tool: tool,
                    onTap: () => controller.selectTool(tool),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
  
  /// Estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              controller.hasActiveFilters
                  ? 'No se encontraron herramientas'
                  : Strings.toolsEmptyState,
              style: AppTextStyles.h6.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (controller.hasActiveFilters) ...[
              Text(
                'Intenta ajustar los filtros de búsqueda',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.clearFilters,
                child: const Text('Limpiar Filtros'),
              ),
            ] else ...[
              Text(
                'Actualiza la aplicación para ver las herramientas disponibles',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.refreshTools,
                child: const Text('Actualizar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Información de filtros activos
  Widget _buildActiveFiltersInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              controller.activeFilterText,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          IconButton(
            onPressed: controller.clearFilters,
            icon: Icon(
              Icons.clear,
              color: AppColors.primaryBlue,
              size: 20,
            ),
            tooltip: 'Limpiar filtros',
          ),
        ],
      ),
    );
  }
}