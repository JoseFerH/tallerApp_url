import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/constants.dart';

/// Widget selector de roles de usuario para administración
class RoleSelector extends StatelessWidget {
  final UserRole? selectedRole;
  final void Function(UserRole?) onChanged;
  final String? label;
  final bool enabled;
  final String? errorText;

  const RoleSelector({
    Key? key,
    required this.selectedRole,
    required this.onChanged,
    this.label,
    this.enabled = true,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null ? AppColors.error : AppColors.cardBorder,
              width: errorText != null ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: enabled ? AppColors.backgroundPrimary : AppColors.mediumGray,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UserRole>(
              value: selectedRole,
              hint: Text(
                'Seleccionar rol',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              isExpanded: true,
              style: AppTextStyles.bodyMedium,
              dropdownColor: AppColors.backgroundPrimary,
              icon: Icon(
                Icons.arrow_drop_down,
                color: enabled ? AppColors.textSecondary : AppColors.textLight,
              ),
              onChanged: enabled ? onChanged : null,
              items:
                  UserRole.values.map((role) {
                    return DropdownMenuItem<UserRole>(
                      value: role,
                      child: _buildRoleItem(role),
                    );
                  }).toList(),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(errorText!, style: AppTextStyles.error),
        ],
      ],
    );
  }

  Widget _buildRoleItem(UserRole role) {
    return Row(
      children: [
        Icon(_getRoleIcon(role), size: 20, color: _getRoleColor(role)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role.displayName, style: AppTextStyles.bodyMedium),
              Text(
                _getRoleDescription(role),
                style: AppTextStyles.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.estudiante:
        return Icons.school_outlined;
      case UserRole.docente:
        return Icons.person_outline;
      case UserRole.auxiliar:
        return Icons.build_outlined;
      case UserRole.admin:
        return Icons.admin_panel_settings_outlined;
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.estudiante:
        return AppColors.primaryBlue;
      case UserRole.docente:
        return AppColors.secondaryGreen;
      case UserRole.auxiliar:
        return AppColors.accentOrange;
      case UserRole.admin:
        return AppColors.error;
    }
  }

  String _getRoleDescription(UserRole role) {
    switch (role) {
      case UserRole.estudiante:
        return 'Acceso básico a herramientas y reservas';
      case UserRole.docente:
        return 'Visualización de reservas de estudiantes';
      case UserRole.auxiliar:
        return 'Gestión de talleres y horarios';
      case UserRole.admin:
        return 'Acceso completo al sistema';
    }
  }
}
