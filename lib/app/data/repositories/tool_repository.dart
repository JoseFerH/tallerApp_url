import '../models/tool_model.dart';
import '../providers/local_storage_provider.dart';
import '../../core/utils/constants.dart';
import '../../core/values/assets.dart';

/// Repositorio para manejar las herramientas del taller
class ToolRepository {
  final LocalStorageProvider _storage = LocalStorageProvider();
  
  /// Obtener todas las herramientas
  Future<List<ToolModel>> getAllTools() async {
    try {
      final toolsData = _storage.getTools();
      return toolsData.map((data) => ToolModel.fromMap(data)).toList();
    } catch (e) {
      print('Error obteniendo herramientas: $e');
      return [];
    }
  }
  
  /// Obtener herramienta por ID
  Future<ToolModel?> getToolById(String id) async {
    try {
      final toolsData = _storage.getTools();
      final toolData = toolsData.firstWhere(
        (data) => data['id'] == id,
        orElse: () => {},
      );
      
      if (toolData.isNotEmpty) {
        return ToolModel.fromMap(toolData);
      }
      return null;
    } catch (e) {
      print('Error obteniendo herramienta por ID: $e');
      return null;
    }
  }
  
  /// Buscar herramientas por texto
  Future<List<ToolModel>> searchTools(String query) async {
    try {
      final allTools = await getAllTools();
      
      if (query.isEmpty) return allTools;
      
      return allTools.where((tool) => tool.matchesSearch(query)).toList();
    } catch (e) {
      print('Error buscando herramientas: $e');
      return [];
    }
  }
  
  /// Filtrar herramientas por categoría
  Future<List<ToolModel>> getToolsByCategory(ToolCategory? category) async {
    try {
      final allTools = await getAllTools();
      
      if (category == null) return allTools;
      
      return allTools.where((tool) => tool.category == category).toList();
    } catch (e) {
      print('Error filtrando herramientas por categoría: $e');
      return [];
    }
  }
  
  /// Obtener herramientas disponibles
  Future<List<ToolModel>> getAvailableTools() async {
    try {
      final allTools = await getAllTools();
      return allTools.where((tool) => tool.canBeUsed).toList();
    } catch (e) {
      print('Error obteniendo herramientas disponibles: $e');
      return [];
    }
  }
  
  /// Obtener herramientas que necesitan mantenimiento
  Future<List<ToolModel>> getToolsNeedingMaintenance() async {
    try {
      final allTools = await getAllTools();
      return allTools.where((tool) => tool.needsMaintenance).toList();
    } catch (e) {
      print('Error obteniendo herramientas que necesitan mantenimiento: $e');
      return [];
    }
  }
  
  /// Actualizar estado de herramienta
  Future<bool> updateToolStatus(String toolId, ToolStatus newStatus) async {
    try {
      final tool = await getToolById(toolId);
      if (tool == null) return false;
      
      final updatedTool = tool.changeStatus(newStatus);
      await _storage.updateTool(toolId, updatedTool.toMap());
      
      return true;
    } catch (e) {
      print('Error actualizando estado de herramienta: $e');
      return false;
    }
  }
  
  /// Marcar mantenimiento completado
  Future<bool> markMaintenanceCompleted(String toolId) async {
    try {
      final tool = await getToolById(toolId);
      if (tool == null) return false;
      
      final updatedTool = tool.markMaintenanceCompleted();
      await _storage.updateTool(toolId, updatedTool.toMap());
      
      return true;
    } catch (e) {
      print('Error marcando mantenimiento completado: $e');
      return false;
    }
  }
  
  /// Obtener estadísticas de herramientas
  Future<Map<String, dynamic>> getToolsStats() async {
    try {
      final allTools = await getAllTools();
      
      int totalTools = allTools.length;
      int availableTools = 0;
      int maintenanceTools = 0;
      int unavailableTools = 0;
      int borrowedTools = 0;
      
      Map<String, int> categoryCount = {};
      
      for (final tool in allTools) {
        // Contar por estado
        switch (tool.status) {
          case ToolStatus.disponible:
            availableTools++;
            break;
          case ToolStatus.mantenimiento:
            maintenanceTools++;
            break;
          case ToolStatus.noDisponible:
            unavailableTools++;
            break;
          case ToolStatus.prestada:
            borrowedTools++;
            break;
        }
        
        // Contar por categoría
        final categoryName = tool.category.displayName;
        categoryCount[categoryName] = (categoryCount[categoryName] ?? 0) + 1;
      }
      
      return {
        'totalTools': totalTools,
        'availableTools': availableTools,
        'maintenanceTools': maintenanceTools,
        'unavailableTools': unavailableTools,
        'borrowedTools': borrowedTools,
        'categoryCount': categoryCount,
        'needMaintenanceCount': (await getToolsNeedingMaintenance()).length,
      };
    } catch (e) {
      print('Error obteniendo estadísticas de herramientas: $e');
      return {};
    }
  }
  
  /// Buscar herramientas por zona del taller
  Future<List<ToolModel>> getToolsByZone(String zone) async {
    try {
      final allTools = await getAllTools();
      return allTools.where((tool) => 
        tool.workshopZone.toLowerCase().contains(zone.toLowerCase())
      ).toList();
    } catch (e) {
      print('Error obteniendo herramientas por zona: $e');
      return [];
    }
  }
  
