import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../data/models/notification_model.dart';

/// Widget para mostrar una notificación individual
class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final bool isRead;
  final VoidCallback? onTap;
  final VoidCallback? onMarkRead;
  final VoidCallback? onMarkUnread;
  final VoidCallback? onDelete;
  final bool showActions;

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.isRead,
    this.onTap,
    this.onMarkRead,
    this.onMarkUnread,
    this.onDelete,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isRead ? 1 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isRead
                  ? AppColors.cardBorder
                  : _getPriorityColor().withOpacity(0.3),
          width: isRead ? 0.5 : 2,
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
              if (notification.message.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildMessage(),
              ],
              const SizedBox(height: 12),
              _buildFooter(),
              if (showActions) ...[const SizedBox(height: 12), _buildActions()],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: AppTextStyles.h6.copyWith(
                  color:
                      isRead ? AppColors.textSecondary : AppColors.textPrimary,
                  fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              _buildMetadata(),
            ],
          ),
        ),
        _buildPriorityBadge(),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getTypeColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(_getTypeIcon(), color: _getTypeColor(), size: 24),
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          Helpers.getTimeAgo(notification.createdAt),
          style: AppTextStyles.caption,
        ),
        const SizedBox(width: 12),
        Icon(Icons.category_outlined, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(_getTypeDisplayName(), style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildPriorityBadge() {
    if (notification.priority == NotificationPriority.low) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: _getPriorityColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getPriorityColor().withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getPriorityIcon(), size: 12, color: _getPriorityColor()),
          const SizedBox(width: 4),
          Text(
            _getPriorityDisplayName(),
            style: AppTextStyles.caption.copyWith(
              color: _getPriorityColor(),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage() {
    return Text(
      notification.message,
      style: AppTextStyles.bodyMedium.copyWith(
        color: isRead ? AppColors.textSecondary : AppColors.textPrimary,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Indicador de estado de lectura
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isRead ? AppColors.textLight : _getPriorityColor(),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isRead ? 'Leída' : 'No leída',
          style: AppTextStyles.caption.copyWith(
            color: isRead ? AppColors.textSecondary : _getPriorityColor(),
            fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          Helpers.formatDateTime(notification.createdAt),
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        // Marcar como leída/no leída
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isRead ? onMarkUnread : onMarkRead,
            icon: Icon(
              isRead ? Icons.mark_email_unread : Icons.mark_email_read,
              size: 16,
            ),
            label: Text(isRead ? 'Marcar no leída' : 'Marcar leída'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
              side: const BorderSide(color: AppColors.primaryBlue),
              padding: const EdgeInsets.symmetric(vertical: 8),
              minimumSize: const Size(0, 36),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Eliminar
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, size: 16),
            label: const Text('Eliminar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 8),
              minimumSize: const Size(0, 36),
            ),
          ),
        ),
      ],
    );
  }

  // Métodos para obtener colores e iconos según el tipo y prioridad

  Color _getTypeColor() {
    switch (notification.type) {
      case NotificationType.general:
        return AppColors.primaryBlue;
      case NotificationType.reservationReminder:
        return AppColors.accentOrange;
      case NotificationType.scheduleChange:
        return AppColors.warning;
      case NotificationType.systemUpdate:
        return AppColors.info;
      case NotificationType.maintenanceAlert:
        return AppColors.error;
    }
  }

  IconData _getTypeIcon() {
    switch (notification.type) {
      case NotificationType.general:
        return Icons.info_outline;
      case NotificationType.reservationReminder:
        return Icons.event_note;
      case NotificationType.scheduleChange:
        return Icons.schedule;
      case NotificationType.systemUpdate:
        return Icons.system_update;
      case NotificationType.maintenanceAlert:
        return Icons.build_outlined;
    }
  }

  String _getTypeDisplayName() {
    switch (notification.type) {
      case NotificationType.general:
        return 'General';
      case NotificationType.reservationReminder:
        return 'Reservación';
      case NotificationType.scheduleChange:
        return 'Horario';
      case NotificationType.systemUpdate:
        return 'Sistema';
      case NotificationType.maintenanceAlert:
        return 'Mantenimiento';
    }
  }

  Color _getPriorityColor() {
    switch (notification.priority) {
      case NotificationPriority.high:
        return AppColors.error;
      case NotificationPriority.normal:
        return AppColors.warning;
      case NotificationPriority.low:
        return AppColors.info;
      case NotificationPriority.urgent:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  IconData _getPriorityIcon() {
    switch (notification.priority) {
      case NotificationPriority.high:
        return Icons.priority_high;
      case NotificationPriority.normal:
        return Icons.warning_amber;
      case NotificationPriority.low:
        return Icons.info;
      case NotificationPriority.urgent:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String _getPriorityDisplayName() {
    switch (notification.priority) {
      case NotificationPriority.high:
        return 'ALTA';
      case NotificationPriority.normal:
        return 'MEDIA';
      case NotificationPriority.low:
        return 'BAJA';
      case NotificationPriority.urgent:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
