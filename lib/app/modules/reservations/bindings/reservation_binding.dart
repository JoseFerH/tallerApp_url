import 'package:get/get.dart';
import '../controllers/reservation_controller.dart';
import '../../../data/repositories/reservation_repository.dart';
import '../../../data/repositories/auth_repository.dart';

/// Binding para el módulo de reservaciones
class ReservationBinding extends Bindings {
  @override
  void dependencies() {
    // Repositorios
    Get.lazyPut<ReservationRepository>(
      () => ReservationRepository(),
    );
    
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(),
    );
    
    // Controlador de reservaciones
    Get.lazyPut<ReservationController>(
      () => ReservationController(
        reservationRepository: Get.find<ReservationRepository>(),
        authRepository: Get.find<AuthRepository>(),
      ),
    );
  }
}