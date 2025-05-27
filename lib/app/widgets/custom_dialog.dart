import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'custom_button.dart';

/// Tipos de diálogo predefinidos
enum DialogType { info, success, warning, error, confirmation, custom }

/// Diálogo personalizado reutilizable
class CustomDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  final String message;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool barrierDismissible;
  final IconData? icon;
  final Color? iconColor;
  final bool showIcon;
  final List<Widget>? actions;

  const CustomDialog({
    Key? key,
    this.type = DialogType.info,
    required this.title,
    required this.message,
    this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
    this.icon,
    this.iconColor,
    this.showIcon = true,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: _buildTitle(),
      content: _buildContent(),
      actions: _buildActions(),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        if (showIcon) ...[
          Icon(_getIcon(), color: _getIconColor(), size: 28),
          const SizedBox(width: 12),
        ],
        Expanded(child: Text(title, style: AppTextStyles.h5)),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message, style: AppTextStyles.bodyMedium),
        if (content != null) ...[const SizedBox(height: 16), content!],
      ],
    );
  }

  List<Widget> _buildActions() {
    if (actions != null) {
      return actions!;
    }

    final actionWidgets = <Widget>[];

    // Botón cancelar/cerrar
    if (type == DialogType.confirmation || cancelText != null) {
      actionWidgets.add(
        CustomButton(
          text: cancelText ?? 'Cancelar',
          type: CustomButtonType.text,
          onPressed: onCancel ?? () => Get.back(result: false),
        ),
      );
      actionWidgets.add(const SizedBox(width: 8));
    }

    // Botón confirmar/ok
    actionWidgets.add(
      CustomButton(
        text: confirmText ?? _getDefaultConfirmText(),
        type: _getConfirmButtonType(),
        onPressed: onConfirm ?? () => Get.back(result: true),
      ),
    );

    return actionWidgets;
  }

  IconData _getIcon() {
    if (icon != null) return icon!;

    switch (type) {
      case DialogType.info:
        return Icons.info_outline;
      case DialogType.success:
        return Icons.check_circle_outline;
      case DialogType.warning:
        return Icons.warning_amber_outlined;
      case DialogType.error:
        return Icons.error_outline;
      case DialogType.confirmation:
        return Icons.help_outline;
      case DialogType.custom:
        return Icons.info_outline;
    }
  }

  Color _getIconColor() {
    if (iconColor != null) return iconColor!;

    switch (type) {
      case DialogType.info:
        return AppColors.info;
      case DialogType.success:
        return AppColors.success;
      case DialogType.warning:
        return AppColors.warning;
      case DialogType.error:
        return AppColors.error;
      case DialogType.confirmation:
        return AppColors.primaryBlue;
      case DialogType.custom:
        return AppColors.primaryBlue;
    }
  }

  CustomButtonType _getConfirmButtonType() {
    switch (type) {
      case DialogType.error:
        return CustomButtonType.danger;
      case DialogType.warning:
        return CustomButtonType.warning;
      case DialogType.success:
        return CustomButtonType.success;
      default:
        return CustomButtonType.primary;
    }
  }

  String _getDefaultConfirmText() {
    switch (type) {
      case DialogType.confirmation:
        return 'Confirmar';
      case DialogType.error:
        return 'Entendido';
      default:
        return 'Aceptar';
    }
  }

  /// Métodos estáticos para mostrar diálogos específicos
  static Future<bool?> showInfo({
    required String title,
    required String message,
    Widget? content,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return Get.dialog<bool>(
      CustomDialog(
        type: DialogType.info,
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  static Future<bool?> showSuccess({
    required String title,
    required String message,
    Widget? content,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return Get.dialog<bool>(
      CustomDialog(
        type: DialogType.success,
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  static Future<bool?> showError({
    required String title,
    required String message,
    Widget? content,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return Get.dialog<bool>(
      CustomDialog(
        type: DialogType.error,
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  static Future<bool?> showWarning({
    required String title,
    required String message,
    Widget? content,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return Get.dialog<bool>(
      CustomDialog(
        type: DialogType.warning,
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  static Future<bool?> showConfirmation({
    required String title,
    required String message,
    Widget? content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return Get.dialog<bool>(
      CustomDialog(
        type: DialogType.confirmation,
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  static Future<bool?> showDeleteConfirmation({
    required String itemName,
    VoidCallback? onConfirm,
  }) {
    return showConfirmation(
      title: 'Confirmar Eliminación',
      message:
          '¿Estás seguro de que deseas eliminar "$itemName"?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      onConfirm: onConfirm,
    );
  }

  static Future<bool?> showLogoutConfirmation({VoidCallback? onConfirm}) {
    return showConfirmation(
      title: 'Cerrar Sesión',
      message: '¿Estás seguro de que deseas cerrar sesión?',
      confirmText: 'Cerrar Sesión',
      cancelText: 'Cancelar',
      onConfirm: onConfirm,
    );
  }

  /// Diálogo de carga
  static void showLoading({String? message}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message ?? 'Cargando...', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Cerrar diálogo de carga
  static void hideLoading() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  /// Diálogo personalizado con form
  static Future<Map<String, dynamic>?> showForm({
    required String title,
    required List<Widget> fields,
    String? confirmText,
    String? cancelText,
    GlobalKey<FormState>? formKey,
  }) {
    final key = formKey ?? GlobalKey<FormState>();

    return Get.dialog<Map<String, dynamic>>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: AppTextStyles.h5),
        content: Form(
          key: key,
          child: Column(mainAxisSize: MainAxisSize.min, children: fields),
        ),
        actions: [
          CustomButton(
            text: cancelText ?? 'Cancelar',
            type: CustomButtonType.text,
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 8),
          CustomButton(
            text: confirmText ?? 'Guardar',
            type: CustomButtonType.primary,
            onPressed: () {
              if (key.currentState?.validate() == true) {
                Get.back(result: {'success': true});
              }
            },
          ),
        ],
      ),
    );
  }
}
