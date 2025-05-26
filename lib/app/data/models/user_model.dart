import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../core/utils/constants.dart';

/// Modelo de datos para usuarios del sistema
class UserModel {
  final String id;           // Carné universitario
  final String fullName;     // Nombre completo
  final UserRole role;       // Rol del usuario
  final String password;     // Contraseña (hasheada)
  final DateTime createdAt;  // Fecha de creación
  final bool hasCompletedInduction; // Ha completado la inducción
  final bool isActive;       // Usuario activo
  final DateTime? lastLogin; // Último inicio de sesión
  final String? email;       // Email (opcional)
  final String? phone;       // Teléfono (opcional)
  
  UserModel({
    required this.id,
    required this.fullName,
    required this.role,
    required this.password,
    required this.createdAt,
    this.hasCompletedInduction = false,
    this.isActive = true,
    this.lastLogin,
    this.email,
    this.phone,
  });
  
  /// Constructor para crear un usuario con contraseña en texto plano
  factory UserModel.create({
    required String id,
    required String fullName,
    required UserRole role,
    required String plainPassword,
    String? email,
    String? phone,
  }) {
    return UserModel(
      id: id,
      fullName: fullName,
      role: role,
      password: _hashPassword(plainPassword),
      createdAt: DateTime.now(),
      email: email,
      phone: phone,
    );
  }
  
  /// Crear copia del usuario con algunos campos modificados
  UserModel copyWith({
    String? id,
    String? fullName,
    UserRole? role,
    String? password,
    DateTime? createdAt,
    bool? hasCompletedInduction,
    bool? isActive,
    DateTime? lastLogin,
    String? email,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      hasCompletedInduction: hasCompletedInduction ?? this.hasCompletedInduction,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
  
  /// Marcar inducción como completada
  UserModel markInductionCompleted() {
    return copyWith(hasCompletedInduction: true);
  }
  
  /// Actualizar último login
  UserModel updateLastLogin() {
    return copyWith(lastLogin: DateTime.now());
  }
  
  /// Verificar si la contraseña es correcta
  bool verifyPassword(String plainPassword) {
    return password == _hashPassword(plainPassword);
  }
  
  /// Verificar si el usuario tiene permisos de administrador
  bool get isAdmin => role == UserRole.admin;
  
  /// Verificar si el usuario es docente o auxiliar
  bool get isStaff => role == UserRole.docente || role == UserRole.auxiliar || role == UserRole.admin;
  
  /// Verificar si el usuario es estudiante
  bool get isStudent => role == UserRole.estudiante;
  
  /// Obtener nombre para mostrar
  String get displayName => fullName;
  
  /// Obtener descripción del rol
  String get roleDescription => role.displayName;
  
  /// Hashear contraseña usando SHA-256
  static String _hashPassword(String plainPassword) {
    var bytes = utf8.encode(plainPassword);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  /// Convertir a Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'role': role.name,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'hasCompletedInduction': hasCompletedInduction,
      'isActive': isActive,
      'lastLogin': lastLogin?.toIso8601String(),
      'email': email,
      'phone': phone,
    };
  }
  
  /// Crear desde Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.estudiante,
      ),
      password: map['password'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      hasCompletedInduction: map['hasCompletedInduction'] ?? false,
      isActive: map['isActive'] ?? true,
      lastLogin: map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
      email: map['email'],
      phone: map['phone'],
    );
  }
  
  /// Convertir a JSON
  String toJson() => json.encode(toMap());
  
  /// Crear desde JSON
  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
  
  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, role: $role, isActive: $isActive)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is UserModel && other.id == id;
  }
  
  @override
  int get hashCode {
    return id.hashCode;
  }
}