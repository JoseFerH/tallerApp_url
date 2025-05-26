import 'package:get_storage/get_storage.dart';

/// Proveedor de almacenamiento local usando GetStorage
class LocalStorageProvider {
  static const String _boxName = 'taller_url_box';
  late final GetStorage _box;
  
  /// Singleton
  static final LocalStorageProvider _instance = LocalStorageProvider._internal();
  factory LocalStorageProvider() => _instance;
  LocalStorageProvider._internal();
  
  /// Inicializar el almacenamiento
  Future<void> init() async {
    await GetStorage.init(_boxName);
    _box = GetStorage(_boxName);
  }
  
  /// Obtener instancia del box
  GetStorage get box => _box;
  
  // ========== CLAVES DE ALMACENAMIENTO ==========
  
  // Autenticación
  static const String _keyCurrentUser = 'current_user';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyLastLoginTime = 'last_login_time';
  
  // Usuarios
  static const String _keyUsers = 'users_list';
  
  // Herramientas
  static const String _keyTools = 'tools_list';
  
  // Reservaciones
  static const String _keyReservations = 'reservations_list';
  
  // Notificaciones
  static const String _keyNotifications = 'notifications_list';
  
  // Configuraciones de la app
  static const String _keyAppSettings = 'app_settings';
  static const String _keyFirstTime = 'is_first_time';
  static const String _keyInductionCompleted = 'induction_completed';
  
  // Videos vistos
  static const String _keyWatchedVideos = 'watched_videos';
  
  // ========== MÉTODOS DE AUTENTICACIÓN ==========
  
  /// Guardar usuario actual
  Future<void> saveCurrentUser(Map<String, dynamic> user) async {
    await _box.write(_keyCurrentUser, user);
    await _box.write(_keyIsLoggedIn, true);
    await _box.write(_keyLastLoginTime, DateTime.now().toIso8601String());
  }
  
  /// Obtener usuario actual
  Map<String, dynamic>? getCurrentUser() {
    return _box.read(_keyCurrentUser);
  }
  
  /// Verificar si hay usuario logueado
  bool isLoggedIn() {
    return _box.read(_keyIsLoggedIn) ?? false;
  }
  
  /// Cerrar sesión
  Future<void> logout() async {
    await _box.remove(_keyCurrentUser);
    await _box.write(_keyIsLoggedIn, false);
  }
  
  /// Obtener tiempo del último login
  DateTime? getLastLoginTime() {
    final timeString = _box.read(_keyLastLoginTime);
    return timeString != null ? DateTime.parse(timeString) : null;
  }
  
  // ========== MÉTODOS DE USUARIOS ==========
  
  /// Guardar lista de usuarios
  Future<void> saveUsers(List<Map<String, dynamic>> users) async {
    await _box.write(_keyUsers, users);
  }
  
  /// Obtener lista de usuarios
  List<Map<String, dynamic>> getUsers() {
    final List<dynamic>? usersData = _box.read(_keyUsers);
    if (usersData == null) return [];
    return usersData.cast<Map<String, dynamic>>();
  }
  
  /// Agregar un usuario
  Future<void> addUser(Map<String, dynamic> user) async {
    final users = getUsers();
    users.add(user);
    await saveUsers(users);
  }
  
