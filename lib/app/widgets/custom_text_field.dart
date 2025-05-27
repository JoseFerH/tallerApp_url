import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Campo de texto personalizado reutilizable
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool showPasswordToggle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final String? helperText;
  final Color? fillColor;

  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.showPasswordToggle = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.autofocus = false,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.helperText,
    this.fillColor,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();

  static search({
    required String hint,
    required controller,
    required onChanged,
    required onClear,
  }) {}
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late TextEditingController _controller;
  bool _isControllerLocal = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _isControllerLocal = true;
    }
  }

  @override
  void dispose() {
    if (_isControllerLocal) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          textCapitalization: widget.textCapitalization,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            filled: true,
            fillColor: widget.fillColor ?? AppColors.backgroundPrimary,
            contentPadding:
                widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.mediumGray),
            ),
            helperText: widget.helperText,
            helperStyle: AppTextStyles.caption,
            counterStyle: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.showPasswordToggle && widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        tooltip: _obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
      );
    }
    return widget.suffixIcon;
  }

  /// Factory constructors para casos específicos
  static Widget email({
    String? label,
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    Widget? prefixIcon,
    bool enabled = true,
  }) {
    return CustomTextField(
      label: label ?? 'Email',
      hint: hint ?? 'ejemplo@url.edu.gt',
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: prefixIcon ?? const Icon(Icons.email_outlined),
      enabled: enabled,
    );
  }

  static Widget password({
    String? label,
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    Widget? prefixIcon,
    bool enabled = true,
  }) {
    return CustomTextField(
      label: label ?? 'Contraseña',
      hint: hint ?? 'Ingresa tu contraseña',
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      obscureText: true,
      showPasswordToggle: true,
      prefixIcon: prefixIcon ?? const Icon(Icons.lock_outline),
      enabled: enabled,
    );
  }

  static Widget phone({
    String? label,
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    Widget? prefixIcon,
    bool enabled = true,
  }) {
    return CustomTextField(
      label: label ?? 'Teléfono',
      hint: hint ?? '1234-5678',
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      prefixIcon: prefixIcon ?? const Icon(Icons.phone_outlined),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
      enabled: enabled,
    );
  }

  static Widget multiline({
    String? label,
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int maxLines = 3,
    int? maxLength,
    bool enabled = true,
  }) {
    return CustomTextField(
      label: label,
      hint: hint,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
    );
  }

  static Widget search({
    String? hint,
    TextEditingController? controller,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    VoidCallback? onClear,
    bool enabled = true,
  }) {
    return CustomTextField(
      hint: hint ?? 'Buscar...',
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      prefixIcon: const Icon(Icons.search),
      suffixIcon:
          controller?.text.isNotEmpty == true
              ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
              : null,
      enabled: enabled,
    );
  }

  static Widget number({
    String? label,
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    Widget? prefixIcon,
    bool enabled = true,
    bool allowDecimals = false,
  }) {
    return CustomTextField(
      label: label,
      hint: hint,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType:
          allowDecimals
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
      textInputAction: TextInputAction.next,
      prefixIcon: prefixIcon,
      inputFormatters:
          allowDecimals
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
              : [FilteringTextInputFormatter.digitsOnly],
      enabled: enabled,
    );
  }
}
