import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/notifications_controller.dart';
import 'widgets/notification_item.dart';

/// Vista principal de notificaciones
class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.simple(
        Strings.notificationsTitle,
        actions: [
          Obx(
            () => IconButton(
              icon: Badge(
                label: Text('${controller.unreadCount}'),
                isLabelVisible: controller.hasUnreadNotifications,
                child: const Icon(Icons.mark_email_read),
              ),
              onPressed:
                  controller.hasUnreadNotifications
                      ? _showMarkAllReadDialog
                      : null,
              tooltip: 'Marcar todas como leídas',
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuAction,
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'refresh',
                    child: ListTile(
                      leading: Icon(Icons.refresh),
                      title: Text('Actualizar'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: ListTile(
                      leading: Icon(Icons.clear_all),
                      title: Text('Limpiar todas'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  if (Get.find<NotificationsController>().notifications.isEmpty)
                    const PopupMenuItem(
                      value: 'create_test',
                      child: ListTile(
                        leading: Icon(Icons.add_alert),
                        title: Text('Crear notificaciones de prueba'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(child: _buildNotificationsList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundSecondary,
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final stats = controller.notificationStats;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notificaciones', style: AppTextStyles.h5),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatChip(
                  'Total: ${stats['total']}',
                  AppColors.primaryBlue,
                ),
                const SizedBox(width: 8),
                if (stats['unread']! > 0)
                  _buildStatChip(
                    'No leídas: ${stats['unread']}',
                    AppColors.error,
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      color: AppColors.backgroundPrimary,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filtrar por:', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          Obx(() => _buildFilterChips()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'key': 'all', 'label': 'Todas', 'icon': Icons.all_inbox},
      {'key': 'unread', 'label': 'No leídas', 'icon': Icons.mark_email_unread},
      {'key': 'read', 'label': 'Leídas', 'icon': Icons.mark_email_read},
      {'key': 'high', 'label': 'Alta prioridad', 'icon': Icons.priority_high},
      {
        'key': 'medium',
        'label': 'Media prioridad',
        'icon': Icons.warning_amber,
      },
      {'key': 'low', 'label': 'Baja prioridad', 'icon': Icons.info},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            filters.map((filter) {
              final isSelected = controller.selectedFilter == filter['key'];

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        filter['icon'] as IconData,
                        size: 16,
                        color:
                            isSelected
                                ? AppColors.primaryBlue
                                : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(filter['label'] as String),
                    ],
                  ),
                  selected: isSelected,
                  onSelected:
                      (_) => controller.applyFilter(filter['key'] as String),
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
  }

  Widget _buildNotificationsList() {
    return Obx(() {
      if (controller.isLoading) {
        return LoadingWidget.center(message: 'Cargando notificaciones...');
      }

      final notifications = controller.filteredNotifications;

      if (notifications.isEmpty) {
        if (controller.selectedFilter != 'all') {
          return EmptyStateWidget.custom(
            title: 'Sin notificaciones',
            message:
                'No hay notificaciones que coincidan con el filtro seleccionado.',
            icon: Icons.filter_list_off,
            actionText: 'Ver todas',
            onActionPressed: () => controller.applyFilter('all'),
          );
        }

        return EmptyStateWidget.noNotifications();
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final isRead = controller.isNotificationRead(notification.id);

            return NotificationItem(
              notification: notification,
              isRead: isRead,
              onTap: () => _handleNotificationTap(notification),
              onMarkRead: () => controller.markAsRead(notification.id),
              onMarkUnread: () => controller.markAsUnread(notification.id),
              onDelete: () => _confirmDeleteNotification(notification),
              showActions: true,
            );
          },
        ),
      );
    });
  }

  void _handleNotificationTap(notification) {
    // Marcar como leída si no lo está
    if (!controller.isNotificationRead(notification.id)) {
      controller.markAsRead(notification.id);
    }

    // Mostrar detalles completos
    _showNotificationDetails(notification);
  }

  void _showNotificationDetails(notification) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.mediumGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Notification details
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detalles de Notificación', style: AppTextStyles.h5),
                  const SizedBox(height: 16),

                  NotificationItem(
                    notification: notification,
                    isRead: controller.isNotificationRead(notification.id),
                    showActions: false,
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Get.back();
                            if (controller.isNotificationRead(
                              notification.id,
                            )) {
                              controller.markAsUnread(notification.id);
                            } else {
                              controller.markAsRead(notification.id);
                            }
                          },
                          icon: Icon(
                            controller.isNotificationRead(notification.id)
                                ? Icons.mark_email_unread
                                : Icons.mark_email_read,
                          ),
                          label: Text(
                            controller.isNotificationRead(notification.id)
                                ? 'Marcar no leída'
                                : 'Marcar leída',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            _confirmDeleteNotification(notification);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Eliminar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _handleMenuAction(String action) async {
    switch (action) {
      case 'refresh':
        await controller.refresh();
        break;
      case 'clear_all':
        await _confirmClearAllNotifications();
        break;
      case 'create_test':
        await controller.createTestNotifications();
        break;
    }
  }

  Future<void> _showMarkAllReadDialog() async {
    final confirmed = await CustomDialog.showConfirmation(
      title: 'Marcar todas como leídas',
      message: '¿Deseas marcar todas las notificaciones como leídas?',
      confirmText: 'Marcar todas',
      cancelText: 'Cancelar',
    );

    if (confirmed == true) {
      await controller.markAllAsRead();
    }
  }

  Future<void> _confirmDeleteNotification(notification) async {
    final confirmed = await CustomDialog.showDeleteConfirmation(
      itemName: notification.title,
    );

    if (confirmed == true) {
      await controller.deleteNotification(notification.id);
    }
  }

  Future<void> _confirmClearAllNotifications() async {
    final confirmed = await CustomDialog.showConfirmation(
      title: 'Limpiar todas las notificaciones',
      message:
          '¿Estás seguro de que deseas eliminar todas las notificaciones?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Eliminar todas',
      cancelText: 'Cancelar',
    );

    if (confirmed == true) {
      await controller.clearAllNotifications();
    }
  }
}
