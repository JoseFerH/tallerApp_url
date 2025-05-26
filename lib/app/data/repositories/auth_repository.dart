import '../models/user_model.dart';
import '../providers/local_storage_provider.dart';

/// Repositorio para manejar la autenticación de usuarios
class AuthRepository {
  final LocalStorageProvider _storage = LocalStorageProvider();
  
  /// Iniciar sesión con nombre completo y carné
  Future<UserModel?> login(String fullName, String password) async {
    try {
      // Obtener lista de usuarios del almacenamiento
      final usersData = _storage.getUsers();
      
      // Buscar usuario por nombre completo y verificar contraseña
      for (final userData in usersData) {
        final user = UserModel.fromMap(userData);
        
        // Verificar si el nombre coincide (case insensitive) y la contraseña es correcta
        if (user.fullName.toLowerCase() == fullName.toLowerCase() && 
            user.verifyPassword(password) && 
            user.isActive) {
          
          // Actualizar último login
          final updatedUser = user.updateLastLogin();
          await _updateUserInStorage(updatedUser);
          
          // Guardar como usuario actual
          await _storage.saveCurrentUser(updatedUser.toMap());
          
          return updatedUser;
        }
      }
      
      return null; // Usuario no encontrado o credenciales incorrectas
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }
  
  /// Cerrar sesión
  Future<void> logout() async {
    try {
      await _storage.logout();
    } catch (e) {
      print('Error en logout: $e');
    }
  }
  
  /// Obtener usuario actual logueado
  UserModel? getCurrentUser() {
    try {
      final userData = _storage.getCurrentUser();
      if (userData != null) {
        return UserModel.fromMap(userData);
      }
      return null;
    } catch (e) {
      print('Error obteniendo usuario actual: $e');
      return null;
    }
  }
  
  /// Verificar si hay un usuario logueado
  bool isLoggedIn() {
    return _storage.isLoggedIn();
  }
  
  /// Verificar si el usuario actual es administrador
  bool isCurrentUserAdmin() {
    final currentUser = getCurrentUser();
    return currentUser?.isAdmin ?? false;
  }
  
  /// Verificar si el usuario actual es staff (docente, auxiliar o admin)
  bool isCurrentUserStaff() {
    final currentUser = getCurrentUser();
    return currentUser?.isStaff ?? false;
  }
  
  /// Obtener rol del usuario actual
  String getCurrentUserRole() {
    final currentUser = getCurrentUser();
    return currentUser?.roleDescription ?? 'Sin rol';
  }
  
  /// Verificar si el usuario ha completado la inducción
  bool hasCurrentUserCompletedInduction() {
    final currentUser = getCurrentUser();
    if (currentUser == null) return false;
    
    return _storage.hasCompletedInduction(currentUser.id);
  }
  
  /// Marcar inducción como completada para el usuario actual
  Future<void> markInductionCompleted() async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        await _storage.markInductionCompleted(currentUser.id);
        
        // Actualizar también en el modelo del usuario
        final updatedUser = currentUser.markInductionCompleted();
        await _updateUserInStorage(updatedUser);
        await _storage.saveCurrentUser(updatedUser.toMap());
      }
    } catch (e) {
      print('Error marcando inducción completada: $e');
    }
  }
  
  /// Cambiar contraseña del usuario actual
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) return false;
      
      // Verificar contraseña actual
      if (!currentUser.verifyPassword(currentPassword)) {
        return false;
      }
      
      // Crear nuevo hash de contraseña
      final updatedUser = currentUser.copyWith(
        password: UserModel.create(
          id: currentUser.id,
          fullName: currentUser.fullName,
          role: currentUser.role,
          plainPassword: newPassword,
        ).password,
      );
      
      // Actualizar en almacenamiento
      await _updateUserInStorage(updatedUser);
      await _storage.saveCurrentUser(updatedUser.toMap());
      
      return true;
    } catch (e) {
      print('Error cambiando contraseña: $e');
      return false;
    }
  }
  
  /// Validar formato de carné universitario
  bool isValidCarne(String carne) {
    // El carné debe tener 7 dígitos
    if (carne.length != 7) return false;
    
    // Debe ser solo números
    if (!RegExp(r'^\d{7}$').hasMatch(carne)) return false;
    
    return true;
  }
  
  /// Validar nombre completo
  bool isValidFullName(String fullName) {
    // Debe tener al menos 3 caracteres
    if (fullName.trim().length < 3) return false;
    
    // Debe contener al menos un espacio (nombre y apellido)
    if (!fullName.trim().contains(' ')) return false;
    
    // Solo letras y espacios
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(fullName.trim())) return false;
    
    return true;
  }
  
  /// Obtener tiempo desde el último login
  Duration? getTimeSinceLastLogin() {
    final lastLogin = _storage.getLastLoginTime();
    if (lastLogin == null) return null;
    
    return DateTime.now().difference(lastLogin);
  }
  
  /// Verificar si la sesión ha expirado
  bool isSessionExpired() {
    final timeSinceLogin = getTimeSinceLastLogin();
    if (timeSinceLogin == null) return true;
    
    // Sesión expira después de 8 horas de inactividad
    return timeSinceLogin.inHours > 8;
  }
  
  /// Renovar sesión
  Future<void> renewSession() async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        final updatedUser = currentUser.updateLastLogin();
        await _updateUserInStorage(updatedUser);
        await _storage.saveCurrentUser(updatedUser.toMap());
      }
    } catch (e) {
      print('Error renovando sesión: $e');
    }
  }
  
  /// Verificar credenciales sin iniciar sesión
  Future<bool> verifyCredentials(String fullName, String password) async {
    try {
      final usersData = _storage.getUsers();
      
      for (final userData in usersData) {
        final user = UserModel.fromMap(userData);
        
        if (user.fullName.toLowerCase() == fullName.toLowerCase() && 
            user.verifyPassword(password) && 
            user.isActive) {
          return true;
        }
      }
      
      return false;
    } catch (e) {
      print('Error verificando credenciales: $e');
      return false;
    }
  }
  
  /// Verificar si un usuario existe por nombre completo
  Future<bool> userExistsByName(String fullName) async {
    try {
      final usersData = _storage.getUsers();
      
      return usersData.any((userData) {
        final user = UserModel.fromMap(userData);
        return user.fullName.toLowerCase() == fullName.toLowerCase();
      });
    } catch (e) {
      print('Error verificando existencia de usuario: $e');
      return false;
    }
  }
  
  /// Método privado para actualizar usuario en el almacenamiento
  Future<void> _updateUserInStorage(UserModel user) async {
    try {
      await _storage.updateUser(user.id, user.toMap());
    } catch (e) {
      print('Error actualizando usuario en almacenamiento: $e');
    }
  }
  
  /// Obtener estadísticas de autenticación (para admin)
  Map<String, dynamic> getAuthStats() {
    try {
      final usersData = _storage.getUsers();
      final currentUser = getCurrentUser();
      
      int totalUsers = usersData.length;
      int activeUsers = 0;
      int studentsCount = 0;
      int staffCount = 0;
      
      for (final userData in usersData) {
        final user = UserModel.fromMap(userData);
        if (user.isActive) activeUsers++;
        if (user.isStudent) studentsCount++;
        if (user.isStaff) staffCount++;
      }
      
      return {
        'totalUsers': totalUsers,
        'activeUsers': activeUsers,
        'studentsCount': studentsCount,
        'staffCount': staffCount,
        'currentUser': currentUser?.fullName ?? 'Sin usuario',
        'lastLogin': _storage.getLastLoginTime()?.toIso8601String(),
        'sessionExpired': isSessionExpired(),
      };
    } catch (e) {
      print('Error obteniendo estadísticas de auth: $e');
      return {};
    }
  }
}