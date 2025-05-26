import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

/// Binding para la pantalla de splash
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Controlador de splash
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
