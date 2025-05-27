import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../data/models/user_model.dart';

/// Widget para mostrar un usuario en la lista de administración
class UserListItem extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;
  final bool isSelected;

  const UserListItem({
    Key? key,
    required this.user,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primaryBlue : AppColors.cardBorder,
          width: isSelected ? 2 : 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildUserHeader(),
              const SizedBox(height: 12),
              _buildUserInfo(),
              if (showActions) ...[const SizedBox(height: 12), _buildActions()],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: AppTextStyles.h6,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.badge_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(user.id, style: AppTextStyles.bodySmall),
                ],
              ),
            ],
          ),
        ),
        _buildRoleBadge(),
      ],
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Helpers.generateColorFromText(user.fullName),
      child: Text(
        Helpers.getInitials(user.fullName),
        style: AppTextStyles.h6.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRoleBadge() {
    final roleColor = _getRoleColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: roleColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: roleColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getRoleIcon(), size: 14, color: roleColor),
          const SizedBox(width: 4),
          Text(
            user.role.displayName,
            style: AppTextStyles.caption.copyWith(
              color: roleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        // Email
        if (user.email != null)
          _buildInfoRow(Icons.email_outlined, 'Email', user.email!),

        const SizedBox(height: 8),

        // Fecha de creación
        _buildInfoRow(
          Icons.calendar_today_outlined,
          'Creado',
          Helpers.formatDate(user.createdAt),
        ),

        const SizedBox(height: 8),

        // Estado de inducción
        _buildInductionStatus(),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInductionStatus() {
    final hasCompleted = user.hasCompletedInduction;

    return Row(
      children: [
        Icon(
          hasCompleted ? Icons.check_circle : Icons.pending,
          size: 16,
          color: hasCompleted ? AppColors.success : AppColors.warning,
        ),
        const SizedBox(width: 8),
        Text(
          'Inducción: ',
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          hasCompleted ? 'Completada' : 'Pendiente',
          style: AppTextStyles.caption.copyWith(
            color: hasCompleted ? AppColors.success : AppColors.warning,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Editar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
              side: const BorderSide(color: AppColors.primaryBlue),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (user.role != UserRole.admin) // No permitir eliminar admin
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 16),
              label: const Text('Eliminar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
      ],
    );
  }

  Color _getRoleColor() {
    switch (user.role) {
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

  IconData _getRoleIcon() {
    switch (user.role) {
      case UserRole.estudiante:
        return Icons.school;
      case UserRole.docente:
        return Icons.person;
      case UserRole.auxiliar:
        return Icons.build;
      case UserRole.admin:
        return Icons.admin_panel_settings;
    }
  }
}
