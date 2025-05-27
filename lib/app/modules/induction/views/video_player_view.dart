import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/induction_controller.dart';
import 'widgets/video_controls.dart';

/// Vista del reproductor de video de inducción
class VideoPlayerView extends GetView<InductionController> {
  const VideoPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener video desde argumentos
    final arguments = Get.arguments as Map<String, dynamic>?;
    final InductionVideo? video = arguments?['video'];

    if (video == null) {
      return Scaffold(
        appBar: CustomAppBar.simple('Error'),
        body: const Center(child: Text('Video no encontrado')),
      );
    }

    return VideoPlayerWrapper(video: video);
  }
}

/// Wrapper con estado para el reproductor de video
class VideoPlayerWrapper extends StatefulWidget {
  final InductionVideo video;

  const VideoPlayerWrapper({Key? key, required this.video}) : super(key: key);

  @override
  State<VideoPlayerWrapper> createState() => _VideoPlayerWrapperState();
}

class _VideoPlayerWrapperState extends State<VideoPlayerWrapper> {
  VideoPlayerController? _videoController;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    // Restaurar orientación normal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    try {
      // En un MVP real, aquí cargarías el video desde assets o red
      // Por ahora simulamos la carga con un delay
      await Future.delayed(const Duration(seconds: 2));

      // Como es un MVP sin videos reales, simulamos un video
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        ),
      );

      await _videoController!.initialize();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error cargando el video: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar:
          _isFullscreen
              ? null
              : CustomAppBar(
                title: widget.video.title,
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.white,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.fullscreen),
                    onPressed: _toggleFullscreen,
                    tooltip: 'Pantalla completa',
                  ),
                ],
              ),
      body: Column(
        children: [
          // Reproductor de video
          Expanded(flex: _isFullscreen ? 1 : 3, child: _buildVideoPlayer()),

          // Información del video (oculta en pantalla completa)
          if (!_isFullscreen) Expanded(flex: 2, child: _buildVideoInfo()),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isLoading) {
      return Container(
        color: AppColors.black,
        child: LoadingWidget.center(
          message: 'Cargando video...',
          indicatorColor: AppColors.white,
        ),
      );
    }

    if (_hasError) {
      return Container(
        color: AppColors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.white, size: 64),
              const SizedBox(height: 16),
              Text(
                'Error al cargar el video',
                style: AppTextStyles.h6.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _initializeVideo,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_videoController == null || !_videoController!.value.isInitialized) {
      return Container(
        color: AppColors.black,
        child: LoadingWidget.center(
          message: 'Preparando video...',
          indicatorColor: AppColors.white,
        ),
      );
    }

    return Container(
      color: AppColors.black,
      child: Stack(
        children: [
          // Video player
          Center(
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),

          // Controles de video
          Positioned.fill(
            child: VideoControls(
              controller: _videoController!,
              onMarkCompleted: _markVideoAsCompleted,
              showMarkCompleted:
                  !Get.find<InductionController>().isVideoWatched(
                    widget.video.id,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Container(
      color: AppColors.backgroundPrimary,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(widget.video.title, style: AppTextStyles.h5),
            const SizedBox(height: 8),

            // Metadata
            Row(
              children: [
                _buildMetadataChip(
                  Icons.category,
                  widget.video.category.toUpperCase(),
                  AppColors.primaryBlue,
                ),
                const SizedBox(width: 8),
                _buildMetadataChip(
                  Icons.access_time,
                  _formatDuration(widget.video.duration),
                  AppColors.neutralGray,
                ),
                if (widget.video.isRequired) ...[
                  const SizedBox(width: 8),
                  _buildMetadataChip(Icons.star, 'REQUERIDO', AppColors.error),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Descripción
            Text('Descripción', style: AppTextStyles.h6),
            const SizedBox(height: 8),
            Text(widget.video.description, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),

            // Estado de visualización
            _buildViewingStatus(),

            const SizedBox(height: 24),

            // Botón para marcar como visto
            if (!Get.find<InductionController>().isVideoWatched(
              widget.video.id,
            ))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _markVideoAsCompleted,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Marcar como Completado'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewingStatus() {
    final isWatched = Get.find<InductionController>().isVideoWatched(
      widget.video.id,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isWatched
                ? AppColors.success.withOpacity(0.1)
                : AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              isWatched
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.warning.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isWatched ? Icons.check_circle : Icons.pending,
            color: isWatched ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isWatched ? 'Video Completado' : 'Video Pendiente',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isWatched ? AppColors.success : AppColors.warning,
                  ),
                ),
                Text(
                  isWatched
                      ? 'Has marcado este video como visto'
                      : 'Marca este video como visto cuando lo hayas completado',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markVideoAsCompleted() async {
    final confirmed = await CustomDialog.showConfirmation(
      title: 'Marcar como Completado',
      message:
          '¿Has terminado de ver este video?\n\nEsto se registrará en tu progreso de inducción.',
      confirmText: 'Sí, completado',
      cancelText: 'Cancelar',
    );

    if (confirmed == true) {
      await Get.find<InductionController>().markVideoAsWatched(widget.video.id);
      setState(() {}); // Actualizar UI
    }
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}
