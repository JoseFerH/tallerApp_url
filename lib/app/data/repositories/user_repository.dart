import '../models/user_model.dart';
import '../providers/local_storage_provider.dart';
import '../../core/utils/constants.dart';

/// Repositorio para manejar la gestión de usuarios (principalmente para admin)
class UserRepository {
  final LocalStorageProvider _storage = LocalStorageProvider();
  
  /// Obtener todos los usuarios
  Future<List<UserModel>> getAllUsers() async {
    try {
      final usersData = _storage.getUsers();
      return usersData.map((data) => UserModel.fromMap(data)).toList();
    } catch (e) {
      print('Error obteniendo todos los usuarios: $e');
      return [];
    }
  }
  
  /// Obtener usuario por ID
  Future<UserModel?> getUserById(String id) async {
    try {
      final usersData = _storage.getUsers();
      final userData = usersData.firstWhere(
        (data) => data['id'] == id,
        orElse: () => {},
      );
      
      if (userData.isNotEmpty) {
        return UserModel.fromMap(userData);
      }
      return null;
    } catch (e) {
      print('Error obteniendo usuario por ID: $e');
      return null;
    }
  }
  
  /// Crear un nuevo usuario
  Future<UserModel?> createUser({
    required String id,
    required String fullName,
    required UserRole role,
    required String plainPassword,
    String? email,
    String? phone,
  }) async {
    try {
      // Verificar que el ID no exista
      final existingUser = await getUserById(id);
      if (existingUser != null) {
        return null; // Usuario ya existe
      }
      
      // Verificar que el nombre no esté duplicado
      final existingByName = await getUserByFullName(fullName);
      if (existingByName != null) {
        return null; // Nombre ya existe
      }
      
      // Crear el usuario
      final user = UserModel.create(
        id: id,
        fullName: fullName,
        role: role,
        plainPassword: plainPassword,
        email: email,
        phone: phone,
      );
      
      // Guardar en el almacenamiento
      await _storage.addUser(user.toMap());
      
      return user;
    } catch (e) {
      print('Error creando usuario: $e');
      return null;
    }
  }
  
  /// Actualizar un usuario existente
  Future<bool> updateUser(String userId, {
    String? fullName,
    UserRole? role,
    String? plainPassword,
    bool? isActive,
    String? email,
    String? phone,
  }) async {
    try {
      final user = await getUserById(userId);
      if (user == null) return false;
      
      // Si se está cambiando el nombre, verificar que no esté duplicado
      if (fullName != null && fullName != user.fullName) {
        final existingByName = await getUserByFullName(fullName);
        if (existingByName != null && existingByName.id != userId) {
          return false; // Nombre ya existe en otro usuario
        }
      }
      
      // Crear usuario actualizado
      UserModel updatedUser = user.copyWith(
        fullName: fullName,
        role: role,
        isActive: isActive,
        email: email,
        phone: phone,
      );
      
      // Si se proporciona nueva contraseña, actualizarla
      if (plainPassword != null && plainPassword.isNotEmpty) {
        final newUser = UserModel.create(
          id: user.id,
          fullName: updatedUser.fullName,
          role: updatedUser.role,
          plainPassword: plainPassword,
          email: updatedUser.email,
          phone: updatedUser.phone,
        );
        updatedUser = updatedUser.copyWith(password: newUser.password);
      }
      
      // Guardar en el almacenamiento
      await _storage.updateUser(userId, updatedUser.toMap());
      
      return true;
    } catch (e) {
      print('Error actualizando usuario: $e');
      return false;
    }
  }
  
  /// Eliminar un usuario
  Future<bool> deleteUser(String userId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) return false;
      
      // No permitir eliminar el último administrador
      if (user.isAdmin) {
        final admins = await getUsersByRole(UserRole.admin);
        if (admins.length <= 1) {
          return false; // Es el último admin
        }
      }
      
