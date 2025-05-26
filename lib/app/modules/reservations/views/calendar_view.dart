import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../controllers/reservation_controller.dart';
import 'widgets/calendar_widget.dart';
import 'widgets/reservation_card.dart';

/// Vista del calendario de reservaciones
class CalendarView extends GetView<ReservationController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.refreshReservations,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Widget del calendario
              const CalendarWidget(),
              
              // Información de la fecha seleccionada
              _buildSelectedDateInfo(),
              
              // Reservaciones del día seleccionado
              _buildDayReservations(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.navigateToReservationForm,
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Reservación'),
      ),
    );
  }
  
  /// AppBar personalizada
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        Strings.reservationsTitle,
        style: AppTextStyles.h5.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Botón para ir a mis reservaciones
        IconButton(
          onPressed: controller.navigateToMyReservations,
          icon: const Icon(Icons.event_note, color: AppColors.white),
          tooltip: 'Mis Reservaciones',
        ),
        
        // Menú de opciones
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.white),
          onSelected: (value) {
            switch (value) {
              case 'refresh':
                controller.refreshReservations();
                break;
              case 'today':
                controller.onDateSelected(DateTime.now(), DateTime.now());
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'today',
              child: ListTile(
                leading: Icon(Icons.today),
                title: Text('Ir a Hoy'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'refresh',
              child: ListTile(
                leading: Icon(Icons.refresh),
                title: Text('Actualizar'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// Información de la fecha seleccionada
  Widget _buildSelectedDateInfo() {
    return Obx(() => Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fecha seleccionada
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _getFormattedDate(controller.selectedDate.value),
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (controller.hasReservationsForDay(controller.selectedDate.value))
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.getReservationsForDay(controller.selectedDate.value).length} reservación(es)',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Información adicional
          Text(
            _getDateDescription(controller.selectedDate.value),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ));
  }
  
  /// Reservaciones del día seleccionado
  Widget _buildDayReservations() {
    return Obx(() {
      final dayReservations = controller.getReservationsForDay(controller.selectedDate.value);
      
      if (dayReservations.isEmpty) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.all(32),
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
          child: Column(
            children: [
              Icon(
                Icons.event_available,
                size: 48,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No hay reservaciones',
                style: AppTextStyles.h6.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Este día está disponible para reservaciones',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.navigateToReservationForm,
                child: const Text('Hacer Reservación'),
              ),
            ],
          ),
        );
      }
      
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Reservaciones del Día',
                    style: AppTextStyles.h6.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${dayReservations.length}',
                    style: AppTextStyles.h6.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Lista de reservaciones
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dayReservations.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final reservation = dayReservations[index];
                return ReservationCard(
                  reservation: reservation,
                  isCompact: true,
                  showDate: false,
                  onCancel: reservation.canBeCanceled && 
                            reservation.userId == controller.currentUser?.id
                      ? () => controller.cancelReservation(reservation)
                      : null,
                );
              },
            ),
          ],
        ),
      );
    });
  }
  
  /// Obtener fecha formateada
  String _getFormattedDate(DateTime date) {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    final weekdays = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
    ];
    
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    
    return '$weekday, ${date.day} de $month ${date.year}';
  }
  
  /// Obtener descripción de la fecha
  String _getDateDescription(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);
    
    final difference = selectedDay.difference(today).inDays;
    
    if (difference == 0) {
      return 'Hoy - Selecciona los espacios disponibles';
    } else if (difference == 1) {
      return 'Mañana - Planifica tu día en el taller';
    } else if (difference > 1 && difference <= 7) {
      return 'En $difference días - Reserva con anticipación';
    } else {
      return 'Fecha futura - Planificación a largo plazo';
    }
  }
}