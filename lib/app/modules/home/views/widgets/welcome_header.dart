// // lib/app/modules/home/views/widgets/welcome_header.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_text_styles.dart';
// import '../../../../core/values/strings.dart';
// import '../../controllers/home_controller.dart';

// class WelcomeHeader extends GetView<HomeController> {
//   const WelcomeHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: AppColors.primaryGradient,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryBlue.withOpacity(0.3),
//             offset: const Offset(0, 4),
//             blurRadius: 12,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildGreeting(),
//           const SizedBox(height: 8),
//           _buildUserInfo(),
//           const SizedBox(height: 16),
//           _buildUserStats(),
//         ],
//       ),
//     );
//   }

//   // ✅ CORREGIDO: Solo usar Obx para lo que cambia
//   Widget _buildGreeting() {
//     return Obx(() {
//       final greeting = _getTimeOfDayGreeting();
//       final firstName =
//           controller.currentUser.value?.fullName.split(' ').first ?? 'Usuario';

//       return Text(
//         '$greeting, $firstName',
//         style: AppTextStyles.h4.copyWith(
//           color: AppColors.white,
//           fontWeight: FontWeight.bold,
//         ),
//       );
//     });
//   }

//   Widget _buildUserInfo() {
//     return Obx(
//       () => Row(
//         children: [
//           Icon(
//             _getRoleIcon(),
//             color: AppColors.white.withOpacity(0.9),
//             size: 18,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             controller.currentUser.value?.roleDescription ?? 'Sin rol',
//             style: AppTextStyles.bodyMedium.copyWith(
//               color: AppColors.white.withOpacity(0.9),
//             ),
//           ),
//           const Spacer(),
//           if (!controller.hasCompletedInduction)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: AppColors.warning.withOpacity(0.9),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 'Inducción Pendiente',
//                 style: AppTextStyles.caption.copyWith(
//                   color: AppColors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             )
//           else
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: AppColors.success.withOpacity(0.9),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.check_circle, size: 12, color: AppColors.white),
//                   const SizedBox(width: 4),
//                   Text(
//                     'Verificado',
//                     style: AppTextStyles.caption.copyWith(
//                       color: AppColors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserStats() {
//     return Obx(
//       () => Row(
//         children: [
//           _buildStatChip(
//             icon: Icons.event_note,
//             label: 'Total',
//             value: '${controller.userTotalReservations}',
//           ),
//           const SizedBox(width: 12),
//           _buildStatChip(
//             icon: Icons.event_available,
//             label: 'Activas',
//             value: '${controller.userActiveReservations}',
//           ),
//           const Spacer(),
//           IconButton(
//             onPressed: controller.refreshDashboard,
//             icon: Obx(
//               () => AnimatedRotation(
//                 turns: controller.isLoading.value ? 1.0 : 0.0,
//                 duration: const Duration(seconds: 1),
//                 child: Icon(
//                   Icons.refresh,
//                   color: AppColors.white.withOpacity(0.9),
//                 ),
//               ),
//             ),
//             tooltip: 'Actualizar datos',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatChip({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: AppColors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: AppColors.white),
//           const SizedBox(width: 6),
//           Text(
//             value,
//             style: AppTextStyles.labelMedium.copyWith(
//               color: AppColors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: AppTextStyles.caption.copyWith(
//               color: AppColors.white.withOpacity(0.8),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getTimeOfDayGreeting() {
//     final hour = DateTime.now().hour;

//     if (hour < 12) {
//       return 'Buenos días';
//     } else if (hour < 18) {
//       return 'Buenas tardes';
//     } else {
//       return 'Buenas noches';
//     }
//   }

//   IconData _getRoleIcon() {
//     final user = controller.currentUser.value;
//     if (user?.isAdmin == true) {
//       return Icons.admin_panel_settings;
//     } else if (user?.isStaff == true) {
//       return Icons.work;
//     } else {
//       return Icons.school;
//     }
//   }
// }
