import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/tool_repository.dart';
import '../../../data/models/tool_model.dart';
import '../../../core/utils/constants.dart';
import '../../../routes/app_routes.dart';

/// Controlador para el módulo de herramientas
class ToolsController extends GetxController {
  final ToolRepository toolRepository;
  
  ToolsController({required this.toolRepository});
  
  // Controladores de UI
  final TextEditingController searchController = TextEditingController();
  
  // Estados reactivos
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxList<ToolModel> allTools = <ToolModel>[].obs;
  final RxList<ToolModel> filteredTools = <ToolModel>[].obs;
  final Rx<ToolCategory?> selectedCategory = Rx<ToolCategory?>(null);
  final RxString searchQuery = ''.obs;
  
  // Herramienta seleccionada para detalles
  final Rx<ToolModel?> selectedTool = Rx<ToolModel?>(null);
  
  // Estadísticas
  final RxMap<ToolCategory, int> categoryStats = <ToolCategory, int>{}.obs;
  
  @override
  void onInit() {
    super.onInit();
    _initializeTools();
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  
  /// Inicializar herramientas
  Future<void> _initializeTools() async {
    await loadAllTools();
    _updateCategoryStats();
  }
  
  /// Cargar todas las herramientas
  Future<void> loadAllTools() async {
    try {
      isLoading.value = true;
      
      final tools = await toolRepository.getAllTools();
      allTools.value = tools;
      
      // Aplicar filtros actuales
      _applyFilters();
      
    } catch (e) {
      print('Error cargando herramientas: $e');
      Get.snackbar(
        'Error',
        'No se pudieron cargar las herramientas',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Buscar herramientas
  void searchTools(String query) {
    searchQuery.value = query;
    _applyFilters();
  }
  
  /// Filtrar por categoría
  void filterByCategory(ToolCategory? category) {
    selectedCategory.value = category;
    _applyFilters();
  }
  
  /// Aplicar filtros combinados
  void _applyFilters() {
    List<ToolModel> results = allTools.toList();
    
    // Filtrar por búsqueda
    if (searchQuery.value.isNotEmpty) {
      results = results.where((tool) => tool.matchesSearch(searchQuery.value)).toList();
    }
    
    // Filtrar por categoría
    if (selectedCategory.value != null) {
      results = results.where((tool) => tool.category == selectedCategory.value).toList();
    }
    
    filteredTools.value = results;
  }
  
  /// Limpiar búsqueda
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _applyFilters();
  }
  
  /// Limpiar filtros
  void clearFilters() {
    selectedCategory.value = null;
    clearSearch();
  }
  
  /// Seleccionar herramienta y navegar a detalles
  void selectTool(ToolModel tool) {
    selectedTool.value = tool;
    Get.toNamed(AppRoutes.TOOL_DETAIL, arguments: tool);
  }
  
  /// Obtener herramientas por categoría
  List<ToolModel> getToolsByCategory(ToolCategory category) {
    return allTools.where((tool) => tool.category == category).toList();
  }
  
  /// Obtener herramientas disponibles
  List<ToolModel> getAvailableTools() {
    return allTools.where((tool) => tool.canBeUsed).toList();
  }
  
  /// Obtener herramientas similares
  Future<List<ToolModel>> getSimilarTools(ToolModel tool) async {
    try {
      return await toolRepository.getSimilarTools(tool.id);
    } catch (e) {
      print('Error obteniendo herramientas similares: $e');
      return [];
    }
  }
  
  /// Actualizar estadísticas de categorías
  void _updateCategoryStats() {
    Map<ToolCategory, int> stats = {};
    
    for (ToolCategory category in ToolCategory.values) {
      stats[category] = allTools.where((tool) => tool.category == category).length;
    }
    
    categoryStats.value = stats;
  }
  
  /// Obtener color de la categoría
  Color getCategoryColor(ToolCategory category) {
    switch (category) {
      case ToolCategory.manuales:
        return Colors.blue;
      case ToolCategory.electricas:
        return Colors.orange;
      case ToolCategory.medicion:
        return Colors.green;
      case ToolCategory.seguridad:
        return Colors.red;
    }
  }
  
  /// Obtener ícono de la categoría
  IconData getCategoryIcon(ToolCategory category) {
    switch (category) {
      case ToolCategory.manuales:
        return Icons.build;
      case ToolCategory.electricas:
        return Icons.electrical_services;
      case ToolCategory.medicion:
        return Icons.straighten;
      case ToolCategory.seguridad:
        return Icons.security;
    }
  }
  
  /// Obtener ícono del estado de la herramienta
  IconData getStatusIcon(ToolStatus status) {
    switch (status) {
      case ToolStatus.disponible:
        return Icons.check_circle;
      case ToolStatus.mantenimiento:
        return Icons.build_circle;
      case ToolStatus.noDisponible:
        return Icons.cancel;
      case ToolStatus.prestada:
        return Icons.access_time;
    }
  }
  
  /// Obtener color del estado de la herramienta
  Color getStatusColor(ToolStatus status) {
    switch (status) {
      case ToolStatus.disponible:
        return Colors.green;
      case ToolStatus.mantenimiento:
        return Colors.orange;
      case ToolStatus.noDisponible:
        return Colors.red;
      case ToolStatus.prestada:
        return Colors.blue;
    }
  }
  
  /// Refrescar herramientas
  Future<void> refreshTools() async {
    await loadAllTools();
  }
  
  /// Obtener total de herramientas
  int get totalTools => allTools.length;
  
  /// Obtener herramientas filtradas count
  int get filteredToolsCount => filteredTools.length;
  
  /// Obtener herramientas disponibles count
  int get availableToolsCount => allTools.where((tool) => tool.canBeUsed).length;
  
  /// Verificar si hay filtros activos
  bool get hasActiveFilters => 
      searchQuery.value.isNotEmpty || selectedCategory.value != null;
  
  /// Obtener texto del filtro activo
  String get activeFilterText {
    List<String> filters = [];
    
    if (searchQuery.value.isNotEmpty) {
      filters.add('Búsqueda: "${searchQuery.value}"');
    }
    
    if (selectedCategory.value != null) {
      filters.add('Categoría: ${selectedCategory.value!.displayName}');
    }
    
    return filters.join(' • ');
  }
  
  /// Obtener herramientas populares (mock)
  List<ToolModel> getPopularTools() {
    // En una implementación real, esto vendría de métricas de uso
    return allTools.take(6).toList();
  }
  
  /// Obtener herramientas recientemente añadidas (mock)
  List<ToolModel> getRecentTools() {
    // En una implementación real, esto se basaría en fecha de creación
    return allTools.reversed.take(4).toList();
  }
  
  /// Navegar atrás
  void goBack() {
    Get.back();
  }
  
  /// Compartir herramienta (para futuras versiones)
  void shareTool(ToolModel tool) {
    // Funcionalidad de compartir
    Get.snackbar(
      'Compartir',
      'Funcionalidad de compartir será implementada próximamente',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  /// Reportar problema con herramienta (para futuras versiones)
  void reportProblem(ToolModel tool) {
    Get.dialog(
      AlertDialog(
        title: const Text('Reportar Problema'),
        content: Text('¿Deseas reportar un problema con ${tool.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Reporte Enviado',
                'Tu reporte ha been enviado al personal del taller',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Reportar'),
          ),
        ],
      ),
    );
  }
  
  /// Obtener sugerencias de búsqueda
  List<String> getSearchSuggestions() {
    return [
      'Martillo',
      'Destornillador',
      'Taladro',
      'Sierra',
      'Lijadora',
      'Fresadora',
      'Alicates',
      'Nivel',
      'Cinta métrica',
      'Vernier',
    ];
  }
  
  /// Buscar con sugerencia
  void searchWithSuggestion(String suggestion) {
    searchController.text = suggestion;
    searchTools(suggestion);
  }
}