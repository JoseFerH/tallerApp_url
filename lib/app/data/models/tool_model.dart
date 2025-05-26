import 'dart:convert';
import '../../core/utils/constants.dart';

/// Modelo de datos para herramientas del taller
class ToolModel {
  final String id;                    // ID único de la herramienta
  final String name;                  // Nombre de la herramienta
  final String description;           // Descripción detallada
  final ToolCategory category;        // Categoría de la herramienta
  final String imagePath;             // Ruta de la imagen en assets
  final String safetyInstructions;    // Instrucciones de seguridad
  final String maintenanceInfo;       // Información de cuidados y mantenimiento
  final String workshopZone;          // Zona del taller donde se encuentra
  final ToolStatus status;            // Estado actual de la herramienta
  final DateTime? lastMaintenance;    // Fecha del último mantenimiento
  final String? additionalNotes;      // Notas adicionales
  final List<String> tags;            // Tags para búsqueda
  final bool isAvailable;             // Disponibilidad general
  
  ToolModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imagePath,
    required this.safetyInstructions,
    required this.maintenanceInfo,
    required this.workshopZone,
    this.status = ToolStatus.disponible,
    this.lastMaintenance,
    this.additionalNotes,
    this.tags = const [],
    this.isAvailable = true,
  });
  
  /// Crear copia de la herramienta con algunos campos modificados
  ToolModel copyWith({
    String? id,
    String? name,
    String? description,
    ToolCategory? category,
    String? imagePath,
    String? safetyInstructions,
    String? maintenanceInfo,
    String? workshopZone,
    ToolStatus? status,
    DateTime? lastMaintenance,
    String? additionalNotes,
    List<String>? tags,
    bool? isAvailable,
  }) {
    return ToolModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      safetyInstructions: safetyInstructions ?? this.safetyInstructions,
      maintenanceInfo: maintenanceInfo ?? this.maintenanceInfo,
      workshopZone: workshopZone ?? this.workshopZone,
      status: status ?? this.status,
      lastMaintenance: lastMaintenance ?? this.lastMaintenance,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      tags: tags ?? this.tags,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
  
  /// Cambiar estado de la herramienta
  ToolModel changeStatus(ToolStatus newStatus) {
    return copyWith(status: newStatus);
  }
  
  /// Marcar mantenimiento realizado
  ToolModel markMaintenanceCompleted() {
    return copyWith(
      status: ToolStatus.disponible,
      lastMaintenance: DateTime.now(),
    );
  }
  
  /// Verificar si la herramienta está disponible para uso
  bool get canBeUsed {
    return isAvailable && 
           status == ToolStatus.disponible;
  }
  
  /// Verificar si necesita mantenimiento
  bool get needsMaintenance {
    if (lastMaintenance == null) return false;
    
    final daysSinceMaintenance = DateTime.now().difference(lastMaintenance!).inDays;
    return daysSinceMaintenance > 90; // Mantenimiento cada 3 meses
  }
  
  /// Obtener color según el estado
  String get statusColor {
    switch (status) {
      case ToolStatus.disponible:
        return '#28A745'; // Verde
      case ToolStatus.mantenimiento:
        return '#FFC107'; // Amarillo
      case ToolStatus.noDisponible:
        return '#DC3545'; // Rojo
      case ToolStatus.prestada:
        return '#17A2B8'; // Azul
    }
  }
  
  /// Buscar en herramienta
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    final lowerQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowerQuery) ||
           description.toLowerCase().contains(lowerQuery) ||
           category.displayName.toLowerCase().contains(lowerQuery) ||
           workshopZone.toLowerCase().contains(lowerQuery) ||
           tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
  }
  
  /// Filtrar por categoría
  bool matchesCategory(ToolCategory? filterCategory) {
    if (filterCategory == null) return true;
    return category == filterCategory;
  }
  
  /// Obtener tiempo desde último mantenimiento
  String get maintenanceStatus {
    if (lastMaintenance == null) return 'Sin registros';
    
    final daysSince = DateTime.now().difference(lastMaintenance!).inDays;
    if (daysSince < 30) return 'Reciente';
    if (daysSince < 60) return 'Hace ${daysSince} días';
    if (daysSince < 90) return 'Próximo a vencer';
    return 'Requiere mantenimiento';
  }
  
  /// Convertir a Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.name,
      'imagePath': imagePath,
      'safetyInstructions': safetyInstructions,
      'maintenanceInfo': maintenanceInfo,
      'workshopZone': workshopZone,
      'status': status.name,
      'lastMaintenance': lastMaintenance?.toIso8601String(),
      'additionalNotes': additionalNotes,
      'tags': tags,
      'isAvailable': isAvailable,
    };
  }
  
  /// Crear desde Map
  factory ToolModel.fromMap(Map<String, dynamic> map) {
    return ToolModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: ToolCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ToolCategory.manuales,
      ),
      imagePath: map['imagePath'] ?? '',
      safetyInstructions: map['safetyInstructions'] ?? '',
      maintenanceInfo: map['maintenanceInfo'] ?? '',
      workshopZone: map['workshopZone'] ?? '',
      status: ToolStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ToolStatus.disponible,
      ),
      lastMaintenance: map['lastMaintenance'] != null 
          ? DateTime.parse(map['lastMaintenance']) 
          : null,
      additionalNotes: map['additionalNotes'],
      tags: List<String>.from(map['tags'] ?? []),
      isAvailable: map['isAvailable'] ?? true,
    );
  }
  
  /// Convertir a JSON
  String toJson() => json.encode(toMap());
  
  /// Crear desde JSON
  factory ToolModel.fromJson(String source) => ToolModel.fromMap(json.decode(source));
  
  @override
  String toString() {
    return 'ToolModel(id: $id, name: $name, category: $category, status: $status)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ToolModel && other.id == id;
  }
  
  @override
  int get hashCode {
    return id.hashCode;
  }
}