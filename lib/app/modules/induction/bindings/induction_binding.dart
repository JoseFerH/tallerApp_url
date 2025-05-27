import 'package:get/get.dart';
import '../controllers/induction_controller.dart';
import '../../../data/providers/local_storage_provider.dart';

/// Binding para el módulo de inducción
class InductionBinding extends Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut<LocalStorageProvider>(() => LocalStorageProvider());

    // Controllers
    Get.lazyPut<InductionController>(
      () => InductionController(Get.find<LocalStorageProvider>()),
    );
  }
}
