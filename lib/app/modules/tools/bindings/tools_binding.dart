import 'package:get/get.dart';
import '../controllers/tools_controller.dart';
import '../../../data/repositories/tool_repository.dart';

/// Binding para el módulo de herramientas
class ToolsBinding extends Bindings {
  @override
  void dependencies() {
    // Repositorio de herramientas
    Get.lazyPut<ToolRepository>(
      () => ToolRepository(),
    );
    
    // Controlador de herramientas
    Get.lazyPut<ToolsController>(
      () => ToolsController(
        toolRepository: Get.find<ToolRepository>(),
      ),
    );
  }
}