      await _storage.deleteUser(userId);
      return true;
    } catch (e) {
      print('Error eliminando usuario: $e');
      return false;
    }
  }
  
  /// Obtener usuario por nombre completo
  Future<UserModel?> getUserByFullName(String fullName) async {
    try {
      final allUsers = await getAllUsers();
      return allUsers.firstWhere(
        (user) => user.fullName.toLowerCase() == fullName.toLowerCase(),
        orElse: () => throw Exception('Usuario no encontrado'),
      );
    } catch (e) {
      return null;
    }
  }
  
  /// Obtener usuarios por rol
  Future<List<UserModel>> getUsersByRole(UserRole role) async {
    try {
      final allUsers = await getAllUsers();
      return allUsers.where((user) => user.role == role).toList();
    } catch (e) {
      print('Error obteniendo usuarios por rol: $e');
      return [];
    }
  }
  
  /// Obtener usuarios activos
  Future<List<UserModel>> getActiveUsers() async {
    try {
      final allUsers = await getAllUsers();
      return allUsers.where((user) => user.isActive).toList();
    } catch (e) {
      print('Error obteniendo usuarios activos: $e');
      return [];
    }
  }
  
  /// Obtener usuarios inactivos
  Future<List<UserModel>> getInactiveUsers() async {
    try {
      final allUsers = await getAllUsers();
      return allUsers.where((user) => !user.isActive).toList();
    } catch (e) {
      print('Error obteniendo usuarios inactivos: $e');
      return [];
    }
  }
  
  /// Buscar usuarios por texto
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      if (query.isEmpty) return await getAllUsers();
      
      final allUsers = await getAllUsers();
      final lowerQuery = query.toLowerCase();
      
      return allUsers.where((user) {
        return user.fullName.toLowerCase().contains(lowerQuery) ||
               user.id.toLowerCase().contains(lowerQuery) ||
               user.roleDescription.toLowerCase().contains(lowerQuery) ||
               (user.email?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    } catch (e) {
      print('Error buscando usuarios: $e');
      return [];
    }
  }
  
  /// Activar/desactivar usuario
  Future<bool> toggleUserStatus(String userId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) return false;
      
      // No permitir desactivar el último administrador
      if (user.isAdmin && user.isActive) {
        final activeAdmins = await getActiveAdmins();
        if (activeAdmins.length <= 1) {
          return false; // Es el último admin activo
        }
      }
      
      return await updateUser(userId, isActive: !user.isActive);
    } catch (e) {
      print('Error cambiando estado de usuario: $e');
      return false;
    }
  }
  
  /// Obtener administradores activos
  Future<List<UserModel>> getActiveAdmins() async {
    try {
      final admins = await getUsersByRole(UserRole.admin);
      return admins.where((admin) => admin.isActive).toList();
    } catch (e) {
      print('Error obteniendo administradores activos: $e');
      return [];
    }
  }
  
  /// Restablecer contraseña de usuario
  Future<bool> resetUserPassword(String userId, String newPassword) async {
    try {
      return await updateUser(userId, plainPassword: newPassword);
    } catch (e) {
      print('Error restableciendo contraseña: $e');
      return false;
    }
  }
  
  /// Obtener estadísticas de usuarios
  Future<Map<String, dynamic>> getUsersStats() async {
    try {
      final allUsers = await getAllUsers();
      
      int totalUsers = allUsers.length;
      int activeUsers = 0;
      int inactiveUsers = 0;
      int completedInduction = 0;
      
      Map<String, int> roleCount = {};
      List<UserModel> recentUsers = [];
      
      for (final user in allUsers) {
        // Contar por estado
        if (user.isActive) {
          activeUsers++;
        } else {
          inactiveUsers++;
        }
        
        // Contar inducción completada
        if (user.hasCompletedInduction) {
          completedInduction++;
        }
        
        // Contar por rol
        final roleName = user.roleDescription;
        roleCount[roleName] = (roleCount[roleName] ?? 0) + 1;
        
        // Usuarios recientes (últimos 30 días)
        final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
        if (user.createdAt.isAfter(thirtyDaysAgo)) {
          recentUsers.add(user);
        }
      }
      
      // Ordenar usuarios recientes por fecha de creación
      recentUsers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return {
        'totalUsers': totalUsers,
        'activeUsers': activeUsers,
        'inactiveUsers': inactiveUsers,
        'completedInduction': completedInduction,
        'roleCount': roleCount,
        'recentUsersCount': recentUsers.length,
        'recentUsers': recentUsers.take(5).map((u) => u.toMap()).toList(),
      };
    } catch (e) {
      print('Error obteniendo estadísticas de usuarios: $e');
      return {};
    }
  }
  
  /// Validar datos de usuario
  Map<String, String> validateUserData({
    required String id,
    required String fullName,
    required UserRole role,
    required String password,
    String? email,
    String? phone,
    String? existingUserId, // Para actualizaciones
  }) {
    Map<String, String> errors = {};
    
    // Validar ID (carné)
    if (id.trim().isEmpty) {
      errors['id'] = 'El carné es requerido';
    } else if (id.length != 7) {
      errors['id'] = 'El carné debe tener 7 dígitos';
    } else if (!RegExp(r'^\d{7}$').hasMatch(id)) {
      errors['id'] = 'El carné debe contener solo números';
    }
    
    // Validar nombre completo
    if (fullName.trim().isEmpty) {
      errors['fullName'] = 'El nombre completo es requerido';
    } else if (fullName.trim().length < 3) {
      errors['fullName'] = 'El nombre debe tener al menos 3 caracteres';
    } else if (!fullName.trim().contains(' ')) {
      errors['fullName'] = 'Debe incluir al menos nombre y apellido';
    } else if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(fullName.trim())) {
      errors['fullName'] = 'El nombre solo puede contener letras y espacios';
    }
    
    // Validar contraseña
    if (password.trim().isEmpty) {
      errors['password'] = 'La contraseña es requerida';
    } else if (password.length < 4) {
      errors['password'] = 'La contraseña debe tener al menos 4 caracteres';
    } else if (password.length > AppConstants.maxPasswordLength) {
      errors['password'] = 'La contraseña es demasiado larga';
    }
    
    // Validar email si se proporciona
    if (email != null && email.isNotEmpty) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        errors['email'] = 'Email inválido';
      }
    }
    
    // Validar teléfono si se proporciona
    if (phone != null && phone.isNotEmpty) {
      if (!RegExp(r'^\d{8}$').hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
        errors['phone'] = 'Teléfono inválido (debe tener 8 dígitos)';
      }
    }
    
    return errors;
  }
  
  /// Verificar si un carné ya existe
  Future<bool> carneExists(String carne, {String? excludeUserId}) async {
    try {
      final user = await getUserById(carne);
      if (user == null) return false;
      
      // Si es una actualización, excluir el usuario actual
      if (excludeUserId != null && user.id == excludeUserId) {
        return false;
      }
      
      return true;
    } catch (e) {
      print('Error verificando existencia de carné: $e');
      return false;
    }
  }
  
  /// Verificar si un nombre completo ya existe
  Future<bool> fullNameExists(String fullName, {String? excludeUserId}) async {
    try {
      final user = await getUserByFullName(fullName);
      if (user == null) return false;
      
      // Si es una actualización, excluir el usuario actual
      if (excludeUserId != null && user.id == excludeUserId) {
        return false;
      }
      
      return true;
    } catch (e) {
      print('Error verificando existencia de nombre: $e');
      return false;
    }
  }
  
  /// Exportar lista de usuarios (para admin)
  Future<Map<String, dynamic>> exportUsersList() async {
    try {
      final allUsers = await getAllUsers();
      final stats = await getUsersStats();
      
      return {
        'exportDate': DateTime.now().toIso8601String(),
        'totalUsers': allUsers.length,
        'statistics': stats,
        'users': allUsers.map((user) {
          final userMap = user.toMap();
          userMap.remove('password'); // No exportar contraseñas
          return userMap;
        }).toList(),
      };
    } catch (e) {
      print('Error exportando lista de usuarios: $e');
      return {};
    }
  }
  
  /// Obtener usuarios con más reservaciones (para estadísticas)
  Future<List<Map<String, dynamic>>> getMostActiveUsers({int limit = 10}) async {
    try {
      // Esta función se implementaría completa cuando se integre con el repositorio de reservaciones
      // Por ahora retornamos una lista vacía
      return [];
    } catch (e) {
      print('Error obteniendo usuarios más activos: $e');
      return [];
    }
  }
  
  /// Buscar usuarios con filtros múltiples
  Future<List<UserModel>> searchUsersAdvanced({
    String? query,
    UserRole? role,
    bool? isActive,
    bool? hasCompletedInduction,
  }) async {
    try {
      List<UserModel> results = await getAllUsers();
      
      // Filtrar por query de búsqueda
      if (query != null && query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        results = results.where((user) {
          return user.fullName.toLowerCase().contains(lowerQuery) ||
                 user.id.toLowerCase().contains(lowerQuery) ||
                 user.roleDescription.toLowerCase().contains(lowerQuery) ||
                 (user.email?.toLowerCase().contains(lowerQuery) ?? false);
        }).toList();
      }
      
      // Filtrar por rol
      if (role != null) {
        results = results.where((user) => user.role == role).toList();
      }
      
      // Filtrar por estado activo
      if (isActive != null) {
        results = results.where((user) => user.isActive == isActive).toList();
      }
      
      // Filtrar por inducción completada
      if (hasCompletedInduction != null) {
        results = results.where((user) => 
          user.hasCompletedInduction == hasCompletedInduction
        ).toList();
      }
      
      // Ordenar por nombre
      results.sort((a, b) => a.fullName.compareTo(b.fullName));
      
      return results;
    } catch (e) {
      print('Error en búsqueda avanzada de usuarios: $e');
      return [];
    }
  }
}