  /// Obtener herramientas populares (para futuras versiones con métricas de uso)
  Future<List<ToolModel>> getPopularTools() async {
    try {
      // Por ahora retornamos todas las herramientas disponibles
      // En el futuro se podría implementar métricas de uso
      final availableTools = await getAvailableTools();
      
      // Ordenar por nombre como criterio temporal
      availableTools.sort((a, b) => a.name.compareTo(b.name));
      
      // Retornar las primeras 10
      return availableTools.take(10).toList();
    } catch (e) {
      print('Error obteniendo herramientas populares: $e');
      return [];
    }
  }
  
  /// Obtener herramientas similares (por categoría)
  Future<List<ToolModel>> getSimilarTools(String toolId) async {
    try {
      final tool = await getToolById(toolId);
      if (tool == null) return [];
      
      final toolsByCategory = await getToolsByCategory(tool.category);
      
      // Remover la herramienta actual de la lista
      toolsByCategory.removeWhere((t) => t.id == toolId);
      
      // Retornar máximo 5 herramientas similares
      return toolsByCategory.take(5).toList();
    } catch (e) {
      print('Error obteniendo herramientas similares: $e');
      return [];
    }
  }
  
  /// Validar datos de herramienta
  Map<String, String> validateToolData(Map<String, dynamic> toolData) {
    Map<String, String> errors = {};
    
    if (toolData['name'] == null || toolData['name'].toString().trim().isEmpty) {
      errors['name'] = 'El nombre es requerido';
    }
    
    if (toolData['description'] == null || toolData['description'].toString().trim().isEmpty) {
      errors['description'] = 'La descripción es requerida';
    }
    
    if (toolData['category'] == null) {
      errors['category'] = 'La categoría es requerida';
    }
    
    if (toolData['safetyInstructions'] == null || 
        toolData['safetyInstructions'].toString().trim().isEmpty) {
      errors['safetyInstructions'] = 'Las instrucciones de seguridad son requeridas';
    }
    
    if (toolData['maintenanceInfo'] == null || 
        toolData['maintenanceInfo'].toString().trim().isEmpty) {
      errors['maintenanceInfo'] = 'La información de mantenimiento es requerida';
    }
    
    if (toolData['workshopZone'] == null || 
        toolData['workshopZone'].toString().trim().isEmpty) {
      errors['workshopZone'] = 'La zona del taller es requerida';
    }
    
    return errors;
  }
  
  /// Exportar catálogo de herramientas (para admin)
  Future<Map<String, dynamic>> exportToolsCatalog() async {
    try {
      final allTools = await getAllTools();
      final stats = await getToolsStats();
      
      return {
        'exportDate': DateTime.now().toIso8601String(),
        'totalTools': allTools.length,
        'statistics': stats,
        'tools': allTools.map((tool) => tool.toMap()).toList(),
      };
    } catch (e) {
      print('Error exportando catálogo: $e');
      return {};
    }
  }
  
  /// Obtener herramientas por tags
  Future<List<ToolModel>> getToolsByTags(List<String> tags) async {
    try {
      final allTools = await getAllTools();
      
      return allTools.where((tool) {
        return tags.any((tag) => 
          tool.tags.any((toolTag) => 
            toolTag.toLowerCase().contains(tag.toLowerCase())
          )
        );
      }).toList();
    } catch (e) {
      print('Error obteniendo herramientas por tags: $e');
      return [];
    }
  }
  
  /// Obtener todas las categorías con cantidad de herramientas
  Future<Map<ToolCategory, int>> getCategoriesWithCount() async {
    try {
      final allTools = await getAllTools();
      Map<ToolCategory, int> categoryCount = {};
      
      for (ToolCategory category in ToolCategory.values) {
        categoryCount[category] = allTools.where((tool) => tool.category == category).length;
      }
      
      return categoryCount;
    } catch (e) {
      print('Error obteniendo categorías con conteo: $e');
      return {};
    }
  }
  
  /// Buscar herramientas avanzada (múltiples criterios)
  Future<List<ToolModel>> advancedSearch({
    String? query,
    ToolCategory? category,
    ToolStatus? status,
    String? zone,
    List<String>? tags,
  }) async {
    try {
      List<ToolModel> results = await getAllTools();
      
      // Filtrar por query de búsqueda
      if (query != null && query.isNotEmpty) {
        results = results.where((tool) => tool.matchesSearch(query)).toList();
      }
      
      // Filtrar por categoría
      if (category != null) {
        results = results.where((tool) => tool.category == category).toList();
      }
      
      // Filtrar por estado
      if (status != null) {
        results = results.where((tool) => tool.status == status).toList();
      }
      
      // Filtrar por zona
      if (zone != null && zone.isNotEmpty) {
        results = results.where((tool) => 
          tool.workshopZone.toLowerCase().contains(zone.toLowerCase())
        ).toList();
      }
      
      // Filtrar por tags
      if (tags != null && tags.isNotEmpty) {
        results = results.where((tool) {
          return tags.any((tag) => 
            tool.tags.any((toolTag) => 
              toolTag.toLowerCase().contains(tag.toLowerCase())
            )
          );
        }).toList();
      }
      
      return results;
    } catch (e) {
      print('Error en búsqueda avanzada: $e');
      return [];
    }
  }
}