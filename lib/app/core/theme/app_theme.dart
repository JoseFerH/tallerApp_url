import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Tema principal de la aplicación TallerURL
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Configuración básica
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Esquema de colores principal
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        primaryContainer: AppColors.primaryBlueLight,
        secondary: AppColors.secondaryGreen,
        secondaryContainer: AppColors.accentOrange,
        surface: AppColors.backgroundPrimary,
        background: AppColors.backgroundSecondary,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: AppColors.white,
      ),
      
      // Configuración de la AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.cardShadow,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h5,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // Configuración de botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          textStyle: AppTextStyles.buttonMedium,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
      
      // Configuración de botones con contorno
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          textStyle: AppTextStyles.buttonMedium,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(color: AppColors.primaryBlue, width: 1),
        ),
      ),
      
      // Configuración de botones de texto
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          textStyle: AppTextStyles.buttonMedium,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      
      // Configuración de campos de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.labelLarge,
        hintStyle: AppTextStyles.labelMedium,
        errorStyle: AppTextStyles.error,
      ),
      
      // Configuración de tarjetas
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 2,
        shadowColor: AppColors.cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.cardBorder, width: 0.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // Configuración de iconos
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),
      
      // Configuración de la barra de navegación inferior
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundPrimary,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Configuración de chips
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.mediumGray,
        labelStyle: AppTextStyles.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Configuración de dividers
      dividerTheme: const DividerThemeData(
        color: AppColors.cardBorder,
        thickness: 1,
        space: 1,
      ),
      
      // Configuración de floating action button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        elevation: 4,
      ),
      
      // Configuración de diálogos
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: AppTextStyles.h5,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),
      
      // Configuración de snackbars
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.darkGray,
        contentTextStyle: AppTextStyles.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      
      // Configuración de tooltips
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: AppTextStyles.caption.copyWith(color: AppColors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
  
  // Método para obtener sombras personalizadas
  static List<BoxShadow> get cardShadow => [
    const BoxShadow(
      color: AppColors.cardShadow,
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  
  // Método para obtener sombras elevadas
  static List<BoxShadow> get elevatedShadow => [
    const BoxShadow(
      color: AppColors.cardShadow,
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
}