import 'dart:convert';
import '../../core/utils/constants.dart';

/// Modelo extendido para las zonas del taller con información adicional
class WorkshopZoneModel {
  final WorkshopZone zone; // Zona del taller
  final String description; // Descripción detallada
  final List<String> equipment; // Equipamiento disponible
  final List<String> safetyRules; // Normas de seguridad específicas
  final int maxCapacity; // Capacidad máxima de personas
  final String supervisor; // Supervisor responsable
  final List<TimeSlot> availableSlots; // Horarios disponibles
  final String imagePath; // Imagen de la zona
  final bool isActive; // Si está activa/disponible
  final String? specialNotes; // Notas especiales

  WorkshopZoneModel({
    required this.zone,
    required this.description,
    this.equipment = const [],
    this.safetyRules = const [],
    required this.maxCapacity,
    required this.supervisor,
    this.availableSlots = const [],
    required this.imagePath,
    this.isActive = true,
    this.specialNotes,
  });

  /// Crear copia con algunos campos modificados
  WorkshopZoneModel copyWith({
    WorkshopZone? zone,
    String? description,
    List<String>? equipment,
    List<String>? safetyRules,
    int? maxCapacity,
    String? supervisor,
    List<TimeSlot>? availableSlots,
    String? imagePath,
    bool? isActive,
    String? specialNotes,
  }) {
    return WorkshopZoneModel(
      zone: zone ?? this.zone,
      description: description ?? this.description,
      equipment: equipment ?? this.equipment,
      safetyRules: safetyRules ?? this.safetyRules,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      supervisor: supervisor ?? this.supervisor,
      availableSlots: availableSlots ?? this.availableSlots,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
      specialNotes: specialNotes ?? this.specialNotes,
    );
  }

  /// Verificar si está disponible en un slot específico
  bool isAvailableAt(TimeSlot slot) {
    return isActive && availableSlots.contains(slot);
  }

  /// Obtener normas de seguridad como texto
  String get safetyRulesText {
    if (safetyRules.isEmpty) return 'Sin normas específicas registradas.';
    return safetyRules.map((rule) => '• $rule').join('\n');
  }

  /// Obtener equipamiento como texto
  String get equipmentText {
    if (equipment.isEmpty) return 'Sin equipamiento específico registrado.';
    return equipment.map((item) => '• $item').join('\n');
  }

  /// Obtener disponibilidad como texto
  String get availabilityText {
    if (!isActive) return 'Zona temporalmente cerrada';
    if (availableSlots.isEmpty) return 'Sin horarios definidos';

    final slots = availableSlots.map((slot) => slot.displayName).join(', ');
    return 'Disponible: $slots';
  }

  /// Convertir a Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'zone': zone.name,
      'description': description,
      'equipment': equipment,
      'safetyRules': safetyRules,
      'maxCapacity': maxCapacity,
      'supervisor': supervisor,
      'availableSlots': availableSlots.map((slot) => slot.name).toList(),
      'imagePath': imagePath,
      'isActive': isActive,
      'specialNotes': specialNotes,
    };
  }

  /// Crear desde Map
  factory WorkshopZoneModel.fromMap(Map<String, dynamic> map) {
    return WorkshopZoneModel(
      zone: WorkshopZone.values.firstWhere(
        (e) => e.name == map['zone'],
        orElse: () => WorkshopZone.areaGeneral,
      ),
      description: map['description'] ?? '',
      equipment: List<String>.from(map['equipment'] ?? []),
      safetyRules: List<String>.from(map['safetyRules'] ?? []),
      maxCapacity: map['maxCapacity'] ?? 1,
      supervisor: map['supervisor'] ?? '',
      availableSlots:
          (map['availableSlots'] as List<dynamic>?)
              ?.map(
                (slot) => TimeSlot.values.firstWhere(
                  (e) => e.name == slot,
                  orElse: () => TimeSlot.slot0900,
                ),
              )
              .toList() ??
          [],
      imagePath: map['imagePath'] ?? '',
      isActive: map['isActive'] ?? true,
      specialNotes: map['specialNotes'],
    );
  }

  /// Convertir a JSON
  String toJson() => json.encode(toMap());

  /// Crear desde JSON
  factory WorkshopZoneModel.fromJson(String source) =>
      WorkshopZoneModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WorkshopZoneModel(zone: $zone, isActive: $isActive, maxCapacity: $maxCapacity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkshopZoneModel && other.zone == zone;
  }

  @override
  int get hashCode => zone.hashCode;
}
