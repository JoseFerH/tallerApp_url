import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/constants.dart';
import '../../controllers/reservation_controller.dart';

/// Widget para seleccionar la zona del taller
class ZoneSelector extends GetView<ReservationController> {
  const ZoneSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: WorkshopZone.values.length,
        itemBuilder: (context, index) {
          final zone = WorkshopZone.values[index];
          final isSelected = controller.selectedZone.value == zone;

          return _buildZoneCard(zone, isSelected);
        },
      ),
    );
  }

  /// Construir tarjeta de zona
  Widget _buildZoneCard(WorkshopZone zone, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.selectZone(zone),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? controller.getZoneColor(zone)
                    : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? controller.getZoneColor(zone).withOpacity(0.2)
                      : AppColors.cardShadow,
              offset: const Offset(0, 4),
              blurRadius: isSelected ? 12 : 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono de la zona
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? controller.getZoneColor(zone)
                          : controller.getZoneColor(zone).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  controller.getZoneIcon(zone),
                  size: 24,
                  color:
                      isSelected
                          ? AppColors.white
                          : controller.getZoneColor(zone),
                ),
              ),

              const SizedBox(height: 12),

              // Nombre de la zona
              Text(
                zone.displayName,
                style: AppTextStyles.labelLarge.copyWith(
                  color:
                      isSelected
                          ? controller.getZoneColor(zone)
                          : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Indicador de selección
              if (isSelected) ...[
                const SizedBox(height: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: controller.getZoneColor(zone),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: AppColors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
