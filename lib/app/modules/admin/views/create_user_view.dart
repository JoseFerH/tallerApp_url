import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_dialog.dart';
import '../controllers/admin_controller.dart';
import '../../../data/models/user_model.dart';
import 'widgets/user_form.dart';

/// Vista para crear y editar usuarios
class CreateUserView extends GetView<AdminController> {
  const CreateUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener usuario si se está editando
    final arguments = Get.arguments as Map<String, dynamic>?;
    final UserModel? userToEdit = arguments?['user'];
    final bool isEditing = userToEdit != null;

    return Scaffold(
      appBar: CustomAppBar.admin(
        isEditing ? 'Editar Usuario' : 'Crear Usuario',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: UserForm(
          user: userToEdit,
          onSave: (user) => _handleSaveUser(user, isEditing),
          onCancel: () => Get.back(),
        ),
      ),
    );
  }

  Future<void> _handleSaveUser(UserModel user, bool isEditing) async {
    try {
      if (isEditing) {
        await controller.updateUser(user);
        await CustomDialog.showSuccess(
          title: 'Usuario Actualizado',
          message: 'Los datos del usuario han sido actualizados exitosamente.',
          onConfirm: () {
            Get.back(); // Cerrar diálogo
            Get.back(); // Volver a lista de usuarios
          },
        );
      } else {
        await controller.createUser(user);
        await CustomDialog.showSuccess(
          title: 'Usuario Creado',
          message: 'El usuario ha sido creado exitosamente.',
          onConfirm: () {
            Get.back(); // Cerrar diálogo
            Get.back(); // Volver a lista de usuarios
          },
        );
      }
    } catch (e) {
      await CustomDialog.showError(
        title: 'Error',
        message:
            'No se pudo ${isEditing ? 'actualizar' : 'crear'} el usuario: $e',
      );
    }
  }
}
