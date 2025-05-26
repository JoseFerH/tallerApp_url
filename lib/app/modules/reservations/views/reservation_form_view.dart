import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/constants.dart';
import '../../../core/values/strings.dart';
import '../controllers/reservation_controller.dart';
import 'widgets/zone_selector.dart';
import 'widgets/time_slot_selector.dart';

/// Vista del formulario para crear una nueva reservación
class ReservationFormView extends GetView<ReservationController> {
  const ReservationFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.reservationFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información de la fecha seleccionada
              _buildDateInfo(),

              const SizedBox(height: 24),

              // Selector de zona
              _buildSectionTitle('Seleccionar Zona del Taller'),
              const SizedBox(height: 16),
              const ZoneSelector(),

              const SizedBox(height: 24),

              // Selector de horario
              Obx(() {
                if (controller.selectedZone.value != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Seleccionar Horario'),
                      const SizedBox(height: 16),
                      const TimeSlotSelector(),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              // Campo de propósito (opcional)
              Obx(() {
                if (controller.selectedTimeSlot.value != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Propósito (Opcional)'),
                      const SizedBox(height: 16),
                      _buildPurposeField(),
                      const SizedBox(height: 32),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              // Resumen de la reservación
              Obx(() {
                if (controller.selectedZone.value != null &&
                    controller.selectedTimeSlot.value != null) {
                  return _buildReservationSummary();
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  /// AppBar personalizada
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        Strings.reservationFormTitle,
        style: AppTextStyles.h5.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Mostrar ayuda o información
            _showHelpDialog();
          },
          icon: const Icon(Icons.help_outline, color: AppColors.white),
          tooltip: 'Ayuda',
        ),
      ],
    );
  }

  /// Información de la fecha seleccionada
  Widget _buildDateInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.calendar_today, color: AppColors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fecha Seleccionada',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    _formatDate(controller.selectedDate.value),
                    style: AppTextStyles.h6.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.edit_calendar,
              color: AppColors.white.withOpacity(0.8),
            ),
            tooltip: 'Cambiar fecha',
          ),
        ],
      ),
    );
  }

  /// Título de sección
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h6.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Campo de propósito
  Widget _buildPurposeField() {
    return TextFormField(
      controller: controller.purposeController,
      maxLines: 3,
      maxLength: 200,
      decoration: InputDecoration(
        hintText: Strings.reservationPurposeHint,
        prefixIcon: const Icon(Icons.description_outlined),
        helperText: 'Describe brevemente tu proyecto o actividad',
      ),
      validator: controller.validatePurpose,
    );
  }

  /// Resumen de la reservación
  Widget _buildReservationSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de Reservación',
            style: AppTextStyles.h6.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildSummaryRow(
            Icons.location_on,
            'Zona',
            controller.selectedZone.value!.displayName,
          ),

          const SizedBox(height: 12),

          _buildSummaryRow(
            Icons.access_time,
            'Horario',
            controller.selectedTimeSlot.value!.displayName,
          ),

          const SizedBox(height: 12),

          _buildSummaryRow(
            Icons.calendar_today,
            'Fecha',
            _formatDate(controller.selectedDate.value),
          ),

          if (controller.purposeController.text.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildSummaryRow(
              Icons.description,
              'Propósito',
              controller.purposeController.text.trim(),
            ),
          ],
        ],
      ),
    );
  }

  /// Fila de resumen
  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primaryBlue),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Botones inferiores
  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botón cancelar
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Cancelar'),
              ),
            ),

            const SizedBox(width: 16),

            // Botón confirmar
            Expanded(
              flex: 2,
              child: Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.selectedZone.value != null &&
                              controller.selectedTimeSlot.value != null &&
                              !controller.isCreatingReservation.value
                          ? controller.createReservation
                          : null,
                  child:
                      controller.isCreatingReservation.value
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(Strings.confirmReservation),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formatear fecha
  String _formatDate(DateTime date) {
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    final weekdays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];

    return '$weekday, ${date.day} de $month ${date.year}';
  }

  /// Mostrar diálogo de ayuda
  void _showHelpDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            const Text('Ayuda para Reservar'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Cómo hacer una reservación?',
              style: AppTextStyles.subtitle1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('1. Selecciona la zona del taller que necesitas'),
            const Text('2. Escoge el horario disponible'),
            const Text('3. Describe tu proyecto (opcional)'),
            const Text('4. Confirma tu reservación'),
            const SizedBox(height: 16),
            Text(
              'Importante:',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.warning,
              ),
            ),
            const Text('• Llega puntual a tu reservación'),
            const Text('• Cancela si no vas a asistir'),
            const Text('• Respeta los horarios asignados'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
