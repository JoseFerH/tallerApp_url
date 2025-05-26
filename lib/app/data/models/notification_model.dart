import 'dart:convert';
import 'package:uuid/uuid.dart';

/// Tipos de notificación
enum NotificationType {
  reservationReminder('Recordatorio de Reservación'),
  scheduleChange('Cambio de Horario'),
  systemUpdate('Actualización del Sistema'),
  maintenanceAlert('Alerta de Mantenimiento'),
  general('General');
  
  const NotificationType(this.displayName);
  final String displayName;
}

/// Prioridad de la notificación
enum NotificationPriority {
  low('Baja'),
  normal('Normal'),
  high('Alta'),
  urgent('Urgente');
  
  const NotificationPriority(this.displayName);
  final String displayName;
}

/// Modelo de datos para notificaciones del sistema
class NotificationModel {
  final String id;                      // ID único de la notificación
  final String title;                   // Título de la notificación
  final String message;                 // Mensaje de la notificación
  final NotificationType type;          // Tipo de notificación
  final NotificationPriority priority;  // Prioridad
  final DateTime createdAt;             // Fecha de creación
  final DateTime? scheduledFor;         // Fecha programada (opcional)
  final bool isRead;                    // Estado de lectura
  final bool isArchived;                // Estado de archivo
  final String? targetUserId;           // Usuario específico (null = todos)
  final String? relatedEntityId;        // ID de entidad relacionada (reservación, etc.)
  final String? relatedEntityType;      // Tipo de entidad relacionada
  final String? actionUrl;              // URL de acción (para futuras versiones)
  final Map<String, dynamic>? metadata; // Datos adicionales
  
  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.priority = NotificationPriority.normal,
    required this.createdAt,
    this.scheduledFor,
    this.isRead = false,
    this.isArchived = false,
    this.targetUserId,
    this.relatedEntityId,
    this.relatedEntityType,
    this.actionUrl,
    this.metadata,
  });
  
  /// Constructor para crear una nueva notificación
  factory NotificationModel.create({
    required String title,
    required String message,
    required NotificationType type,
    NotificationPriority priority = NotificationPriority.normal,
    DateTime? scheduledFor,
    String? targetUserId,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: const Uuid().v4(),
      title: title,
      message: message,
      type: type,
      priority: priority,
      createdAt: DateTime.now(),
      scheduledFor: scheduledFor,
      targetUserId: targetUserId,
      relatedEntityId: relatedEntityId,
      relatedEntityType: relatedEntityType,
      actionUrl: actionUrl,
      metadata: metadata,
    );
  }
  
  /// Crear notificación de recordatorio de reservación
  factory NotificationModel.reservationReminder({
    required String userId,
    required String reservationId,
    required String zoneName,
    required DateTime reservationTime,
  }) {
    return NotificationModel.create(
      title: 'Recordatorio de Reservación',
      message: 'Tu reservación de $zoneName es en 15 minutos',
      type: NotificationType.reservationReminder,
      priority: NotificationPriority.high,
      targetUserId: userId,
      relatedEntityId: reservationId,
      relatedEntityType: 'reservation',
      scheduledFor: reservationTime.subtract(const Duration(minutes: 15)),
      metadata: {
        'zoneName': zoneName,
        'reservationTime': reservationTime.toIso8601String(),
      },
    );
  }
  
  /// Crear notificación de cambio de horario
  factory NotificationModel.scheduleChange({
    required String title,
    required String message,
  }) {
    return NotificationModel.create(
      title: title,
      message: message,
      type: NotificationType.scheduleChange,
      priority: NotificationPriority.high,
    );
  }
  
  /// Crear notificación de actualización del sistema
  factory NotificationModel.systemUpdate({
    required String message,
  }) {
    return NotificationModel.create(
      title: 'Actualización del Sistema',
      message: message,
      type: NotificationType.systemUpdate,
      priority: NotificationPriority.normal,
    );
  }
  
  /// Crear copia de la notificación con algunos campos modificados
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? createdAt,
    DateTime? scheduledFor,
    bool? isRead,
    bool? isArchived,
    String? targetUserId,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      isRead: isRead ?? this.isRead,
      isArchived: isArchived ?? this.isArchived,
      targetUserId: targetUserId ?? this.targetUserId,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      relatedEntityType: relatedEntityType ?? this.relatedEntityType,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
    );
  }
  
  /// Marcar como leída
  NotificationModel markAsRead() {
    return copyWith(isRead: true);
  }
  
  /// Marcar como archivada
  NotificationModel archive() {
    return copyWith(isArchived: true);
  }
  
  /// Verificar si debe mostrarse ahora
  bool get shouldDisplay {
    if (isArchived) return false;
    if (scheduledFor != null && scheduledFor!.isAfter(DateTime.now())) return false;
    return true;
  }
  
  /// Verificar si es para un usuario específico
  bool isForUser(String userId) {
    return targetUserId == null || targetUserId == userId;
  }
  
  /// Obtener color según la prioridad
  String get priorityColor {
    switch (priority) {
      case NotificationPriority.low:
        return '#6C757D'; // Gris
      case NotificationPriority.normal:
        return '#17A2B8'; // Azul
      case NotificationPriority.high:
        return '#FFC107'; // Amarillo
      case NotificationPriority.urgent:
        return '#DC3545'; // Rojo
    }
  }
  
  /// Obtener ícono según el tipo
  String get typeIcon {
    switch (type) {
      case NotificationType.reservationReminder:
        return '⏰';
      case NotificationType.scheduleChange:
        return '📅';
      case NotificationType.systemUpdate:
        return '🔄';
      case NotificationType.maintenanceAlert:
        return '🔧';
      case NotificationType.general:
        return '📢';
    }
  }
  
  /// Obtener tiempo relativo desde la creación
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} semana${difference.inDays > 13 ? 's' : ''}';
    } else if (difference.inDays > 0) {
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
      'title': title,
      'message': message,
      'type': type.name,
      'priority': priority.name,
      'createdAt': createdAt.toIso8601String(),
      'scheduledFor': scheduledFor?.toIso8601String(),
      'isRead': isRead,
      'isArchived': isArchived,
      'targetUserId': targetUserId,
      'relatedEntityId': relatedEntityId,
      'relatedEntityType': relatedEntityType,
      'actionUrl': actionUrl,
      'metadata': metadata,
    };
  }
  
  /// Crear desde Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.general,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => NotificationPriority.normal,
      ),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      scheduledFor: map['scheduledFor'] != null ? DateTime.parse(map['scheduledFor']) : null,
      isRead: map['isRead'] ?? false,
      isArchived: map['isArchived'] ?? false,
      targetUserId: map['targetUserId'],
      relatedEntityId: map['relatedEntityId'],
      relatedEntityType: map['relatedEntityType'],
      actionUrl: map['actionUrl'],
      metadata: map['metadata'],
    );
  }
  
  /// Convertir a JSON
  String toJson() => json.encode(toMap());
  
  /// Crear desde JSON
  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source));
  
  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $type, isRead: $isRead)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is NotificationModel && other.id == id;
  }
  
  @override
  int get hashCode {
    return id.hashCode;
  }
}