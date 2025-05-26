import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../data/repositories/reservation_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/reservation_model.dart';
import '../../../data/models/user_model.dart';
import '../../../core/utils/constants.dart';
import '../../../routes/app_routes.dart';

/// Controlador para el módulo de reservaciones
class ReservationController extends GetxController {
  final ReservationRepository reservationRepository;
  final AuthRepository authRepository;
  
  ReservationController({
    required this.reservationRepository,
    required this.authRepository,
  });
  
  // Controladores de formulario
  final TextEditingController purposeController = TextEditingController();
  final GlobalKey<FormState> reservationFormKey = GlobalKey<FormState>();
  
  // Estados reactivos
  final RxBool isLoading = false.obs;
  final RxBool isCreatingReservation = false.obs;
  
  // Calendario
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> focusedDate = DateTime.now().obs;
  final RxList<ReservationModel> calendarReservations = <ReservationModel>[].obs;
  
  // Formulario de reservación
  final Rx<WorkshopZone?> selectedZone = Rx<WorkshopZone?>(null);
  final Rx<TimeSlot?> selectedTimeSlot = Rx<TimeSlot?>(null);
  final RxList<TimeSlot> availableSlots = <TimeSlot>[].obs;
  
  // Reservaciones del usuario
  final RxList<ReservationModel> userReservations = <ReservationModel>[].obs;
  final RxList<ReservationModel> upcomingReservations = <ReservationModel>[].obs;
  final RxList<ReservationModel> pastReservations = <ReservationModel>[].obs;
  
  // Usuario actual
  UserModel? currentUser;
  
  @override
  void onInit() {
    super.onInit();
    _initializeReservations();
  }
  
  @override
  void onClose() {
    purposeController.dispose();
    super.onClose();
  }
  
  /// Inicializar reservaciones
  void _initializeReservations() {
    currentUser = authRepository.getCurrentUser();
    if (currentUser == null) {
      Get.offAllNamed(AppRoutes.LOGIN);
      return;
    }
    
    // Cargar reservaciones iniciales
    loadUserReservations();
    loadCalendarReservations();
    
    // Configurar fecha inicial
    _updateSelectedDate(DateTime.now());
  }
  
