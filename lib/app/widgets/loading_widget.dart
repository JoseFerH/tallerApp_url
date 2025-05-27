import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'dart:math' as math;

/// Widget de carga personalizado reutilizable
class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool showBackground;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double size;
  final EdgeInsetsGeometry? padding;

  const LoadingWidget({
    Key? key,
    this.message,
    this.showBackground = true,
    this.backgroundColor,
    this.indicatorColor,
    this.size = 40.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              indicatorColor ?? AppColors.primaryBlue,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    if (showBackground) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: content,
      );
    }

    return content;
  }

  /// Loading simple para usar en centro de pantalla
  static Widget center({
    String? message,
    Color? indicatorColor,
    double size = 40.0,
  }) {
    return Center(
      child: LoadingWidget(
        message: message,
        indicatorColor: indicatorColor,
        size: size,
        showBackground: false,
      ),
    );
  }

  /// Loading para usar en listas
  static Widget listItem({String? message, EdgeInsetsGeometry? padding}) {
    return LoadingWidget(
      message: message,
      showBackground: false,
      size: 24,
      padding: padding ?? const EdgeInsets.all(16),
    );
  }

  /// Loading con fondo overlay
  static Widget overlay({String? message, Color? overlayColor}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: overlayColor ?? AppColors.black.withOpacity(0.5),
      child: LoadingWidget.center(
        message: message,
        indicatorColor: AppColors.white,
      ),
    );
  }

  /// Loading para botones
  static Widget button({Color? color, double size = 20.0}) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.white),
      ),
    );
  }

  /// Loading para tarjetas
  static Widget card({String? message, EdgeInsetsGeometry? padding}) {
    return Card(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(24),
        child: LoadingWidget(message: message, showBackground: false),
      ),
    );
  }
}

/// Widget de carga con puntos animados
class LoadingDots extends StatefulWidget {
  final Color? color;
  final double size;
  final Duration duration;

  const LoadingDots({
    Key? key,
    this.color,
    this.size = 8.0,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final opacity = (0.4 +
                    0.6 *
                        (0.5 +
                            0.5 *
                                math.sin(
                                  (_controller.value * 2 * math.pi) -
                                      delay * 2 * math.pi,
                                )))
                .clamp(0.0, 1.0);

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.size * 0.2),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color ?? AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Placeholder con shimmer effect
class ShimmerPlaceholder extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerPlaceholder({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                AppColors.lightGray,
                AppColors.mediumGray,
                AppColors.lightGray,
              ],
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
