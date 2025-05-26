import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../data/repositories/auth_repository.dart';

/// Binding para el módulo de autenticación
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Repositorio de autenticación
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(),
    );
    
    // Controlador de autenticación
    Get.lazyPut<AuthController>(
      () => AuthController(
        authRepository: Get.find<AuthRepository>(),
      ),
    );
  }
}