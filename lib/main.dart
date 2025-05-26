import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'initial_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar GetStorage
  await GetStorage.init();
  
  // Cargar datos iniciales
  await InitialData.loadInitialData();
  
  runApp(const TallerURLApp());
}

class TallerURLApp extends StatelessWidget {
  const TallerURLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TallerURL - Universidad Rafael Landívar',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      
      // Configuración de rutas
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
      
      // Configuración de idioma
      locale: const Locale('es', 'GT'),
      fallbackLocale: const Locale('es', 'GT'),
      
      // Configuración adicional
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}