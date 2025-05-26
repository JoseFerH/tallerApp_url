import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../controllers/schedule_controller.dart';
import 'widgets/schedule_card.dart';

/// Vista de horarios del taller
class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.refreshSchedules,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estado actual del taller
              _buildCurrentStatus(),

              const SizedBox(height: 24),

              // Horarios regulares
              _buildSectionTitle('Horarios Regulares'),
              const SizedBox(height: 16),
              _buildRegularSchedules(),

              const SizedBox(height: 32),

              // Horarios especiales
              _buildSectionTitle('Horarios Especiales'),
              const SizedBox(height: 16),
              _buildSpecialSchedules(),

              const SizedBox(height: 32),

              // Información adicional
              _buildAdditionalInfo(),
            ],
          ),
        ),
      ),
    );
  }

  /// AppBar personalizada
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        Strings.scheduleTitle,
        style: AppTextStyles.h5.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: controller.refreshSchedules,
          icon: const Icon(Icons.refresh, color: AppColors.white),
          tooltip: 'Actualizar horarios',
        ),
      ],
    );
  }

  /// Estado actual del taller
  Widget _buildCurrentStatus() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient:
              controller.isCurrentlyOpen()
                  ? const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : const LinearGradient(
                    colors: [Color(0xFFF44336), Color(0xFFD32F2F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  controller.isCurrentlyOpen()
                      ? Colors.green.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Estado actual
            Text(
              controller.getCurrentStatusMessage(),
              style: AppTextStyles.h5.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Próximo horario
            if (!controller.isCurrentlyOpen())
              Text(
                'Próxima apertura: ${controller.getNextOpeningTime()}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 16),

            // Hora actual
            Text(
              'Hora actual: ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
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

  /// Horarios regulares
  Widget _buildRegularSchedules() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.scheduleData.length,
        itemBuilder: (context, index) {
          final schedule = controller.scheduleData[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ScheduleCard(
              title: schedule['title'],
              subtitle: schedule['subtitle'],
              schedule: schedule['schedule'],
              zones: Map<String, String>.from(schedule['zones']),
              icon: _getIconForSchedule(schedule['icon']),
              isActive: _isScheduleActive(schedule),
            ),
          );
        },
      ),
    );
  }

  /// Horarios especiales
  Widget _buildSpecialSchedules() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.specialSchedules.length,
        itemBuilder: (context, index) {
          final special = controller.specialSchedules[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getIconForSpecialSchedule(special['type']),
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                special['title'],
                                style: AppTextStyles.subtitle1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                special['description'],
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          special['schedule'],
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          special['dates'],
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Información adicional
  Widget _buildAdditionalInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primaryBlue),
                const SizedBox(width: 12),
                Text(
                  'Información Importante',
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              '⏰ Puntualidad',
              'Los estudiantes deben llegar puntualmente a su horario reservado.',
            ),
            _buildInfoItem(
              '🔒 Acceso',
              'El acceso al taller requiere completar la inducción de seguridad.',
            ),
            _buildInfoItem(
              '📱 Reservaciones',
              'Se recomienda hacer reservaciones con al menos 24 horas de anticipación.',
            ),
            _buildInfoItem(
              '🛠️ Mantenimiento',
              'Los horarios pueden cambiar por mantenimiento de equipos.',
            ),
          ],
        ),
      ),
    );
  }

  /// Item de información
  Widget _buildInfoItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Obtener ícono para tipo de horario
  IconData _getIconForSchedule(String type) {
    switch (type) {
      case 'weekday':
        return Icons.work;
      case 'weekend':
        return Icons.weekend;
      case 'closed':
        return Icons.close;
      default:
        return Icons.schedule;
    }
  }

  /// Obtener ícono para horario especial
  IconData _getIconForSpecialSchedule(String type) {
    switch (type) {
      case 'exam_period':
        return Icons.school;
      case 'holiday':
        return Icons.celebration;
      case 'vacation':
        return Icons.beach_access;
      default:
        return Icons.event;
    }
  }

  /// Verificar si un horario está activo
  bool _isScheduleActive(Map<String, dynamic> schedule) {
    final title = schedule['title'].toString().toLowerCase();
    final now = DateTime.now();
    final currentDay = now.weekday;

    if (title.contains('lunes') && currentDay >= 1 && currentDay <= 5) {
      return true;
    } else if (title.contains('sábado') && currentDay == 6) {
      return true;
    } else if (title.contains('domingo') && currentDay == 7) {
      return true;
    }

    return false;
  }
}
