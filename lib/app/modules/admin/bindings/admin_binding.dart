import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/providers/local_storage_provider.dart';

/// Binding para el módulo de administración
class AdminBinding extends Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut<LocalStorageProvider>(() => LocalStorageProvider());

    // Repositories
    Get.lazyPut<UserRepository>(
      () => UserRepository(Get.find<LocalStorageProvider>()),
    );

    // Controllers
    Get.lazyPut<AdminController>(
      () => AdminController(Get.find<UserRepository>()),
    );
  }
}
