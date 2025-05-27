import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/reservation_controller.dart';
import '../../../data/models/reservation_model.dart';
import '../../../routes/app_routes.dart';
import 'widgets/reservation_card.dart';

/// Vista de mis reservaciones del usuario actual
class MyReservationsView extends GetView<ReservationController> {
  const MyReservationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.simple(
        Strings.myReservationsTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshReservations,
            tooltip: 'Actualizar',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuAction,
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'new_reservation',
                    child: ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Nueva Reservación'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'calendar',
                    child: ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Ver Calendario'),
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
          _buildStatusTabs(),
          Expanded(child: _buildReservationsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.RESERVATION_FORM),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Reservación'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundSecondary,
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final myReservations = controller.currentUserReservations;
        final activeCount =
            myReservations
                .where((r) => r.status == ReservationStatus.activa)
                .length;
        final upcomingCount =
            myReservations
                .where(
                  (r) =>
                      r.date.isAfter(DateTime.now()) &&
                      r.status == ReservationStatus.activa,
                )
                .length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mis Reservaciones', style: AppTextStyles.h5),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatChip(
                  'Total: ${myReservations.length}',
                  AppColors.primaryBlue,
                ),
                const SizedBox(width: 8),
                if (activeCount > 0)
                  _buildStatChip('Activas: $activeCount', AppColors.success),
                const SizedBox(width: 8),
                if (upcomingCount > 0)
                  _buildStatChip(
                    'Próximas: $upcomingCount',
                    AppColors.accentOrange,
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

  Widget _buildStatusTabs() {
    return Container(
      color: AppColors.backgroundPrimary,
      child: Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildStatusTab(
                'Todas',
                'all',
                Icons.list,
                _getReservationCountByStatus('all'),
              ),
              const SizedBox(width: 8),
              _buildStatusTab(
                'Próximas',
                'upcoming',
                Icons.upcoming,
                _getReservationCountByStatus('upcoming'),
              ),
              const SizedBox(width: 8),
              _buildStatusTab(
                'Activas',
                'active',
                Icons.play_circle,
                _getReservationCountByStatus('active'),
              ),
              const SizedBox(width: 8),
              _buildStatusTab(
                'Completadas',
                'completed',
                Icons.check_circle,
                _getReservationCountByStatus('completed'),
              ),
              const SizedBox(width: 8),
              _buildStatusTab(
                'Canceladas',
                'canceled',
                Icons.cancel,
                _getReservationCountByStatus('canceled'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusTab(
    String label,
    String status,
    IconData icon,
    int count,
  ) {
    final isSelected = controller.selectedStatusFilter.value == status;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text('$label ($count)'),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => controller.filterByStatus(status),
      backgroundColor: AppColors.mediumGray.withOpacity(0.5),
      selectedColor: AppColors.primaryBlue.withOpacity(0.2),
      checkmarkColor: AppColors.primaryBlue,
      labelStyle: AppTextStyles.labelMedium.copyWith(
        color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildReservationsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return LoadingWidget.center(message: 'Cargando reservaciones...');
      }

      final reservations = _getFilteredReservations();

      if (reservations.isEmpty) {
        final selectedFilter = controller.selectedStatusFilter.value;

        if (selectedFilter != 'all') {
          return EmptyStateWidget.custom(
            title: 'Sin reservaciones',
            message: 'No tienes reservaciones con el estado seleccionado.',
            icon: Icons.filter_list_off,
            actionText: 'Ver todas',
            onActionPressed: () => controller.filterByStatus('all'),
          );
        }

        return EmptyStateWidget.noReservations(
          onCreateReservation: () => Get.toNamed(AppRoutes.RESERVATION_FORM),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshReservations,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 80), // Space for FAB
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];

            return ReservationCard(
              reservation: reservation,
              onTap: () => _showReservationDetails(reservation),
              onCancel:
                  reservation.status == ReservationStatus.activa
                      ? () => _confirmCancelReservation(reservation)
                      : null,
              showUserInfo:
                  false, // No mostrar info del usuario en "mis reservaciones"
              isDetailed: true,
            );
          },
        ),
      );
    });
  }