  /// Cargar reservaciones del usuario
  Future<void> loadUserReservations() async {
    try {
      if (currentUser == null) return;
      
      isLoading.value = true;
      
      final reservations = await reservationRepository.getReservationsByUser(
        currentUser!.id
      );
      
      userReservations.value = reservations;
      
      // Separar en próximas y pasadas
      final upcoming = await reservationRepository.getFutureReservationsByUser(
        currentUser!.id
      );
      upcomingReservations.value = upcoming;
      
      final past = await reservationRepository.getPastReservationsByUser(
        currentUser!.id
      );
      pastReservations.value = past;
      
    } catch (e) {
      print('Error cargando reservaciones del usuario: $e');
      Get.snackbar(
        'Error',
        'No se pudieron cargar las reservaciones',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Cargar reservaciones del calendario
  Future<void> loadCalendarReservations() async {
    try {
      final reservations = await reservationRepository.getReservationsByDate(
        selectedDate.value
      );
      calendarReservations.value = reservations;
    } catch (e) {
      print('Error cargando reservaciones del calendario: $e');
    }
  }
  
  /// Actualizar fecha seleccionada
  void _updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    loadCalendarReservations();
    _updateAvailableSlots();
  }
  
  /// Seleccionar fecha en el calendario
  void onDateSelected(DateTime selectedDay, DateTime focusedDay) {
    // No permitir fechas pasadas
    if (selectedDay.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      Get.snackbar(
        'Fecha no válida',
        'No puedes seleccionar fechas pasadas',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // No permitir fechas muy lejanas
    final maxDate = DateTime.now().add(Duration(days: AppConstants.maxReservationDaysAhead));
    if (selectedDay.isAfter(maxDate)) {
      Get.snackbar(
        'Fecha no válida',
        'Solo puedes reservar hasta ${AppConstants.maxReservationDaysAhead} días por adelantado',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    _updateSelectedDate(selectedDay);
    focusedDate.value = focusedDay;
  }
  
  /// Seleccionar zona del taller
  void selectZone(WorkshopZone zone) {
    selectedZone.value = zone;
    selectedTimeSlot.value = null; // Reset time slot
    _updateAvailableSlots();
  }
  
  /// Seleccionar slot de tiempo
  void selectTimeSlot(TimeSlot slot) {
    selectedTimeSlot.value = slot;
  }
  
  /// Actualizar slots disponibles
  Future<void> _updateAvailableSlots() async {
    if (selectedZone.value == null) {
      availableSlots.clear();
      return;
    }
    
    try {
      final slots = await reservationRepository.getAvailableSlots(
        selectedZone.value!,
        selectedDate.value
      );
      availableSlots.value = slots;
    } catch (e) {
      print('Error actualizando slots disponibles: $e');
      availableSlots.clear();
    }
  }
  
  /// Crear nueva reservación
  Future<void> createReservation() async {
    if (!reservationFormKey.currentState!.validate()) return;
    if (selectedZone.value == null || selectedTimeSlot.value == null) {
      Get.snackbar(
        'Datos incompletos',
        'Selecciona zona y horario',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      isCreatingReservation.value = true;
      
      final reservation = await reservationRepository.createReservation(
        userId: currentUser!.id,
        userName: currentUser!.fullName,
        zone: selectedZone.value!,
        date: selectedDate.value,
        timeSlot: selectedTimeSlot.value!,
        purpose: purposeController.text.trim().isEmpty 
            ? null 
            : purposeController.text.trim(),
      );
      
      if (reservation != null) {
        // Éxito
        Get.snackbar(
          'Reservación Creada',
          'Tu reservación ha sido confirmada',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
        
        // Limpiar formulario
        _clearForm();
        
        // Recargar datos
        await loadUserReservations();
        await loadCalendarReservations();
        
        // Navegar a mis reservaciones
        Get.toNamed(AppRoutes.MY_RESERVATIONS);
        
      } else {
        Get.snackbar(
          'Error',
          'No se pudo crear la reservación. El horario podría estar ocupado.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
      
    } catch (e) {
      print('Error creando reservación: $e');
      Get.snackbar(
        'Error',
        'Ocurrió un error inesperado',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCreatingReservation.value = false;
    }
  }
  
  /// Cancelar reservación
  Future<void> cancelReservation(ReservationModel reservation) async {
    // Mostrar diálogo de confirmación
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Cancelar Reservación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Estás seguro de cancelar la reservación de ${reservation.zone.displayName}?'),
            const SizedBox(height: 8),
            Text(
              reservation.formattedDateTime,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sí, Cancelar'),
          ),
        ],
      ),
    );
    
    if (confirmed != true) return;
    
    try {
      final success = await reservationRepository.cancelReservation(
        reservation.id,
        'Cancelada por el usuario'
      );
      
      if (success) {
        Get.snackbar(
          'Reservación Cancelada',
          'La reservación ha sido cancelada exitosamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
        );
        
        // Recargar datos
        await loadUserReservations();
        await loadCalendarReservations();
      } else {
        Get.snackbar(
          'Error',
          'No se pudo cancelar la reservación',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error cancelando reservación: $e');
      Get.snackbar(
        'Error',
        'Ocurrió un error inesperado',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// Limpiar formulario
  void _clearForm() {
    selectedZone.value = null;
    selectedTimeSlot.value = null;
    purposeController.clear();
    availableSlots.clear();
  }
  
  /// Refrescar todas las reservaciones
  Future<void> refreshReservations() async {
    await Future.wait([
      loadUserReservations(),
      loadCalendarReservations(),
    ]);
  }
  
  /// Obtener reservaciones para una fecha específica del calendario
  List<ReservationModel> getReservationsForDay(DateTime day) {
    return calendarReservations.where((reservation) {
      return reservation.date.year == day.year &&
             reservation.date.month == day.month &&
             reservation.date.day == day.day;
    }).toList();
  }
  
  /// Verificar si una fecha tiene reservaciones
  bool hasReservationsForDay(DateTime day) {
    return getReservationsForDay(day).isNotEmpty;
  }
  
  /// Obtener color para una fecha en el calendario
  Color getColorForDay(DateTime day) {
    final reservations = getReservationsForDay(day);
    if (reservations.isEmpty) return Colors.transparent;
    
    // Si hay reservaciones del usuario actual, color azul
    if (reservations.any((r) => r.userId == currentUser?.id)) {
      return Colors.blue;
    }
    
    // Si hay otras reservaciones, color gris
    return Colors.grey;
  }
  
  /// Obtener color de la zona
  Color getZoneColor(WorkshopZone zone) {
    switch (zone) {
      case WorkshopZone.corteLaser:
        return Colors.red;
      case WorkshopZone.impresion3d:
        return Colors.blue;
      case WorkshopZone.carpinteria:
        return Colors.brown;
      case WorkshopZone.metalurgia:
        return Colors.grey;
      case WorkshopZone.pintura:
        return Colors.purple;
      case WorkshopZone.areaGeneral:
        return Colors.green;
    }
  }
  
  /// Obtener ícono de la zona
  IconData getZoneIcon(WorkshopZone zone) {
    switch (zone) {
      case WorkshopZone.corteLaser:
        return Icons.content_cut;
      case WorkshopZone.impresion3d:
        return Icons.print;
      case WorkshopZone.carpinteria:
        return Icons.carpenter;
      case WorkshopZone.metalurgia:
        return Icons.construction;
      case WorkshopZone.pintura:
        return Icons.brush;
      case WorkshopZone.areaGeneral:
        return Icons.workspaces;
    }
  }
  
  /// Navegar al formulario de reservación
  void navigateToReservationForm() {
    Get.toNamed(AppRoutes.RESERVATION_FORM);
  }
  
  /// Navegar a mis reservaciones
  void navigateToMyReservations() {
    Get.toNamed(AppRoutes.MY_RESERVATIONS);
  }
  
  /// Obtener estadísticas del usuario
  Map<String, int> getUserStats() {
    return {
      'total': userReservations.length,
      'upcoming': upcomingReservations.length,
      'past': pastReservations.length,
      'active': userReservations.where((r) => r.isActive).length,
    };
  }
  
  /// Validar propósito (opcional)
  String? validatePurpose(String? value) {
    // El propósito es opcional, no se requiere validación
    return null;
  }
}