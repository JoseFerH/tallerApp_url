import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/values/assets.dart';
import 'custom_button.dart';

/// Tipos de estado vacío predefinidos
enum EmptyStateType {
  general,
  search,
  noData,
  noReservations,
  noTools,
  noNotifications,
  noUsers,
  error,
  offline,
}

/// Widget para mostrar estados vacíos de manera consistente
class EmptyStateWidget extends StatelessWidget {
  final EmptyStateType type;
  final String? title;
  final String? message;
  final String? imagePath;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Widget? customAction;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const EmptyStateWidget({
    Key? key,
    this.type = EmptyStateType.general,
    this.title,
    this.message,
    this.imagePath,
    this.icon,
    this.actionText,
    this.onActionPressed,
    this.customAction,
    this.iconColor,
    this.iconSize,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(height: 24),
            _buildTitle(),
            if (_getEffectiveMessage().isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildMessage(),
            ],
            if (_shouldShowAction()) ...[
              const SizedBox(height: 32),
              _buildAction(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      );
    }

    return Icon(
      _getEffectiveIcon(),
      size: iconSize ?? 80,
      color: iconColor ?? AppColors.textLight,
    );
  }

  Widget _buildTitle() {
    return Text(
      _getEffectiveTitle(),
      style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage() {
    return Text(
      _getEffectiveMessage(),
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAction() {
    if (customAction != null) {
      return customAction!;
    }

    if (actionText != null && onActionPressed != null) {
      return CustomButton.primary(
        actionText!,
        onPressed: onActionPressed,
        icon: _getActionIcon(),
      );
    }

    return const SizedBox.shrink();
  }

  String _getEffectiveTitle() {
    if (title != null) return title!;

    switch (type) {
      case EmptyStateType.general:
        return 'No hay elementos';
      case EmptyStateType.search:
        return 'Sin resultados';
      case EmptyStateType.noData:
        return 'Sin datos';
      case EmptyStateType.noReservations:
        return 'Sin reservaciones';
      case EmptyStateType.noTools:
        return 'Sin herramientas';
      case EmptyStateType.noNotifications:
        return 'Sin notificaciones';
      case EmptyStateType.noUsers:
        return 'Sin usuarios';
      case EmptyStateType.error:
        return 'Algo salió mal';
      case EmptyStateType.offline:
        return 'Sin conexión';
    }
  }

  String _getEffectiveMessage() {
    if (message != null) return message!;

    switch (type) {
      case EmptyStateType.general:
        return 'Aún no hay información disponible';
      case EmptyStateType.search:
        return 'No se encontraron resultados para tu búsqueda. Intenta con otros términos.';
      case EmptyStateType.noData:
        return 'Los datos se mostrarán aquí una vez que estén disponibles';
      case EmptyStateType.noReservations:
        return 'No tienes reservaciones activas. Puedes crear una nueva desde el menú principal.';
      case EmptyStateType.noTools:
        return 'El catálogo de herramientas no está disponible en este momento';
      case EmptyStateType.noNotifications:
        return 'No tienes notificaciones nuevas. Te notificaremos cuando haya novedades.';
      case EmptyStateType.noUsers:
        return 'No hay usuarios registrados en el sistema';
      case EmptyStateType.error:
        return 'Ocurrió un error inesperado. Por favor intenta de nuevo.';
      case EmptyStateType.offline:
        return 'Revisa tu conexión a internet e intenta nuevamente';
    }
  }

  IconData _getEffectiveIcon() {
    if (icon != null) return icon!;

    switch (type) {
      case EmptyStateType.general:
        return Icons.inbox_outlined;
      case EmptyStateType.search:
        return Icons.search_off;
      case EmptyStateType.noData:
        return Icons.data_usage_outlined;
      case EmptyStateType.noReservations:
        return Icons.event_busy_outlined;
      case EmptyStateType.noTools:
        return Icons.build_outlined;
      case EmptyStateType.noNotifications:
        return Icons.notifications_none_outlined;
      case EmptyStateType.noUsers:
        return Icons.people_outline;
      case EmptyStateType.error:
        return Icons.error_outline;
      case EmptyStateType.offline:
        return Icons.wifi_off_outlined;
    }
  }

  Widget? _getActionIcon() {
    switch (type) {
      case EmptyStateType.noReservations:
        return const Icon(Icons.add);
      case EmptyStateType.error:
      case EmptyStateType.offline:
        return const Icon(Icons.refresh);
      default:
        return null;
    }
  }

  bool _shouldShowAction() {
    return customAction != null ||
        (actionText != null && onActionPressed != null);
  }

  /// Factory constructors para casos específicos
  static Widget search({String? searchTerm, VoidCallback? onClearSearch}) {
    return EmptyStateWidget(
      type: EmptyStateType.search,
      message:
          searchTerm != null
              ? 'No se encontraron resultados para "$searchTerm"'
              : null,
      actionText: onClearSearch != null ? 'Limpiar búsqueda' : null,
      onActionPressed: onClearSearch,
    );
  }

  static Widget noReservations({VoidCallback? onCreateReservation}) {
    return EmptyStateWidget(
      type: EmptyStateType.noReservations,
      actionText: 'Nueva Reservación',
      onActionPressed: onCreateReservation,
    );
  }

  static Widget error({String? errorMessage, VoidCallback? onRetry}) {
    return EmptyStateWidget(
      type: EmptyStateType.error,
      message: errorMessage,
      actionText: 'Reintentar',
      onActionPressed: onRetry,
    );
  }

  static Widget offline({VoidCallback? onRetry}) {
    return EmptyStateWidget(
      type: EmptyStateType.offline,
      actionText: 'Reintentar',
      onActionPressed: onRetry,
    );
  }

  static Widget noNotifications() {
    return const EmptyStateWidget(type: EmptyStateType.noNotifications);
  }

  static Widget noTools({VoidCallback? onRefresh}) {
    return EmptyStateWidget(
      type: EmptyStateType.noTools,
      actionText: onRefresh != null ? 'Actualizar' : null,
      onActionPressed: onRefresh,
    );
  }

  static Widget noUsers({VoidCallback? onCreateUser}) {
    return EmptyStateWidget(
      type: EmptyStateType.noUsers,
      actionText: 'Crear Usuario',
      onActionPressed: onCreateUser,
    );
  }

  static Widget custom({
    required String title,
    required String message,
    IconData? icon,
    String? imagePath,
    String? actionText,
    VoidCallback? onActionPressed,
    Widget? customAction,
  }) {
    return EmptyStateWidget(
      type: EmptyStateType.general,
      title: title,
      message: message,
      icon: icon,
      imagePath: imagePath,
      actionText: actionText,
      onActionPressed: onActionPressed,
      customAction: customAction,
    );
  }
}
