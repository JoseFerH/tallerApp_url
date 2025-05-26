import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/reservation_repository.dart';
import '../../../data/repositories/tool_repository.dart';

/// Binding para el módulo de home
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Repositorios
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(),
    );
    
    Get.lazyPut<ReservationRepository>(
      () => ReservationRepository(),
    );
    
    Get.lazyPut<ToolRepository>(
      () => ToolRepository(),
    );
    
    // Controlador del home
    Get.lazyPut<HomeController>(
      () => HomeController(
        authRepository: Get.find<AuthRepository>(),
        reservationRepository: Get.find<ReservationRepository>(),
        toolRepository: Get.find<ToolRepository>(),
      ),
    );
  }
}