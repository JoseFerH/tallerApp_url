import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../core/utils/constants.dart';

/// Modelo de datos para reservaciones del taller
class ReservationModel {
  final String id;                    // ID único de la reservación (UUID)
  final String userId;                // ID del usuario que hizo la reservación
  final String userName;              // Nombre del usuario
  final WorkshopZone zone;           // Zona del taller reservada
  final DateTime date;               // Fecha de la reservación
  final TimeSlot timeSlot;           // Bloque de tiempo reservado
  final ReservationStatus status;    // Estado de la reservación
  final String? purpose;             // Propósito de la reservación (opcional)
  final DateTime createdAt;          // Fecha de creación de la reservación
  final DateTime? completedAt;       // Fecha de completación (si aplica)
  final DateTime? canceledAt;        // Fecha de cancelación (si aplica)
  final String? cancelationReason;   // Razón de cancelación
  final String? notes;               // Notas adicionales
  
  ReservationModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.zone,
    required this.date,
    required this.timeSlot,
    this.status = ReservationStatus.activa,
    this.purpose,
    required this.createdAt,
    this.completedAt,
    this.canceledAt,
    this.cancelationReason,
    this.notes,
  });
  
  /// Constructor para crear una nueva reservación
  factory ReservationModel.create({
    required String userId,
    required String userName,
    required WorkshopZone zone,
    required DateTime date,
    required TimeSlot timeSlot,
    String? purpose,
  }) {
    return ReservationModel(
      id: const Uuid().v4(),
      userId: userId,
      userName: userName,
      zone: zone,
      date: date,
      timeSlot: timeSlot,
      purpose: purpose,
      createdAt: DateTime.now(),
    );
  }
  
  /// Crear copia de la reservación con algunos campos modificados
  ReservationModel copyWith({
    String? id,
    String? userId,
    String? userName,
    WorkshopZone? zone,
    DateTime? date,
    TimeSlot? timeSlot,
    ReservationStatus? status,
    String? purpose,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? canceledAt,
    String? cancelationReason,
    String? notes,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      zone: zone ?? this.zone,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      purpose: purpose ?? this.purpose,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      canceledAt: canceledAt ?? this.canceledAt,
      cancelationReason: cancelationReason ?? this.cancelationReason,
      notes: notes ?? this.notes,
    );
  }
  
  /// Cancelar reservación
  ReservationModel cancel(String reason) {
    return copyWith(
      status: ReservationStatus.cancelada,
      canceledAt: DateTime.now(),
      cancelationReason: reason,
    );
  }
  
  /// Marcar como completada
  ReservationModel complete() {
    return copyWith(
      status: ReservationStatus.completada,
      completedAt: DateTime.now(),
    );
  }
  
  /// Marcar como no show
  ReservationModel markNoShow() {
    return copyWith(
      status: ReservationStatus.noShow,
    );
  }
  
  /// Verificar si la reservación es para hoy
  bool get isToday {
    final today = DateTime.now();
    return date.year == today.year &&
           date.month == today.month &&
           date.day == today.day;
  }
  
  /// Verificar si la reservación es para el futuro
  bool get isFuture {
    return date.isAfter(DateTime.now());
  }
  
  /// Verificar si la reservación es del pasado
  bool get isPast {
    final endTime = timeSlot.getEndTime(date);
    return endTime.isBefore(DateTime.now());
  }
  
  /// Verificar si la reservación está activa
  bool get isActive {
    return status == ReservationStatus.activa;
  }
  
  /// Verificar si se puede cancelar
  bool get canBeCanceled {
    if (status != ReservationStatus.activa) return false;
    
    // No se puede cancelar si faltan menos de 2 horas
    final startTime = timeSlot.getStartTime(date);
    final hoursUntilStart = startTime.difference(DateTime.now()).inHours;
    return hoursUntilStart >= 2;
  }
  
  /// Obtener tiempo de inicio
  DateTime get startTime => timeSlot.getStartTime(date);
  
  /// Obtener tiempo de fin
  DateTime get endTime => timeSlot.getEndTime(date);
  
  /// Obtener duración en horas
  int get durationHours => endTime.difference(startTime).inHours;
  
  /// Obtener color según el estado
  String get statusColor {
    switch (status) {
      case ReservationStatus.activa:
        return '#28A745'; // Verde
      case ReservationStatus.completada:
        return '#6C757D'; // Gris
      case ReservationStatus.cancelada:
        return '#DC3545'; // Rojo
      case ReservationStatus.noShow:
        return '#FFC107'; // Amarillo
    }
  }
  
  /// Obtener descripción de fecha y hora formateada
  String get formattedDateTime {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    final month = months[date.month - 1];
    return '${date.day} de $month, ${date.year} - ${timeSlot.displayName}';
  }
  
  /// Obtener tiempo restante hasta la reservación
  String get timeUntilReservation {
    if (isPast) return 'Pasada';
    
    final now = DateTime.now();
    final difference = startTime.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Ahora';
    }
  }
  
  /// Convertir a Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'zone': zone.name,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot.name,
      'status': status.name,
      'purpose': purpose,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'canceledAt': canceledAt?.toIso8601String(),
      'cancelationReason': cancelationReason,
      'notes': notes,
    };
  }
  
  /// Crear desde Map
  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      zone: WorkshopZone.values.firstWhere(
        (e) => e.name == map['zone'],
        orElse: () => WorkshopZone.areaGeneral,
      ),
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      timeSlot: TimeSlot.values.firstWhere(
        (e) => e.name == map['timeSlot'],
        orElse: () => TimeSlot.slot0900,
      ),
      status: ReservationStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ReservationStatus.activa,
      ),
      purpose: map['purpose'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
      canceledAt: map['canceledAt'] != null ? DateTime.parse(map['canceledAt']) : null,
      cancelationReason: map['cancelationReason'],
      notes: map['notes'],
    );
  }
  
  /// Convertir a JSON
  String toJson() => json.encode(toMap());
  
  /// Crear desde JSON
  factory ReservationModel.fromJson(String source) => ReservationModel.fromMap(json.decode(source));
  
  @override
  String toString() {
    return 'ReservationModel(id: $id, userName: $userName, zone: $zone, date: $date, status: $status)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ReservationModel && other.id == id;
  }
  
  @override
  int get hashCode {
    return id.hashCode;
  }
}