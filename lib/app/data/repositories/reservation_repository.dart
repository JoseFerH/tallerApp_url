import '../models/reservation_model.dart';
import '../providers/local_storage_provider.dart';
import '../../core/utils/constants.dart';

/// Repositorio para manejar las reservaciones del taller
class ReservationRepository {
  final LocalStorageProvider _storage = LocalStorageProvider();
  
  /// Crear una nueva reservación
  Future<ReservationModel?> createReservation({
    required String userId,
    required String userName,
    required WorkshopZone zone,
    required DateTime date,
    required TimeSlot timeSlot,
    String? purpose,
  }) async {
    try {
      // Verificar si el slot está disponible
      final isAvailable = await isSlotAvailable(zone, date, timeSlot);
      if (!isAvailable) {
        return null; // Slot no disponible
      }
      
      // Verificar límite de reservaciones activas por usuario
      final userActiveReservations = await getActiveReservationsByUser(userId);
      if (userActiveReservations.length >= AppConstants.maxActiveReservationsPerUser) {
        return null; // Límite de reservaciones alcanzado
      }
      
      // Crear la reservación
      final reservation = ReservationModel.create(
        userId: userId,
        userName: userName,
        zone: zone,
        date: date,
        timeSlot: timeSlot,
        purpose: purpose,
      );
      
      // Guardar en el almacenamiento
      await _storage.addReservation(reservation.toMap());
      
      return reservation;
    } catch (e) {
      print('Error creando reservación: $e');
      return null;
    }
  }
  
  /// Obtener todas las reservaciones
  Future<List<ReservationModel>> getAllReservations() async {
    try {
      final reservationsData = _storage.getReservations();
      return reservationsData.map((data) => ReservationModel.fromMap(data)).toList();
    } catch (e) {
      print('Error obteniendo todas las reservaciones: $e');
      return [];
    }
  }
  
  /// Obtener reservación por ID
  Future<ReservationModel?> getReservationById(String id) async {
    try {
      final reservationsData = _storage.getReservations();
      final reservationData = reservationsData.firstWhere(
        (data) => data['id'] == id,
        orElse: () => {},
      );
      
      if (reservationData.isNotEmpty) {
        return ReservationModel.fromMap(reservationData);
      }
      return null;
    } catch (e) {
      print('Error obteniendo reservación por ID: $e');
      return null;
    }
  }
  
  /// Obtener reservaciones de un usuario específico
  Future<List<ReservationModel>> getReservationsByUser(String userId) async {
    try {
      final allReservations = await getAllReservations();
      return allReservations.where((reservation) => reservation.userId == userId).toList();
    } catch (e) {
      print('Error obteniendo reservaciones del usuario: $e');
      return [];
    }
  }
  
  /// Obtener reservaciones activas de un usuario
  Future<List<ReservationModel>> getActiveReservationsByUser(String userId) async {
    try {
      final userReservations = await getReservationsByUser(userId);
      return userReservations.where((reservation) => reservation.isActive).toList();
    } catch (e) {
      print('Error obteniendo reservaciones activas del usuario: $e');
      return [];
    }
  }
  
  /// Obtener reservaciones futuras de un usuario
  Future<List<ReservationModel>> getFutureReservationsByUser(String userId) async {
    try {
      final userReservations = await getReservationsByUser(userId);
      return userReservations.where((reservation) => 
        reservation.isActive && reservation.isFuture
      ).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      print('Error obteniendo reservaciones futuras del usuario: $e');
      return [];
    }
  }
  
  /// Obtener reservaciones pasadas de un usuario
  Future<List<ReservationModel>> getPastReservationsByUser(String userId) async {
    try {
      final userReservations = await getReservationsByUser(userId);
      return userReservations.where((reservation) => 
        reservation.isPast
      ).toList()..sort((a, b) => b.startTime.compareTo(a.startTime));
    } catch (e) {
      print('Error obteniendo reservaciones pasadas del usuario: $e');
      return [];
    }
  }
  
  /// Obtener reservaciones de hoy
  Future<List<ReservationModel>> getTodayReservations() async {
    try {
      final allReservations = await getAllReservations();
      return allReservations.where((reservation) => 
        reservation.isToday && reservation.isActive
      ).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      print('Error obteniendo reservaciones de hoy: $e');
      return [];
    }
  }
  
