import 'package:get/get.dart';
import '../controllers/schedule_controller.dart';

/// Binding para el módulo de horarios
class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    // Controlador de horarios
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }
}
