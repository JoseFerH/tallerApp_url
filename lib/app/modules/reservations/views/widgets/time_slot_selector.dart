import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/constants.dart';
import '../../controllers/reservation_controller.dart';

/// Widget para seleccionar el horario de la reservación
class TimeSlotSelector extends GetView<ReservationController> {
  const TimeSlotSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.availableSlots.isEmpty) {
        return _buildNoSlotsAvailable();
      }
      
      return Column(
        children: [
          // Información de disponibilidad
          _buildAvailabilityInfo(),
          
          const SizedBox(height: 16),
          
          // Lista de horarios disponibles
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.availableSlots.length,
            itemBuilder: (context, index) {
              final slot = controller.availableSlots[index];
              final isSelected = controller.selectedTimeSlot.value == slot;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildTimeSlotCard(slot, isSelected),
              );
            },
          ),
        ],
      );
    });
  }
  
  /// Información de disponibilidad
  Widget _buildAvailabilityInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundAccent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Horarios disponibles para ${controller.selectedZone.value?.displayName}',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${controller.availableSlots.length} disponible${controller.availableSlots.length != 1 ? 's' : ''}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Tarjeta de horario
  Widget _buildTimeSlotCard(TimeSlot slot, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.selectTimeSlot(slot),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue
                : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Ícono de tiempo
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBlue
                    : AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.access_time,
                size: 20,
                color: isSelected
                    ? AppColors.white
                    : AppColors.primaryBlue,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Información del horario
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.displayName,
                    style: AppTextStyles.subtitle1.copyWith(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getSlotDescription(slot),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Indicador de selección
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: AppColors.white,
                ),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.cardBorder,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  /// Estado cuando no hay horarios disponibles
  Widget _buildNoSlotsAvailable() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: 48,
            color: AppColors.warning,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay horarios disponibles',
            style: AppTextStyles.h6.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Todos los horarios para esta zona ya están reservados en la fecha seleccionada.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.date_range),
                label: const Text('Cambiar Fecha'),
              ),
              TextButton.icon(
                onPressed: () => controller.selectedZone.value = null,
                icon: const Icon(Icons.location_on),
                label: const Text('Cambiar Zona'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Obtener descripción del horario
  String _getSlotDescription(TimeSlot slot) {
    final now = DateTime.now();
    final slotStart = slot.getStartTime(controller.selectedDate.value);
    final slotEnd = slot.getEndTime(controller.selectedDate.value);
    
    // Si es hoy, mostrar tiempo relativo
    if (controller.selectedDate.value.day == now.day &&
        controller.selectedDate.value.month == now.month &&
        controller.selectedDate.value.year == now.year) {
      
      if (slotStart.isBefore(now)) {
        return 'Ya pasó';
      } else {
        final hoursUntil = slotStart.difference(now).inHours;
        if (hoursUntil < 1) {
          final minutesUntil = slotStart.difference(now).inMinutes;
          return 'Comienza en $minutesUntil minutos';
        } else {
          return 'Comienza en $hoursUntil horas';
        }
      }
    }
    
    // Para otros días, mostrar duración
    final duration = slotEnd.difference(slotStart).inHours;
    return 'Duración: $duration horas';
  }