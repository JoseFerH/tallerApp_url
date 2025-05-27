import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// AppBar personalizada reutilizable para toda la aplicación
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final Widget? titleWidget;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBack = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.onBackPressed,
    this.centerTitle = true,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          titleWidget ??
          Text(
            title,
            style: AppTextStyles.h5.copyWith(
              color: foregroundColor ?? AppColors.white,
            ),
          ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primaryBlue,
      foregroundColor: foregroundColor ?? AppColors.white,
      elevation: elevation,
      shadowColor: AppColors.cardShadow,
      leading: _buildLeading(),
      actions: actions,
      iconTheme: IconThemeData(color: foregroundColor ?? AppColors.white),
    );
  }

  Widget? _buildLeading() {
    if (leading != null) return leading;

    if (showBack && Get.routing.current != '/') {
      return IconButton(
        onPressed: onBackPressed ?? () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios),
        tooltip: 'Regresar',
      );
    }

    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar específica para la pantalla principal
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationsTap;
  final int notificationCount;

  const HomeAppBar({
    super.key,
    required this.userName,
    this.onProfileTap,
    this.onNotificationsTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TallerURL',
            style: AppTextStyles.urlBrand.copyWith(
              color: AppColors.white,
              fontSize: 20,
            ),
          ),
          Text(
            'Hola, ${_getFirstName(userName)}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.white,
      elevation: 2,
      automaticallyImplyLeading: false,
      actions: [
        // Botón de notificaciones
        IconButton(
          onPressed: onNotificationsTap,
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              if (notificationCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      notificationCount > 99 ? '99+' : '$notificationCount',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          tooltip: 'Notificaciones',
        ),

        // Botón de perfil
        IconButton(
          onPressed: onProfileTap,
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.white.withOpacity(0.2),
            child: Text(
              _getInitials(userName),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          tooltip: 'Perfil',
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  String _getFirstName(String fullName) {
    final names = fullName.trim().split(' ');
    return names.isNotEmpty ? names[0] : 'Usuario';
  }

  String _getInitials(String fullName) {
    final names = fullName.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'U';
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar para pantallas de búsqueda
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool autofocus;

  const SearchAppBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onClear,
    this.controller,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.white,
      elevation: 2,
      title: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autofocus,
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.white.withOpacity(0.7)),
          border: InputBorder.none,
          suffixIcon:
              controller?.text.isNotEmpty == true
                  ? IconButton(
                    onPressed: onClear,
                    icon: const Icon(Icons.clear, color: AppColors.white),
                  )
                  : null,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
