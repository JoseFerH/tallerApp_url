import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/values/strings.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../data/models/user_model.dart';
import 'role_selector.dart';

/// Formulario para crear y editar usuarios
class UserForm extends StatefulWidget {
  final UserModel? user; // null para crear, lleno para editar
  final void Function(UserModel user) onSave;
  final VoidCallback? onCancel;

  const UserForm({Key? key, this.user, required this.onSave, this.onCancel})
    : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _fullNameController;
  late final TextEditingController _carneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  // Form state
  UserRole? _selectedRole;
  bool _hasCompletedInduction = false;
  bool _isLoading = false;

  // UI state
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.user != null;

    // Initialize controllers
    _fullNameController = TextEditingController(
      text: widget.user?.fullName ?? '',
    );
    _carneController = TextEditingController(text: widget.user?.id ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    // Initialize state
    _selectedRole = widget.user?.role;
    _hasCompletedInduction = widget.user?.hasCompletedInduction ?? false;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _carneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader(),
          const SizedBox(height: 24),
          _buildFormFields(),
          const SizedBox(height: 32),
          _buildFormActions(),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isEditing ? 'Editar Usuario' : 'Crear Nuevo Usuario',
          style: AppTextStyles.h4,
        ),
        const SizedBox(height: 8),
        Text(
          _isEditing
              ? 'Modifica la información del usuario seleccionado'
              : 'Completa todos los campos para crear un nuevo usuario',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // Nombre completo
        CustomTextField(
          label: Strings.usernameLabel,
          hint: 'Ejemplo: María José González Pérez',
          controller: _fullNameController,
          validator: Validators.fullName,
          prefixIcon: const Icon(Icons.person_outline),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),

        // Carné universitario
        CustomTextField(
          label: Strings.passwordLabel,
          hint: '1234567',
          controller: _carneController,
          validator: Validators.carne,
          prefixIcon: const Icon(Icons.badge_outlined),
          keyboardType: TextInputType.number,
          enabled: !_isEditing, // No se puede cambiar el carné al editar
        ),
        const SizedBox(height: 16),

        // Email
        CustomTextField.email(
          label: 'Email Institucional',
          hint: 'usuario@url.edu.gt',
          controller: _emailController,
          validator:
              (value) => Validators.combine(value, [
                (v) => Validators.required(v, fieldName: 'Email'),
                Validators.email,
              ]),
        ),
        const SizedBox(height: 16),

        // Rol de usuario
        RoleSelector(
          label: 'Rol del Usuario',
          selectedRole: _selectedRole,
          onChanged: (role) {
            setState(() {
              _selectedRole = role;
            });
          },
          errorText: _selectedRole == null ? 'Selecciona un rol' : null,
        ),
        const SizedBox(height: 16),

        // Contraseña (solo para usuarios nuevos o si se quiere cambiar)
        if (!_isEditing) ...[
          CustomTextField.password(
            label: 'Contraseña',
            hint: 'Mínimo 4 caracteres',
            controller: _passwordController,
            validator: (value) => Validators.password(value, minLength: 4),
          ),
          const SizedBox(height: 16),

          CustomTextField.password(
            label: 'Confirmar Contraseña',
            hint: 'Repite la contraseña',
            controller: _confirmPasswordController,
            validator:
                (value) =>
                    Validators.confirmPassword(value, _passwordController.text),
          ),
          const SizedBox(height: 16),
        ],

        // Estado de inducción
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estado de Inducción', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Ha completado la inducción'),
                  subtitle: const Text(
                    'Marca esta opción si el usuario ya vio los videos de inducción',
                  ),
                  value: _hasCompletedInduction,
                  onChanged: (value) {
                    setState(() {
                      _hasCompletedInduction = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormActions() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: Strings.cancel,
            type: CustomButtonType.outline,
            onPressed:
                _isLoading ? null : (widget.onCancel ?? () => Get.back()),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomButton.primary(
            _isEditing ? 'Actualizar Usuario' : 'Crear Usuario',
            onPressed: _isLoading ? null : _handleSave,
            isLoading: _isLoading,
            icon:
                _isEditing
                    ? const Icon(Icons.update)
                    : const Icon(Icons.person_add),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRole == null) {
      Get.snackbar(
        'Error',
        'Debes seleccionar un rol para el usuario',
        backgroundColor: AppColors.error.withOpacity(0.1),
        colorText: AppColors.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserModel newUser;

      if (_isEditing) {
        // Actualizar usuario existente
        newUser = widget.user!.copyWith(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          role: _selectedRole!,
          hasCompletedInduction: _hasCompletedInduction,
        );

        // Si se proporciona nueva contraseña, actualizarla
        if (_passwordController.text.isNotEmpty) {
          newUser = newUser.copyWith(
            password: _passwordController.text, // En producción usar hash
          );
        }
      } else {
        // Crear nuevo usuario
        newUser = UserModel.create(
          id: _carneController.text.trim(),
          fullName: _fullNameController.text.trim(),
          role: _selectedRole!,
          plainPassword: _passwordController.text,
          email: _emailController.text.trim(),
        ).copyWith(hasCompletedInduction: _hasCompletedInduction);
      }

      widget.onSave(newUser);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al ${_isEditing ? 'actualizar' : 'crear'} usuario: $e',
        backgroundColor: AppColors.error.withOpacity(0.1),
        colorText: AppColors.error,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
