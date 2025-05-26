import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/strings.dart';
import '../../../data/models/tool_model.dart';
import '../controllers/tools_controller.dart';

/// Vista de detalles de una herramienta específica
class ToolDetailView extends GetView<ToolsController> {
  const ToolDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ToolModel tool = Get.arguments as ToolModel;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: _buildAppBar(tool),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen y información básica
            _buildToolHeader(tool),
            
            // Información detallada
            _buildToolDetails(tool),
            
            // Herramientas similares
            _buildSimilarTools(tool),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActions(tool),
    );
  }
  
  /// AppBar personalizada
  PreferredSizeWidget _buildAppBar(ToolModel tool) {
    return AppBar(
      title: Text(
        Strings.toolDetailTitle,
        style: AppTextStyles.h5.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => controller.shareTool(tool),
          icon: const Icon(Icons.share, color: AppColors.white),
          tooltip: 'Compartir',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.white),
          onSelected: (value) {
            switch (value) {
              case 'report':
                controller.reportProblem(tool);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'report',
              child: ListTile(
                leading: Icon(Icons.report_problem),
                title: Text('Reportar Problema'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// Header con imagen y información básica
  Widget _buildToolHeader(ToolModel tool) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          // Imagen de la herramienta
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              image: DecorationImage(
                image: AssetImage(tool.imagePath),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
            ),
            child: tool.imagePath.isEmpty
                ? Icon(
                    controller.getCategoryIcon(tool.category),
                    size: 80,
                    color: AppColors.textSecondary,
                  )
                : null,
          ),
          
          // Información básica
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y estado
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        tool.name,
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusBadge(tool),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Categoría
                Row(
                  children: [
                    Icon(
                      controller.getCategoryIcon(tool.category),
                      size: 18,
                      color: controller.getCategoryColor(tool.category),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tool.category.displayName,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: controller.getCategoryColor(tool.category),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Ubicación
                _buildInfoRow(
                  icon: Icons.location_on,
                  label: Strings.toolLocation,
                  value: tool.workshopZone,
                  color: AppColors.accentOrange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Badge de estado
  Widget _buildStatusBadge(ToolModel tool) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: controller.getStatusColor(tool.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
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
            size: 16,
            color: controller.getStatusColor(tool.status),
          ),
          const SizedBox(width: 4),
          Text(
            tool.status.displayName,
            style: AppTextStyles.labelSmall.copyWith(
              color: controller.getStatusColor(tool.status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Información detallada
  Widget _buildToolDetails(ToolModel tool) {
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Descripción
            _buildDetailSection(
              title: Strings.toolDescription,
              content: tool.description,
              icon: Icons.description,
            ),
            
            const SizedBox(height: 20),
            
            // Instrucciones de seguridad
            _buildDetailSection(
              title: Strings.toolSafetyInstructions,
              content: tool.safetyInstructions,
              icon: Icons.security,
              color: Colors.red,
            ),
            
            const SizedBox(height: 20),
            
            // Información de mantenimiento
            _buildDetailSection(
              title: Strings.toolMaintenanceInfo,
              content: tool.maintenanceInfo,
              icon: Icons.build_circle,
              color: Colors.blue,
            ),
            
            // Notas adicionales (si las hay)
            if (tool.additionalNotes != null && tool.additionalNotes!.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildDetailSection(
                title: 'Notas Adicionales',
                content: tool.additionalNotes!,
                icon: Icons.note,
                color: Colors.orange,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Sección de detalle
  Widget _buildDetailSection({
    required String title,
    required String content,
    required IconData icon,
    Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color ?? AppColors.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.h6.copyWith(
                color: color ?? AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
  
  /// Fila de información
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: color ?? AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  /// Herramientas similares
  Widget _buildSimilarTools(ToolModel tool) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Herramientas Similares',
              style: AppTextStyles.h6.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<ToolModel>>(
              future: controller.getSimilarTools(tool),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(
                    'No hay herramientas similares disponibles',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  );
                }
                
                return SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final similarTool = snapshot.data![index];
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => controller.selectTool(similarTool),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGray,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage(similarTool.imagePath),
                                    fit: BoxFit.cover,
                                    onError: (exception, stackTrace) {},
                                  ),
                                ),
                                child: similarTool.imagePath.isEmpty
                                    ? Icon(
                                        controller.getCategoryIcon(similarTool.category),
                                        color: AppColors.textSecondary,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                similarTool.name,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  /// Acciones flotantes
  Widget _buildFloatingActions(ToolModel tool) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Botón de compartir
        FloatingActionButton(
          heroTag: 'share',
          onPressed: () => controller.shareTool(tool),
          backgroundColor: AppColors.secondaryGreen,
          child: const Icon(Icons.share),
        ),
        
        const SizedBox(height: 12),
        
        // Botón principal (reservar espacio relacionado)
        FloatingActionButton.extended(
          heroTag: 'reserve',
          onPressed: () {
            // Navegar a reservaciones con filtro de zona
            Get.toNamed('/reservations', arguments: {
              'suggested_zone': tool.workshopZone,
            });
          },
          backgroundColor: AppColors.primaryBlue,
          icon: const Icon(Icons.event_available),
          label: const Text('Reservar'),
        ),
      ],
    );
  }
}