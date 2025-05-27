import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../controllers/induction_controller.dart';

/// Widget para mostrar un video de inducción en la lista
class VideoItem extends StatelessWidget {
  final InductionVideo video;
  final bool isWatched;
  final VoidCallback onTap;
  final VoidCallback? onMarkWatched;

  const VideoItem({
    Key? key,
    required this.video,
    required this.isWatched,
    required this.onTap,
    this.onMarkWatched,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isWatched ? 1 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isWatched
                  ? AppColors.success.withOpacity(0.3)
                  : video.isRequired
                  ? AppColors.primaryBlue.withOpacity(0.3)
                  : AppColors.cardBorder,
          width: isWatched ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildDescription(),
              const SizedBox(height: 12),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildThumbnail(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      video.title,
                      style: AppTextStyles.h6.copyWith(
                        color:
                            isWatched
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (video.isRequired) _buildRequiredBadge(),
                ],
              ),
              const SizedBox(height: 4),
              _buildMetadata(),
            ],
          ),
        ),
        _buildStatusIcon(),
      ],
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.mediumGray,
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage('assets/images/video_thumbnail_placeholder.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Overlay oscuro
          Container(
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          // Botón de play
          Center(
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isWatched ? Icons.check : Icons.play_arrow,
                color: isWatched ? AppColors.success : AppColors.primaryBlue,
                size: 16,
              ),
            ),
          ),

          // Duración
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _formatDuration(video.duration),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Text(
        'REQUERIDO',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        Icon(Icons.category_outlined, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          video.category.toUpperCase(),
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 12),
        Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(_formatDuration(video.duration), style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      video.description,
      style: AppTextStyles.bodySmall.copyWith(
        color: isWatched ? AppColors.textSecondary : AppColors.textPrimary,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Expanded(child: _buildProgressIndicator()),
        const SizedBox(width: 12),
        if (!isWatched && onMarkWatched != null)
          OutlinedButton.icon(
            onPressed: onMarkWatched,
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Marcar como visto'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.success,
              side: const BorderSide(color: AppColors.success),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(0, 32),
            ),
          ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        Icon(
          isWatched ? Icons.check_circle : Icons.play_circle_outline,
          size: 16,
          color: isWatched ? AppColors.success : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          isWatched ? 'Completado' : 'Pendiente',
          style: AppTextStyles.caption.copyWith(
            color: isWatched ? AppColors.success : AppColors.textSecondary,
            fontWeight: isWatched ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIcon() {
    if (isWatched) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 20,
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.play_arrow,
        color: AppColors.primaryBlue,
        size: 20,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}
