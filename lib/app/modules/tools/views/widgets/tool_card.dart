import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/tool_model.dart';
import '../../controllers/tools_controller.dart';

/// Widget de tarjeta para mostrar información de una herramienta
class ToolCard extends GetView<ToolsController> {
  final ToolModel tool;
  final VoidCallback onTap;
  
  const ToolCard({
    super.key,
    required this.tool,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Imagen de la herramienta
              _buildToolImage(),
              
              const SizedBox(width: 16),
              
              // Información de la herramienta
              Expanded(
                child: _buildToolInfo(),
              ),
              
              // Indicadores de estado
              _buildStatusIndicators(),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Imagen de la herramienta
  Widget _buildToolImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(8),
        image: tool.imagePath.isNotEmpty
            ? DecorationImage(
                image: AssetImage(tool.imagePath),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              )
            : null,
      ),
      child: tool.imagePath.isEmpty
          ? Icon(
              controller.getCategoryIcon(tool.category),
              size: 32,
              color: controller.getCategoryColor(tool.category),
            )
          : null,
    );
  }
  
  /// Información de la herramienta
  Widget _buildToolInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre de la herramienta
        Text(
          tool.name,
          style: AppTextStyles.subtitle1.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 4),
        
        // Categoría
        Row(
          children: [
            Icon(
              controller.getCategoryIcon(tool.category),
              size: 14,
              color: controller.getCategoryColor(tool.category),
            ),
            const SizedBox(width: 4),
            Text(
              tool.category.displayName,
              style: AppTextStyles.caption.copyWith(
                color: controller.getCategoryColor(tool.category),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Descripción corta
        Text(
          tool.description,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 8),
        
        // Ubicación
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                tool.workshopZone,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// Indicadores de estado
  Widget _buildStatusIndicators() {
    return Column(
      children: [
        // Estado principal
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: controller.getStatusColor(tool.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: controller.getStatusColor(tool.status).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                controller.getStatusIcon(tool.status),
                size: 12,
                color: controller.getStatusColor(tool.status),
              ),
              const SizedBox(width: 4),
              Text(
                tool.status.displayName,
                style: AppTextStyles.overline.copyWith(
                  color: controller.getStatusColor(tool.status),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Indicador de disponibilidad
        if (tool.canBeUsed)
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          )
        else
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        
        const SizedBox(height: 8),
        
        // Icono de flecha
        Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.textSecondary.withOpacity(0.5),
        ),
      ],
    );
  }
}