  List<ReservationModel> _getFilteredReservations() {
    final myReservations = controller.currentUserReservations;
    final selectedFilter = controller.selectedStatusFilter.value;
    final now = DateTime.now();

    switch (selectedFilter) {
      case 'upcoming':
        return myReservations
            .where(
              (r) =>
                  r.date.isAfter(now) && r.status == ReservationStatus.activa,
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

      case 'active':
        return myReservations
            .where((r) => r.status == ReservationStatus.activa)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

      case 'completed':
        return myReservations
            .where((r) => r.status == ReservationStatus.completada)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

      case 'canceled':
        return myReservations
            .where((r) => r.status == ReservationStatus.cancelada)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

      default: // 'all'
        return myReservations..sort((a, b) {
          // Ordenar por fecha: próximas primero, luego pasadas más recientes
          if (a.date.isAfter(now) && b.date.isBefore(now)) return -1;
          if (a.date.isBefore(now) && b.date.isAfter(now)) return 1;

          if (a.date.isAfter(now) && b.date.isAfter(now)) {
            return a.date.compareTo(b.date); // Próximas: más cercanas primero
          } else {
            return b.date.compareTo(a.date); // Pasadas: más recientes primero
          }
        });
    }
  }

  int _getReservationCountByStatus(String status) {
    final myReservations = controller.currentUserReservations;
    final now = DateTime.now();

    switch (status) {
      case 'upcoming':
        return myReservations
            .where(
              (r) =>
                  r.date.isAfter(now) && r.status == ReservationStatus.activa,
            )
            .length;
      case 'active':
        return myReservations
            .where((r) => r.status == ReservationStatus.activa)
            .length;
      case 'completed':
        return myReservations
            .where((r) => r.status == ReservationStatus.completada)
            .length;
      case 'canceled':
        return myReservations
            .where((r) => r.status == ReservationStatus.cancelada)
            .length;
      default: // 'all'
        return myReservations.length;
    }
  }

  void _showReservationDetails(ReservationModel reservation) {
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

            // Reservation details
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detalles de Reservación', style: AppTextStyles.h5),
                  const SizedBox(height: 16),

                  _buildDetailRow('Zona', reservation.zone.displayName),
                  _buildDetailRow(
                    'Fecha',
                    Helpers.formatDate(reservation.date),
                  ),
                  _buildDetailRow('Horario', reservation.timeSlot.displayName),
                  _buildDetailRow('Estado', reservation.status.displayName),
                  if (reservation.purpose?.isNotEmpty == true)
                    _buildDetailRow('Propósito', reservation.purpose!),
                  _buildDetailRow(
                    'Creada',
                    Helpers.formatDateTime(reservation.createdAt),
                  ),

                  const SizedBox(height: 24),

                  // Status indicator
                  _buildStatusIndicator(reservation),

                  const SizedBox(height: 24),

                  // Action buttons
                  if (reservation.status == ReservationStatus.activa) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close),
                            label: const Text('Cerrar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.back();
                              _confirmCancelReservation(reservation);
                            },
                            icon: const Icon(Icons.cancel),
                            label: const Text('Cancelar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cerrar'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text('$label:', style: AppTextStyles.labelLarge),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(ReservationModel reservation) {
    Color statusColor;
    IconData statusIcon;
    String statusMessage;

    switch (reservation.status) {
      case ReservationStatus.activa:
        final isUpcoming = reservation.date.isAfter(DateTime.now());
        statusColor = isUpcoming ? AppColors.success : AppColors.primaryBlue;
        statusIcon = isUpcoming ? Icons.upcoming : Icons.play_circle;
        statusMessage =
            isUpcoming
                ? 'Reservación confirmada para ${Helpers.getTimeAgo(reservation.date)}'
                : 'Reservación activa';
        break;
      case ReservationStatus.completada:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        statusMessage = 'Reservación completada exitosamente';
        break;
      case ReservationStatus.cancelada:
        statusColor = AppColors.error;
        statusIcon = Icons.cancel;
        statusMessage = 'Reservación cancelada';
        break;
      case ReservationStatus.noShow:
        statusColor = AppColors.warning;
        statusIcon = Icons.warning;
        statusMessage = 'No se presentó a la reservación';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusMessage,
              style: AppTextStyles.bodyMedium.copyWith(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'new_reservation':
        Get.toNamed(AppRoutes.RESERVATION_FORM);
        break;
      case 'calendar':
        Get.toNamed(AppRoutes.CALENDAR);
        break;
    }
  }

  Future<void> _confirmCancelReservation(ReservationModel reservation) async {
    final confirmed = await CustomDialog.showConfirmation(
      title: 'Cancelar Reservación',
      message:
          '¿Estás seguro de que deseas cancelar tu reservación para ${reservation.zone.displayName} el ${Helpers.formatDate(reservation.date)}?\n\nEsta acción no se puede deshacer.',
      confirmText: 'Sí, cancelar',
      cancelText: 'No cancelar',
    );

    if (confirmed == true) {
      await controller.cancelReservation(reservation.id);
    }
  }
}
