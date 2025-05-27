import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/providers/local_storage_provider.dart';

/// Binding para el módulo de administración
class AdminBinding extends Bindings {
  @override
  void dependencies() {
    // Providers - Solo crear si no existe
    if (!Get.isRegistered<LocalStorageProvider>()) {
      Get.lazyPut<LocalStorageProvider>(() => LocalStorageProvider());
    }

    // Repositories
    Get.lazyPut<UserRepository>(() => UserRepository());

    Get.lazyPut<AuthRepository>(() => AuthRepository());

    // Controllers
    Get.lazyPut<AdminController>(
      () => AdminController(
        userRepository: Get.find<UserRepository>(),
        authRepository: Get.find<AuthRepository>(),
      ),
    );
  }
}