  /// Obtener reservaciones por fecha
  Future<List<ReservationModel>> getReservationsByDate(DateTime date) async {
    try {
      final allReservations = await getAllReservations();
      return allReservations.where((reservation) {
        return reservation.date.year == date.year &&
               reservation.date.month == date.month &&
               reservation.date.day == date.day &&
               reservation.isActive;
      }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      print('Error obteniendo reservaciones por fecha: $e');
      return [];
    }
  }
  
  /// Obtener reservaciones por zona
  Future<List<ReservationModel>> getReservationsByZone(WorkshopZone zone) async {
    try {
      final allReservations = await getAllReservations();
      return allReservations.where((reservation) => 
        reservation.zone == zone && reservation.isActive
      ).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      print('Error obteniendo reservaciones por zona: $e');
      return [];
    }
  }
  
  /// Verificar si un slot está disponible
  Future<bool> isSlotAvailable(WorkshopZone zone, DateTime date, TimeSlot timeSlot) async {
    try {
      final reservations = await getReservationsByDate(date);
      
      // Verificar si hay conflicto con reservaciones existentes
      return !reservations.any((reservation) =>
        reservation.zone == zone &&
        reservation.timeSlot == timeSlot &&
        reservation.isActive
      );
    } catch (e) {
      print('Error verificando disponibilidad del slot: $e');
      return false;
    }
  }
  
  /// Obtener slots disponibles para una fecha y zona específica
  Future<List<TimeSlot>> getAvailableSlots(WorkshopZone zone, DateTime date) async {
    try {
      final List<TimeSlot> availableSlots = [];
      
      for (TimeSlot slot in TimeSlot.values) {
        final isAvailable = await isSlotAvailable(zone, date, slot);
        if (isAvailable) {
          availableSlots.add(slot);
        }
      }
      
      return availableSlots;
    } catch (e) {
      print('Error obteniendo slots disponibles: $e');
      return [];
    }
  }
  
  /// Cancelar una reservación
  Future<bool> cancelReservation(String reservationId, String reason) async {
    try {
      final reservation = await getReservationById(reservationId);
      if (reservation == null || !reservation.canBeCanceled) {
        return false;
      }
      
      final canceledReservation = reservation.cancel(reason);
      await _storage.updateReservation(reservationId, canceledReservation.toMap());
      
      return true;
    } catch (e) {
      print('Error cancelando reservación: $e');
      return false;
    }
  }
  
  /// Completar una reservación
  Future<bool> completeReservation(String reservationId) async {
    try {
      final reservation = await getReservationById(reservationId);
      if (reservation == null || !reservation.isActive) {
        return false;
      }
      
      final completedReservation = reservation.complete();
      await _storage.updateReservation(reservationId, completedReservation.toMap());
      
      return true;
    } catch (e) {
      print('Error completando reservación: $e');
      return false;
    }
  }
  
  /// Marcar como no show
  Future<bool> markAsNoShow(String reservationId) async {
    try {
      final reservation = await getReservationById(reservationId);
      if (reservation == null) {
        return false;
      }
      
      final noShowReservation = reservation.markNoShow();
      await _storage.updateReservation(reservationId, noShowReservation.toMap());
      
      return true;
    } catch (e) {
      print('Error marcando como no show: $e');
      return false;
    }
  }
  
  /// Obtener próximas reservaciones (próximas 24 horas)
  Future<List<ReservationModel>> getUpcomingReservations({int hours = 24}) async {
    try {
      final allReservations = await getAllReservations();
      final now = DateTime.now();
      final limit = now.add(Duration(hours: hours));
      
      return allReservations.where((reservation) {
        return reservation.isActive &&
               reservation.startTime.isAfter(now) &&
               reservation.startTime.isBefore(limit);
      }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      print('Error obteniendo próximas reservaciones: $e');
      return [];
    }
  }
  
  /// Obtener estadísticas de reservaciones
  Future<Map<String, dynamic>> getReservationsStats() async {
    try {
      final allReservations = await getAllReservations();
      final today = DateTime.now();
      
      int totalReservations = allReservations.length;
      int activeReservations = 0;
      int completedReservations = 0;
      int canceledReservations = 0;
      int noShowReservations = 0;
      int todayReservations = 0;
      
      Map<String, int> zoneCount = {};
      Map<String, int> timeSlotCount = {};
      
      for (final reservation in allReservations) {
        // Contar por estado
        switch (reservation.status) {
          case ReservationStatus.activa:
            activeReservations++;
            break;
          case ReservationStatus.completada:
            completedReservations++;
            break;
          case ReservationStatus.cancelada:
            canceledReservations++;
            break;
          case ReservationStatus.noShow:
            noShowReservations++;
            break;
        }
        
        // Contar reservaciones de hoy
        if (reservation.isToday) {
          todayReservations++;
        }
        
        // Contar por zona
        final zoneName = reservation.zone.displayName;
        zoneCount[zoneName] = (zoneCount[zoneName] ?? 0) + 1;
        
        // Contar por slot de tiempo
        final slotName = reservation.timeSlot.displayName;
        timeSlotCount[slotName] = (timeSlotCount[slotName] ?? 0) + 1;
      }
      
      return {
        'totalReservations': totalReservations,
        'activeReservations': activeReservations,
        'completedReservations': completedReservations,
        'canceledReservations': canceledReservations,
        'noShowReservations': noShowReservations,
        'todayReservations': todayReservations,
        'zoneCount': zoneCount,
        'timeSlotCount': timeSlotCount,
        'upcomingCount': (await getUpcomingReservations()).length,
      };
    } catch (e) {
      print('Error obteniendo estadísticas de reservaciones: $e');
      return {};
    }
  }
  
  /// Validar datos de reservación
  Map<String, String> validateReservationData({
    required String userId,
    required WorkshopZone zone,
    required DateTime date,
    required TimeSlot timeSlot,
  }) {
    Map<String, String> errors = {};
    
    // Verificar que la fecha no sea pasada
    if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      errors['date'] = 'No se puede reservar en fechas pasadas';
    }
    
    // Verificar que no sea muy lejana
    final maxDate = DateTime.now().add(Duration(days: AppConstants.maxReservationDaysAhead));
    if (date.isAfter(maxDate)) {
      errors['date'] = 'No se puede reservar con más de ${AppConstants.maxReservationDaysAhead} días de anticipación';
    }
    
    // En el futuro se podrían agregar más validaciones específicas por zona
    
    return errors;
  }
  
  /// Buscar reservaciones con filtros múltiples
  Future<List<ReservationModel>> searchReservations({
    String? userName,
    WorkshopZone? zone,
    ReservationStatus? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      List<ReservationModel> results = await getAllReservations();
      
      // Filtrar por nombre de usuario
      if (userName != null && userName.isNotEmpty) {
        results = results.where((reservation) =>
          reservation.userName.toLowerCase().contains(userName.toLowerCase())
        ).toList();
      }
      
      // Filtrar por zona
      if (zone != null) {
        results = results.where((reservation) => reservation.zone == zone).toList();
      }
      
      // Filtrar por estado
      if (status != null) {
        results = results.where((reservation) => reservation.status == status).toList();
      }
      
      // Filtrar por rango de fechas
      if (fromDate != null) {
        results = results.where((reservation) => 
          reservation.date.isAfter(fromDate.subtract(const Duration(days: 1)))
        ).toList();
      }
      
      if (toDate != null) {
        results = results.where((reservation) => 
          reservation.date.isBefore(toDate.add(const Duration(days: 1)))
        ).toList();
      }
      
      // Ordenar por fecha de inicio (más recientes primero)
      results.sort((a, b) => b.startTime.compareTo(a.startTime));
      
      return results;
    } catch (e) {
      print('Error en búsqueda de reservaciones: $e');
      return [];
    }
  }
  
  /// Obtener ocupación por zona (porcentaje de slots ocupados)
  Future<Map<WorkshopZone, double>> getZoneOccupancy(DateTime date) async {
    try {
      Map<WorkshopZone, double> occupancy = {};
      
      for (WorkshopZone zone in WorkshopZone.values) {
        final reservations = await getReservationsByDate(date);
        final zoneReservations = reservations.where((r) => r.zone == zone).length;
        final totalSlots = TimeSlot.values.length;
        
        occupancy[zone] = totalSlots > 0 ? (zoneReservations / totalSlots) * 100 : 0.0;
      }
      
      return occupancy;
    } catch (e) {
      print('Error obteniendo ocupación por zona: $e');
      return {};
    }
  }
}