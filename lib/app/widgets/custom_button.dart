import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Tipos de botón personalizado
enum CustomButtonType {
  primary,
  secondary,
  outline,
  text,
  danger,
  success,
  warning,
}

/// Tamaños de botón
enum CustomButtonSize { small, medium, large }

/// Botón personalizado reutilizable
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final CustomButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle();
    final buttonPadding = padding ?? _getPadding();

    Widget child = _buildContent(textStyle);

    if (isFullWidth) {
      child = SizedBox(width: double.infinity, child: child);
    }

    switch (type) {
      case CustomButtonType.primary:
      case CustomButtonType.danger:
      case CustomButtonType.success:
      case CustomButtonType.warning:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );

      case CustomButtonType.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );

      case CustomButtonType.text:
      case CustomButtonType.secondary:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );
    }
  }

  Widget _buildContent(TextStyle textStyle) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == CustomButtonType.outline ||
                        type == CustomButtonType.text
                    ? _getColor()
                    : AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('Cargando...', style: textStyle),
        ],
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: _getIconSize(), height: _getIconSize(), child: icon),
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }

  ButtonStyle _getButtonStyle() {
    final color = _getColor();
    final borderRadius = this.borderRadius ?? 8.0;

    switch (type) {
      case CustomButtonType.primary:
      case CustomButtonType.danger:
      case CustomButtonType.success:
      case CustomButtonType.warning:
        return ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          padding: _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 2,
        );

      case CustomButtonType.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: color,
          padding: _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(color: color, width: 1.5),
        );

      case CustomButtonType.text:
      case CustomButtonType.secondary:
        return TextButton.styleFrom(
          foregroundColor: color,
          padding: _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
    }
  }

  Color _getColor() {
    switch (type) {
      case CustomButtonType.primary:
        return AppColors.primaryBlue;
      case CustomButtonType.secondary:
        return AppColors.neutralGray;
      case CustomButtonType.outline:
        return AppColors.primaryBlue;
      case CustomButtonType.text:
        return AppColors.primaryBlue;
      case CustomButtonType.danger:
        return AppColors.error;
      case CustomButtonType.success:
        return AppColors.success;
      case CustomButtonType.warning:
        return AppColors.warning;
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = _getBaseTextStyle();
    final color =
        type == CustomButtonType.outline || type == CustomButtonType.text
            ? _getColor()
            : AppColors.white;

    return baseStyle.copyWith(color: color);
  }

  TextStyle _getBaseTextStyle() {
    switch (size) {
      case CustomButtonSize.small:
        return AppTextStyles.buttonSmall;
      case CustomButtonSize.medium:
        return AppTextStyles.buttonMedium;
      case CustomButtonSize.large:
        return AppTextStyles.buttonLarge;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case CustomButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case CustomButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case CustomButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getIconSize() {
    switch (size) {
      case CustomButtonSize.small:
        return 16;
      case CustomButtonSize.medium:
        return 20;
      case CustomButtonSize.large:
        return 24;
    }
  }

  /// Factory constructors para casos comunes
  factory CustomButton.primary(
    String text, {
    VoidCallback? onPressed,
    Widget? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    CustomButtonSize size = CustomButtonSize.medium,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: CustomButtonType.primary,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
    );
  }

  factory CustomButton.secondary(
    String text, {
    VoidCallback? onPressed,
    Widget? icon,
    bool isLoading = false,
    CustomButtonSize size = CustomButtonSize.medium,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: CustomButtonType.secondary,
      icon: icon,
      isLoading: isLoading,
      size: size,
    );
  }

  factory CustomButton.outline(
    String text, {
    VoidCallback? onPressed,
    Widget? icon,
    bool isLoading = false,
    CustomButtonSize size = CustomButtonSize.medium,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: CustomButtonType.outline,
      icon: icon,
      isLoading: isLoading,
      size: size,
    );
  }

  factory CustomButton.danger(
    String text, {
    VoidCallback? onPressed,
    Widget? icon,
    bool isLoading = false,
    CustomButtonSize size = CustomButtonSize.medium,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: CustomButtonType.danger,
      icon: icon,
      isLoading: isLoading,
      size: size,
    );
  }
}