  /// Actualizar un usuario
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    final users = getUsers();
    final index = users.indexWhere((user) => user['id'] == userId);
    if (index != -1) {
      users[index] = userData;
      await saveUsers(users);
    }
  }
  
  /// Eliminar un usuario
  Future<void> deleteUser(String userId) async {
    final users = getUsers();
    users.removeWhere((user) => user['id'] == userId);
    await saveUsers(users);
  }
  
  // ========== MÉTODOS DE HERRAMIENTAS ==========
  
  /// Guardar lista de herramientas
  Future<void> saveTools(List<Map<String, dynamic>> tools) async {
    await _box.write(_keyTools, tools);
  }
  
  /// Obtener lista de herramientas
  List<Map<String, dynamic>> getTools() {
    final List<dynamic>? toolsData = _box.read(_keyTools);
    if (toolsData == null) return [];
    return toolsData.cast<Map<String, dynamic>>();
  }
  
  /// Actualizar una herramienta
  Future<void> updateTool(String toolId, Map<String, dynamic> toolData) async {
    final tools = getTools();
    final index = tools.indexWhere((tool) => tool['id'] == toolId);
    if (index != -1) {
      tools[index] = toolData;
      await saveTools(tools);
    }
  }
  
  // ========== MÉTODOS DE RESERVACIONES ==========
  
  /// Guardar lista de reservaciones
  Future<void> saveReservations(List<Map<String, dynamic>> reservations) async {
    await _box.write(_keyReservations, reservations);
  }
  
  /// Obtener lista de reservaciones
  List<Map<String, dynamic>> getReservations() {
    final List<dynamic>? reservationsData = _box.read(_keyReservations);
    if (reservationsData == null) return [];
    return reservationsData.cast<Map<String, dynamic>>();
  }
  
  /// Agregar una reservación
  Future<void> addReservation(Map<String, dynamic> reservation) async {
    final reservations = getReservations();
    reservations.add(reservation);
    await saveReservations(reservations);
  }
  
  /// Actualizar una reservación
  Future<void> updateReservation(String reservationId, Map<String, dynamic> reservationData) async {
    final reservations = getReservations();
    final index = reservations.indexWhere((res) => res['id'] == reservationId);
    if (index != -1) {
      reservations[index] = reservationData;
      await saveReservations(reservations);
    }
  }
  
  /// Eliminar una reservación
  Future<void> deleteReservation(String reservationId) async {
    final reservations = getReservations();
    reservations.removeWhere((res) => res['id'] == reservationId);
    await saveReservations(reservations);
  }
  
  // ========== MÉTODOS DE NOTIFICACIONES ==========
  
  /// Guardar lista de notificaciones
  Future<void> saveNotifications(List<Map<String, dynamic>> notifications) async {
    await _box.write(_keyNotifications, notifications);
  }
  
  /// Obtener lista de notificaciones
  List<Map<String, dynamic>> getNotifications() {
    final List<dynamic>? notificationsData = _box.read(_keyNotifications);
    if (notificationsData == null) return [];
    return notificationsData.cast<Map<String, dynamic>>();
  }
  
  /// Agregar una notificación
  Future<void> addNotification(Map<String, dynamic> notification) async {
    final notifications = getNotifications();
    notifications.insert(0, notification); // Insertar al inicio (más reciente primero)
    await saveNotifications(notifications);
  }
  
  /// Marcar notificación como leída
  Future<void> markNotificationAsRead(String notificationId) async {
    final notifications = getNotifications();
    final index = notifications.indexWhere((notif) => notif['id'] == notificationId);
    if (index != -1) {
      notifications[index]['isRead'] = true;
      await saveNotifications(notifications);
    }
  }
  
  /// Marcar todas las notificaciones como leídas
  Future<void> markAllNotificationsAsRead() async {
    final notifications = getNotifications();
    for (var notification in notifications) {
      notification['isRead'] = true;
    }
    await saveNotifications(notifications);
  }
  
  // ========== MÉTODOS DE CONFIGURACIÓN ==========
  
  /// Verificar si es la primera vez que se abre la app
  bool isFirstTime() {
    return _box.read(_keyFirstTime) ?? true;
  }
  
  /// Marcar que ya no es la primera vez
  Future<void> setNotFirstTime() async {
    await _box.write(_keyFirstTime, false);
  }
  
  /// Verificar si completó la inducción
  bool hasCompletedInduction(String userId) {
    final Map<String, dynamic>? inductionData = _box.read(_keyInductionCompleted);
    if (inductionData == null) return false;
    return inductionData[userId] ?? false;
  }
  
  /// Marcar inducción como completada
  Future<void> markInductionCompleted(String userId) async {
    final Map<String, dynamic> inductionData = _box.read(_keyInductionCompleted) ?? {};
    inductionData[userId] = true;
    await _box.write(_keyInductionCompleted, inductionData);
  }
  
  /// Obtener videos vistos por usuario
  List<String> getWatchedVideos(String userId) {
    final Map<String, dynamic>? watchedData = _box.read(_keyWatchedVideos);
    if (watchedData == null) return [];
    final List<dynamic>? userVideos = watchedData[userId];
    return userVideos?.cast<String>() ?? [];
  }
  
  /// Marcar video como visto
  Future<void> markVideoAsWatched(String userId, String videoId) async {
    final Map<String, dynamic> watchedData = _box.read(_keyWatchedVideos) ?? {};
    final List<String> userVideos = watchedData[userId]?.cast<String>() ?? [];
    
    if (!userVideos.contains(videoId)) {
      userVideos.add(videoId);
      watchedData[userId] = userVideos;
      await _box.write(_keyWatchedVideos, watchedData);
    }
  }
  
  /// Guardar configuraciones de la app
  Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    await _box.write(_keyAppSettings, settings);
  }
  
  /// Obtener configuraciones de la app
  Map<String, dynamic> getAppSettings() {
    return _box.read(_keyAppSettings) ?? {};
  }
  
  // ========== MÉTODOS DE UTILIDAD ==========
  
  /// Limpiar todos los datos (para reset de la app)
  Future<void> clearAll() async {
    await _box.erase();
  }
  
  /// Obtener tamaño de los datos almacenados
  int getStorageSize() {
    return _box.getKeys().length;
  }
  
  /// Exportar todos los datos (para backup)
  Map<String, dynamic> exportAllData() {
    final keys = _box.getKeys();
    final Map<String, dynamic> allData = {};
    
    for (String key in keys) {
      allData[key] = _box.read(key);
    }
    
    return allData;
  }
  
  /// Importar datos (para restore)
  Future<void> importAllData(Map<String, dynamic> data) async {
    for (String key in data.keys) {
      await _box.write(key, data[key]);
    }
  }
  
  /// Verificar si existe una clave
  bool hasKey(String key) {
    return _box.hasData(key);
  }
  
  /// Eliminar una clave específica
  Future<void> removeKey(String key) async {
    await _box.remove(key);
  }
}