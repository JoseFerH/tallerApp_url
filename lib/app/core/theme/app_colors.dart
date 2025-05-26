import 'package:flutter/material.dart';

/// Paleta de colores corporativos de la Universidad Rafael Landívar
class AppColors {
  // Colores principales URL
  static const Color primaryBlue = Color(0xFF003DA5);     // Azul Principal
  static const Color secondaryGreen = Color(0xFF7BA428);  // Verde Secundario
  static const Color accentOrange = Color(0xFFF39200);    // Naranja Acento
  static const Color neutralGray = Color(0xFF6C757D);     // Gris Neutro
  
  // Variaciones del azul principal
  static const Color primaryBlueDark = Color(0xFF002B78);
  static const Color primaryBlueLight = Color(0xFF4D7BC9);
  
  // Colores de estado
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);
  
  // Colores neutros para UI
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFFE9ECEF);
  static const Color darkGray = Color(0xFF495057);
  
  // Colores para texto
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFADB5BD);
  
  // Colores para fondos
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF8F9FA);
  static const Color backgroundAccent = Color(0xFFF0F8FF);
  
  // Colores para tarjetas y superficies
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE9ECEF);
  static const Color cardShadow = Color(0x1A000000);
  
  // Gradientes corporativos
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueDark],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentOrange, Color(0xFFE68900)],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryGreen, Color(0xFF5E8020)],
  );
}