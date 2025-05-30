import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../core/utils/constants.dart';

/// Controlador para la pantalla de splash
class SplashController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Estado de carga
  final RxBool isLoading = true.obs;
  final RxString loadingMessage = 'Cargando...'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  /// Inicializar la aplicación
  Future<void> _initializeApp() async {
    try {
      // Mostrar splash por el tiempo mínimo configurado
      loadingMessage.value = 'Inicializando TallerURL...';
      await Future.delayed(const Duration(seconds: 1));

      // Verificar si hay datos iniciales cargados
      loadingMessage.value = 'Verificando datos...';
      await Future.delayed(const Duration(milliseconds: 500));

      // Verificar estado de autenticación
      loadingMessage.value = 'Verificando sesión...';
      await Future.delayed(const Duration(milliseconds: 500));

      // Verificar si hay usuario logueado y si la sesión no ha expirado
      final isLoggedIn = _authRepository.isLoggedIn();
      final sessionExpired = _authRepository.isSessionExpired();

      if (isLoggedIn && !sessionExpired) {
        // Usuario logueado con sesión válida - renovar sesión y ir al home
        await _authRepository.renewSession();
        loadingMessage.value = 'Bienvenido de nuevo...';
        await Future.delayed(const Duration(milliseconds: 500));

        _navigateToHome();
      } else {
        // No hay usuario logueado o sesión expirada - ir al login
        if (sessionExpired && isLoggedIn) {
          // Si la sesión expiró, cerrar sesión
          await _authRepository.logout();
          loadingMessage.value = 'Sesión expirada...';
        } else {
          loadingMessage.value = 'Preparando login...';
        }

        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToLogin();
      }
    } catch (e) {
      print('Error inicializando aplicación: $e');
      // En caso de error, ir al login
      loadingMessage.value = 'Error de inicialización...';
      await Future.delayed(const Duration(seconds: 1));
      _navigateToLogin();
    } finally {
      isLoading.value = false;
    }
  }

  /// Navegar al home
  void _navigateToHome() {
    Get.offAllNamed(AppRoutes.HOME);
  }

  /// Navegar al login
  void _navigateToLogin() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  /// Reintentar inicialización (en caso de error)
  void retryInitialization() {
    isLoading.value = true;
    _initializeApp();
  }

  /// Forzar navegación al login (para testing)
  void forceNavigateToLogin() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  /// Forzar navegación al home (para testing)
  void forceNavigateToHome() {
    Get.offAllNamed(AppRoutes.HOME);
  }
}
