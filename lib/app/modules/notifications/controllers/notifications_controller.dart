import 'package:get/get.dart';
import '../../../data/providers/local_storage_provider.dart';
import '../../../data/models/notification_model.dart';
import '../../../core/utils/helpers.dart';

/// Controlador para el módulo de notificaciones
class NotificationsController extends GetxController {
  final LocalStorageProvider _storage;

  NotificationsController(this._storage);

  // Estado reactivo
  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  final RxSet<String> _readNotifications = <String>{}.obs;
  final RxBool _isLoading = false.obs;
  final RxString _selectedFilter = 'all'.obs;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  Set<String> get readNotifications => _readNotifications;
  bool get isLoading => _isLoading.value;
  String get selectedFilter => _selectedFilter.value;

  // Notificaciones filtradas
  List<NotificationModel> get filteredNotifications {
    var filtered =
        _notifications.where((notification) {
          switch (selectedFilter) {
            case 'unread':
              return !_readNotifications.contains(notification.id);
            case 'read':
              return _readNotifications.contains(notification.id);
            case 'high':
              return notification.priority == NotificationPriority.high;
            case 'medium':
              return notification.priority == NotificationPriority.medium;
            case 'low':
              return notification.priority == NotificationPriority.low;
            default:
              return true;
          }
        }).toList();

    // Ordenar por fecha (más recientes primero)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

  // Notificaciones no leídas
  List<NotificationModel> get unreadNotifications {
    return _notifications
        .where((notification) => !_readNotifications.contains(notification.id))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Contador de no leídas
  int get unreadCount => unreadNotifications.length;

  // ¿Hay notificaciones no leídas?
  bool get hasUnreadNotifications => unreadCount > 0;

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  /// Cargar notificaciones desde storage
  Future<void> _loadNotifications() async {
    _isLoading.value = true;

    try {
      final notificationsList = _storage.getNotifications();
      final readList = _storage.getReadNotifications();

      _notifications.assignAll(notificationsList);
      _readNotifications.assignAll(readList.toSet());
    } catch (e) {
      print('Error cargando notificaciones: $e');
      Helpers.showErrorSnackbar('Error cargando notificaciones');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Marcar notificación como leída
  Future<void> markAsRead(String notificationId) async {
    try {
      _readNotifications.add(notificationId);
      await _saveReadNotifications();
    } catch (e) {
      print('Error marcando notificación como leída: $e');
    }
  }

  /// Marcar todas las notificaciones como leídas
  Future<void> markAllAsRead() async {
    try {
      final allIds = _notifications.map((n) => n.id).toSet();
      _readNotifications.assignAll(allIds);
      await _saveReadNotifications();

      Helpers.showSuccessSnackbar(
        'Todas las notificaciones marcadas como leídas',
      );
    } catch (e) {
      print('Error marcando todas como leídas: $e');
      Helpers.showErrorSnackbar('Error al marcar notificaciones');
    }
  }

  /// Marcar notificación como no leída
  Future<void> markAsUnread(String notificationId) async {
    try {
      _readNotifications.remove(notificationId);
      await _saveReadNotifications();
    } catch (e) {
      print('Error marcando notificación como no leída: $e');
    }
  }

  /// Eliminar notificación
  Future<void> deleteNotification(String notificationId) async {
    try {
      _notifications.removeWhere((n) => n.id == notificationId);
      _readNotifications.remove(notificationId);

      await _saveNotifications();
      await _saveReadNotifications();

      Helpers.showSuccessSnackbar('Notificación eliminada');
    } catch (e) {
      print('Error eliminando notificación: $e');
      Helpers.showErrorSnackbar('Error al eliminar notificación');
    }
  }

  /// Crear nueva notificación
  Future<void> createNotification(NotificationModel notification) async {
    try {
      _notifications.insert(0, notification);
      await _saveNotifications();
    } catch (e) {
      print('Error creando notificación: $e');
    }
  }

  /// Aplicar filtro
  void applyFilter(String filter) {
    _selectedFilter.value = filter;
  }

  /// Limpiar filtros
  void clearFilters() {
    _selectedFilter.value = 'all';
  }

  /// Obtener notificación por ID
  NotificationModel? getNotificationById(String id) {
    try {
      return _notifications.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Verificar si una notificación fue leída
  bool isNotificationRead(String id) {
    return _readNotifications.contains(id);
  }

  /// Refrescar notificaciones
  Future<void> refresh() async {
    await _loadNotifications();
  }

  /// Guardar notificaciones en storage
  Future<void> _saveNotifications() async {
    try {
      final notificationsData = _notifications.map((n) => n.toMap()).toList();
      await _storage.saveNotifications(notificationsData);
    } catch (e) {
      print('Error guardando notificaciones: $e');
    }
  }

  /// Guardar notificaciones leídas en storage
  Future<void> _saveReadNotifications() async {
    try {
      await _storage.saveReadNotifications(_readNotifications.toList());
    } catch (e) {
      print('Error guardando notificaciones leídas: $e');
    }
  }

  /// Limpiar todas las notificaciones
  Future<void> clearAllNotifications() async {
    try {
      _notifications.clear();
      _readNotifications.clear();

      await _saveNotifications();
      await _saveReadNotifications();

      Helpers.showSuccessSnackbar('Todas las notificaciones eliminadas');
    } catch (e) {
      print('Error limpiando notificaciones: $e');
      Helpers.showErrorSnackbar('Error al limpiar notificaciones');
    }
  }

  /// Crear notificaciones de prueba (solo para desarrollo)
  Future<void> createTestNotifications() async {
    final testNotifications = [
      NotificationModel.create(
        title: 'Bienvenido a TallerURL',
        message:
            'Gracias por usar nuestro sistema de gestión de talleres. Explora todas las funcionalidades disponibles.',
        type: NotificationType.general,
        priority: NotificationPriority.medium,
      ),

      NotificationModel.scheduleChange(
        title: 'Cambio de Horario',
        message:
            'El taller de carpintería tendrá horario extendido los viernes hasta las 8:00 PM durante este mes.',
      ),

      NotificationModel.reservationReminder(
        title: 'Recordatorio de Reservación',
        message:
            'Tienes una reservación mañana a las 2:00 PM en el área de impresión 3D.',
        reservationId: 'test-reservation-123',
      ),

      NotificationModel.systemUpdate(
        message:
            'Nueva funcionalidad disponible: Ahora puedes ver el historial completo de tus reservaciones.',
      ),

      NotificationModel.create(
        title: 'Mantenimiento Programado',
        message:
            'El sistema estará en mantenimiento el próximo domingo de 2:00 AM a 6:00 AM. Durante este tiempo no estará disponible.',
        type: NotificationType.maintenance,
        priority: NotificationPriority.high,
      ),
    ];

    for (final notification in testNotifications) {
      await createNotification(notification);
    }

    Helpers.showSuccessSnackbar('Notificaciones de prueba creadas');
  }

  /// Obtener estadísticas de notificaciones
  Map<String, int> get notificationStats {
    return {
      'total': _notifications.length,
      'unread': unreadCount,
      'read': _readNotifications.length,
      'high_priority':
          _notifications
              .where((n) => n.priority == NotificationPriority.high)
              .length,
      'medium_priority':
          _notifications
              .where((n) => n.priority == NotificationPriority.medium)
              .length,
      'low_priority':
          _notifications
              .where((n) => n.priority == NotificationPriority.low)
              .length,
    };
  }
}
