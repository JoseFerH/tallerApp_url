import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../core/values/strings.dart';

/// Controlador para el módulo de autenticación
class AuthController extends GetxController {
  final AuthRepository authRepository;
  
  AuthController({required this.authRepository});
  
  // Controladores de formulario
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Keys del formulario
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  
  // Estados reactivos
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool rememberCredentials = false.obs;
  
  // Usuario actual
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  
  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }
  
  @override
  void onClose() {
    fullNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  /// Inicializar autenticación
  void _initializeAuth() {
    // Verificar si hay usuario actual
    currentUser.value = authRepository.getCurrentUser();
    
    // Cargar credenciales guardadas si el usuario las recordó
    _loadSavedCredentials();
  }
  
  /// Iniciar sesión
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final fullName = fullNameController.text.trim();
      final password = passwordController.text.trim();
      
      // Intentar hacer login
      final user = await authRepository.login(fullName, password);
      
      if (user != null) {
        // Login exitoso
        currentUser.value = user;
        
        // Guardar credenciales si el usuario lo solicitó
        if (rememberCredentials.value) {
          await _saveCredentials(fullName, password);
        } else {
          await _clearSavedCredentials();
        }
        
        // Mostrar mensaje de bienvenida
        Get.snackbar(
          'Bienvenido',
          'Hola ${user.fullName}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
        );
        
        // Navegar al home
        Get.offAllNamed(AppRoutes.HOME);
        
      } else {
        // Login fallido
        errorMessage.value = Strings.loginError;
        
        // Limpiar contraseña
        passwordController.clear();
        
        // Mostrar error
        Get.snackbar(
          'Error de Login',
          Strings.loginError,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          duration: const Duration(seconds: 3),
        );
      }
      
    } catch (e) {
      print('Error en login: $e');
      errorMessage.value = 'Error inesperado. Intenta de nuevo.';
      
      Get.snackbar(
        'Error',
        'Ha ocurrido un error inesperado',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Cerrar sesión
  Future<void> logout() async {
    try {
      await authRepository.logout();
      currentUser.value = null;
      
      // Limpiar formulario
      _clearForm();
      
      // Navegar al login
      Get.offAllNamed(AppRoutes.LOGIN);
      
      Get.snackbar(
        'Sesión Cerrada',
        'Has cerrado sesión exitosamente',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.withOpacity(0.1),
        colorText: Colors.blue,
      );
      
    } catch (e) {
      print('Error cerrando sesión: $e');
    }
  }
  
  /// Validar nombre completo
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre completo es requerido';
    }
    
    if (!authRepository.isValidFullName(value.trim())) {
      return 'Ingresa tu nombre completo (nombre y apellido)';
    }
    
    return null;
  }
  
  /// Validar contraseña (carné)
  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El carné universitario es requerido';
    }
    
    if (!authRepository.isValidCarne(value.trim())) {
      return 'El carné debe tener 7 dígitos';
    }
    
    return null;
  }
  
  /// Alternar visibilidad de contraseña
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  /// Alternar recordar credenciales
  void toggleRememberCredentials() {
    rememberCredentials.value = !rememberCredentials.value;
  }
  
  /// Limpiar mensaje de error
  void clearError() {
    errorMessage.value = '';
  }
  
  /// Limpiar formulario
  void _clearForm() {
    fullNameController.clear();
    passwordController.clear();
    errorMessage.value = '';
    isPasswordVisible.value = false;
  }
  
  /// Cargar credenciales guardadas
  Future<void> _loadSavedCredentials() async {
    try {
      // Esta funcionalidad se implementaría con SharedPreferences en una versión completa
      // Por ahora solo limpiamos el formulario
      _clearForm();
    } catch (e) {
      print('Error cargando credenciales guardadas: $e');
    }
  }
  
  /// Guardar credenciales
  Future<void> _saveCredentials(String fullName, String password) async {
    try {
      // Esta funcionalidad se implementaría con SharedPreferences en una versión completa
      print('Guardando credenciales para: $fullName');
    } catch (e) {
      print('Error guardando credenciales: $e');
    }
  }
  
  /// Limpiar credenciales guardadas
  Future<void> _clearSavedCredentials() async {
    try {
      // Esta funcionalidad se implementaría con SharedPreferences en una versión completa
      print('Limpiando credenciales guardadas');
    } catch (e) {
      print('Error limpiando credenciales: $e');
    }
  }
  
  /// Verificar si hay usuario logueado
  bool get isLoggedIn => authRepository.isLoggedIn();
  
  /// Obtener usuario actual
  UserModel? get getCurrentUser => authRepository.getCurrentUser();
  
  /// Verificar si el usuario actual es admin
  bool get isCurrentUserAdmin => authRepository.isCurrentUserAdmin();
  
  /// Verificar si el usuario actual es staff
  bool get isCurrentUserStaff => authRepository.isCurrentUserStaff();
  
  /// Obtener rol del usuario actual
  String get getCurrentUserRole => authRepository.getCurrentUserRole();
  
  /// Verificar si ha completado la inducción
  bool get hasCompletedInduction => authRepository.hasCurrentUserCompletedInduction();
  
  /// Marcar inducción como completada
  Future<void> markInductionCompleted() async {
    await authRepository.markInductionCompleted();
    
    // Actualizar usuario actual
    currentUser.value = authRepository.getCurrentUser();
  }
  
  /// Cambiar contraseña
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final success = await authRepository.changePassword(currentPassword, newPassword);
      
      if (success) {
        Get.snackbar(
          'Éxito',
          'Contraseña cambiada exitosamente',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      } else {
        Get.snackbar(
          'Error',
          'Contraseña actual incorrecta',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
      
      return success;
    } catch (e) {
      print('Error cambiando contraseña: $e');
      return false;
    }
  }
  
  /// Auto-login para testing (solo en desarrollo)
  Future<void> autoLoginForTesting({String? userType}) async {
    try {
      // Credenciales predefinidas para testing
      Map<String, Map<String, String>> testUsers = {
        'admin': {
          'fullName': 'admin',
          'password': 'admin',
        },
        'student1': {
          'fullName': 'Emily Sophia Cruz Coronado',
          'password': '1159925',
        },
        'student2': {
          'fullName': 'Eileen Mariana Canté Monzón',
          'password': '1010025',
        },
      };
      
      final testUser = testUsers[userType ?? 'student1']!;
      fullNameController.text = testUser['fullName']!;
      passwordController.text = testUser['password']!;
      
      await login();
    } catch (e) {
      print('Error en auto-login para testing: $e');
    }
  }
  
  /// Refrescar usuario actual
  void refreshCurrentUser() {
    currentUser.value = authRepository.getCurrentUser();
  }
}