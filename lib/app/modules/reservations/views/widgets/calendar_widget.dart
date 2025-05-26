import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/constants.dart';
import '../../controllers/reservation_controller.dart';

/// Widget personalizado del calendario para reservaciones
class CalendarWidget extends GetView<ReservationController> {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(Duration(days: AppConstants.maxReservationDaysAhead)),
          focusedDay: controller.focusedDate.value,
          selectedDayPredicate: (day) {
            return isSameDay(controller.selectedDate.value, day);
          },
          onDaySelected: controller.onDateSelected,
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          
          // Configuración de estilo
          calendarStyle: CalendarStyle(
            // Días fuera del mes actual
            outsideDaysVisible: false,
            
            // Día seleccionado
            selectedDecoration: BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: AppTextStyles.labelLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
            
            // Día de hoy
            todayDecoration: BoxDecoration(
              color: AppColors.accentOrange,
              shape: BoxShape.circle,
            ),
            todayTextStyle: AppTextStyles.labelLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
            
            // Días normales
            defaultDecoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            defaultTextStyle: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            
            // Días del fin de semana
            weekendDecoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            weekendTextStyle: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            
            // Días deshabilitados (pasados)
            disabledDecoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            disabledTextStyle: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textLight,
            ),
            
            // Marcadores
            markersMaxCount: 3,
            markersAnchor: 0.7,
            markerDecoration: BoxDecoration(
              color: AppColors.secondaryGreen,
              shape: BoxShape.circle,
            ),
            markerMargin: const EdgeInsets.symmetric(horizontal: 0.5),
            markerSize: 6.0,
            
            // Espaciado
            cellMargin: const EdgeInsets.all(4),
            cellPadding: const EdgeInsets.all(0),
          ),
          
          // Configuración del header
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: AppColors.primaryBlue,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: AppColors.primaryBlue,
            ),
            titleTextStyle: AppTextStyles.h6.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
            headerPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          
          // Configuración de días de la semana
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          // Eventos/marcadores para días con reservaciones
          eventLoader: (day) {
            return controller.getReservationsForDay(day);
          },
          
          // Builder personalizado para días
          calendarBuilders: CalendarBuilders(
            // Marcador personalizado
            markerBuilder: (context, day, events) {
              if (events.isEmpty) return const SizedBox.shrink();
              
              return Positioned(
                bottom: 1,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: controller.getColorForDay(day),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
            
            // Días con eventos especiales
            defaultBuilder: (context, day, focusedDay) {
              final hasReservations = controller.hasReservationsForDay(day);
              
              if (!hasReservations) return null;
              
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: controller.getColorForDay(day).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: controller.getColorForDay(day).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            },
            
            // Días deshabilitados (pasados)
            disabledBuilder: (context, day, focusedDay) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Configuración adicional
          availableGestures: AvailableGestures.all,
          pageJumpingEnabled: true,
        )),
      ),
    );
  }
}