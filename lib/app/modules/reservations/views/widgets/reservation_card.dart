import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/reservation_model.dart';
import '../../controllers/reservation_controller.dart';

/// Widget de tarjeta para mostrar información de una reservación
class ReservationCard extends GetView<ReservationController> {
  final ReservationModel reservation;
  final VoidCallback? onCancel;
  final VoidCallback? onTap;
  final bool isCompact;
  final bool showDate;
  final bool showActions;
  
  const ReservationCard({
    super.key,
    required this.reservation,
    this.onCancel,
    this.onTap,
    this.isCompact = false,
    this.showDate = true,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: isCompact 
          ? EdgeInsets.zero 
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isCompact ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isCompact ? 0 : 12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isCompact ? 0 : 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con zona y estado
              _buildHeader(),
              
              const SizedBox(height: 8),
              
              // Información de fecha y hora
              if (showDate) _buildDateTimeInfo(),
              
              // Información adicional
              if (!isCompact) ...[
                const SizedBox(height: 8),
                _buildAdditionalInfo(),
              ],
              
              // Acciones (cancelar, etc.)
              if (showActions && !isCompact) ...[
                const SizedBox(height: 12),
                _buildActions(),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  /// Header con zona y estado
  Widget _buildHeader() {
    return Row(
      children: [
        // Ícono de la zona
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: controller.getZoneColor(reservation.zone).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            controller.getZoneIcon(reservation.zone),
            color: controller.getZoneColor(reservation.zone),
            size: 20,
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Información de la zona
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reservation.zone.displayName,
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                reservation.timeSlot.displayName,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        // Badge de estado
        _buildStatusBadge(),
      ],
    );
  }
  
  /// Badge de estado de la reservación
  Widget _buildStatusBadge() {
    Color statusColor;
    IconData statusIcon;
    
    switch (reservation.status) {
      case ReservationStatus.activa:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case ReservationStatus.completada:
        statusColor = Colors.blue;
        statusIcon = Icons.done_all;
        break;
      case ReservationStatus.cancelada:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case ReservationStatus.noShow:
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 12,
            color: statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            reservation.status.displayName,
            style: AppTextStyles.caption.copyWith(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Información de fecha y hora
  Widget _buildDateTimeInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundAccent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              reservation.formattedDateTime,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (reservation.isFuture) ...[
            Icon(
              Icons.access_time,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              reservation.timeUntilReservation,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  /// Información adicional
  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Propósito (si existe)
        if (reservation.purpose != null && reservation.purpose!.isNotEmpty) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.description,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  reservation.purpose!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        
        // Información del usuario (si no es el usuario actual)
        if (reservation.userId != controller.currentUser?.id) ...[
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                reservation.userName,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        
        // Duración
        Row(
          children: [
            Icon(
              Icons.timer,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              '${reservation.durationHours} hora${reservation.durationHours > 1 ? 's' : ''}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// Acciones disponibles
  Widget _buildActions() {
    return Row(
      children: [
        // Información de creación
        Expanded(
          child: Text(
            'Creada ${_getTimeAgo(reservation.createdAt)}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textLight,
            ),
          ),
        ),
        
        // Botón de cancelar (si aplica)
        if (onCancel != null && reservation.canBeCanceled)
          TextButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.cancel_outlined, size: 16),
            label: const Text('Cancelar'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
          ),
      ],
    );
  }
  
  /// Obtener tiempo transcurrido desde la creación
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return 'hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'hace un momento';
    }
  }
}