import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/induction_controller.dart';
import '../../../routes/app_routes.dart';
import 'widgets/video_item.dart';

/// Vista principal de videos de inducción
class InductionView extends GetView<InductionController> {
  const InductionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.simple(Strings.inductionTitle),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchAndFilters(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundSecondary,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Videos de Inducción', style: AppTextStyles.h5),
          const SizedBox(height: 8),
          Obx(() => _buildProgressCard()),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final progress = controller.inductionProgress;
    final isCompleted = controller.isInductionCompleted;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isCompleted
                ? AppColors.success.withOpacity(0.1)
                : AppColors.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isCompleted
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.primaryBlue.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.school,
            color: isCompleted ? AppColors.success : AppColors.primaryBlue,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCompleted
                      ? '¡Inducción Completada!'
                      : 'Progreso de Inducción',
                  style: AppTextStyles.h6.copyWith(
                    color:
                        isCompleted ? AppColors.success : AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCompleted
                      ? 'Has completado todos los videos requeridos'
                      : '${(progress * 100).toInt()}% completado',
                  style: AppTextStyles.bodySmall,
                ),
                if (!isCompleted) ...[
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.mediumGray,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryBlue,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: AppColors.backgroundPrimary,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Barra de búsqueda
          CustomTextField.search(
            hint: 'Buscar videos...',
            onChanged: controller.updateSearch,
            onClear: controller.clearSearch,
          ),
          const SizedBox(height: 12),

          // Filtros por categoría
          _buildCategoryFilters(),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Obx(() {
      final categories = controller.categories;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              categories.map((category) {
                final isSelected = controller.selectedCategory == category;
                final displayName = _getCategoryDisplayName(category);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(displayName),
                    selected: isSelected,
                    onSelected: (_) => controller.selectCategory(category),
                    backgroundColor: AppColors.mediumGray.withOpacity(0.5),
                    selectedColor: AppColors.primaryBlue.withOpacity(0.2),
                    checkmarkColor: AppColors.primaryBlue,
                    labelStyle: AppTextStyles.labelMedium.copyWith(
                      color:
                          isSelected
                              ? AppColors.primaryBlue
                              : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
        ),
      );
    });
  }

  Widget _buildContent() {
    return Obx(() {
      if (controller.isLoading) {
        return LoadingWidget.center(message: 'Cargando videos...');
      }

      final filteredVideos = controller.filteredVideos;

      if (filteredVideos.isEmpty) {
        if (controller.searchQuery.isNotEmpty) {
          return EmptyStateWidget.search(
            searchTerm: controller.searchQuery,
            onClearSearch: controller.clearSearch,
          );
        }

        return EmptyStateWidget.custom(
          title: 'Sin videos disponibles',
          message: 'No hay videos de inducción disponibles en este momento.',
          icon: Icons.video_library,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: CustomScrollView(
          slivers: [
            // Videos requeridos
            if (controller.requiredVideos.isNotEmpty &&
                controller.selectedCategory == 'all') ...[
              _buildSectionHeader('Videos Requeridos', true),
              _buildVideosList(
                controller.requiredVideos
                    .where((video) => _matchesSearch(video))
                    .toList(),
              ),
            ],

            // Videos opcionales
            if (controller.optionalVideos.isNotEmpty &&
                controller.selectedCategory == 'all') ...[
              _buildSectionHeader('Videos Opcionales', false),
              _buildVideosList(
                controller.optionalVideos
                    .where((video) => _matchesSearch(video))
                    .toList(),
              ),
            ],

            // Todos los videos filtrados (cuando hay filtro activo)
            if (controller.selectedCategory != 'all') ...[
              _buildVideosList(filteredVideos),
            ],

            // Espacio adicional al final
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title, bool isRequired) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            Icon(
              isRequired ? Icons.star : Icons.play_circle_outline,
              color: isRequired ? AppColors.error : AppColors.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.h6.copyWith(
                color: isRequired ? AppColors.error : AppColors.primaryBlue,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'OBLIGATORIOS',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.error,
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

  Widget _buildVideosList(List<InductionVideo> videos) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final video = videos[index];
        final isWatched = controller.isVideoWatched(video.id);

        return VideoItem(
          video: video,
          isWatched: isWatched,
          onTap: () => _openVideo(video),
          onMarkWatched: () => controller.markVideoAsWatched(video.id),
        );
      }, childCount: videos.length),
    );
  }

  void _openVideo(InductionVideo video) {
    Get.toNamed(AppRoutes.VIDEO_PLAYER, arguments: {'video': video});
  }

  bool _matchesSearch(InductionVideo video) {
    final query = controller.searchQuery.toLowerCase();
    if (query.isEmpty) return true;

    return video.title.toLowerCase().contains(query) ||
        video.description.toLowerCase().contains(query) ||
        video.category.toLowerCase().contains(query);
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'all':
        return 'Todos';
      case 'básico':
        return 'Básico';
      case 'seguridad':
        return 'Seguridad';
      case 'herramientas':
        return 'Herramientas';
      case 'normas':
        return 'Normas';
      default:
        return category.toUpperCase();
    }
  }
}
