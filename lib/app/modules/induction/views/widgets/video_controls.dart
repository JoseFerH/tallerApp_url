import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Controles personalizados para el reproductor de video
class VideoControls extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback? onPlayPause;
  final VoidCallback? onRestart;
  final VoidCallback? onMarkCompleted;
  final bool showMarkCompleted;

  const VideoControls({
    Key? key,
    required this.controller,
    this.onPlayPause,
    this.onRestart,
    this.onMarkCompleted,
    this.showMarkCompleted = true,
  }) : super(key: key);

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, AppColors.black.withOpacity(0.7)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _toggleControlsVisibility,
                child: Container(
                  color: Colors.transparent,
                  child: Center(child: _buildPlayPauseButton()),
                ),
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        return Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.black.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: widget.onPlayPause ?? _togglePlayPause,
            icon: Icon(
              value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: AppColors.white,
              size: 32,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProgressBar(),
          const SizedBox(height: 12),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        final position = value.position;
        final duration = value.duration;

        return Column(
          children: [
            // Barra de progreso
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.primaryBlue,
                inactiveTrackColor: AppColors.white.withOpacity(0.3),
                thumbColor: AppColors.primaryBlue,
                overlayColor: AppColors.primaryBlue.withOpacity(0.3),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value:
                    duration.inMilliseconds > 0
                        ? position.inMilliseconds / duration.inMilliseconds
                        : 0.0,
                onChanged: (value) {
                  final newPosition = Duration(
                    milliseconds: (value * duration.inMilliseconds).round(),
                  );
                  widget.controller.seekTo(newPosition);
                },
              ),
            ),

            // Tiempo actual / tiempo total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(position),
                  style: AppTextStyles.caption.copyWith(color: AppColors.white),
                ),
                Text(
                  _formatDuration(duration),
                  style: AppTextStyles.caption.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Reiniciar
        IconButton(
          onPressed: widget.onRestart ?? _restartVideo,
          icon: const Icon(Icons.replay, color: AppColors.white, size: 28),
          tooltip: 'Reiniciar video',
        ),

        // Retroceder 10 segundos
        IconButton(
          onPressed: _seekBackward,
          icon: const Icon(Icons.replay_10, color: AppColors.white, size: 28),
          tooltip: 'Retroceder 10s',
        ),

        // Play/Pause (duplicado)
        ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: widget.controller,
          builder: (context, value, child) {
            return IconButton(
              onPressed: widget.onPlayPause ?? _togglePlayPause,
              icon: Icon(
                value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.white,
                size: 32,
              ),
              tooltip: value.isPlaying ? 'Pausar' : 'Reproducir',
            );
          },
        ),

        // Avanzar 10 segundos
        IconButton(
          onPressed: _seekForward,
          icon: const Icon(Icons.forward_10, color: AppColors.white, size: 28),
          tooltip: 'Avanzar 10s',
        ),

        // Marcar como completado
        if (widget.showMarkCompleted)
          IconButton(
            onPressed: widget.onMarkCompleted,
            icon: const Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 28,
            ),
            tooltip: 'Marcar como visto',
          ),
      ],
    );
  }

  void _toggleControlsVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });

    // Auto-ocultar después de 3 segundos si está visible
    if (_isVisible) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      });
    }
  }

  void _togglePlayPause() {
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
    } else {
      widget.controller.play();
    }
  }

  void _restartVideo() {
    widget.controller.seekTo(Duration.zero);
    widget.controller.play();
  }

  void _seekBackward() {
    final currentPosition = widget.controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    widget.controller.seekTo(
      newPosition < Duration.zero ? Duration.zero : newPosition,
    );
  }

  void _seekForward() {
    final currentPosition = widget.controller.value.position;
    final duration = widget.controller.value.duration;
    final newPosition = currentPosition + const Duration(seconds: 10);
    widget.controller.seekTo(newPosition > duration ? duration : newPosition);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
