import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';
import '../../../data/providers/local_storage_provider.dart';

/// Binding para el módulo de notificaciones
class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut<LocalStorageProvider>(() => LocalStorageProvider());

    // Controllers
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(Get.find<LocalStorageProvider>()),
    );
  }
}
