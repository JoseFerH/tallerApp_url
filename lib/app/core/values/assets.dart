/// Rutas de assets utilizados en la aplicación
class Assets {
  // Imágenes principales
  static const String logoURL = 'assets/images/logo_url.png';
  static const String splashBackground = 'assets/images/splash_bg.png';
  static const String workshopBackground = 'assets/images/workshop_bg.jpg';
  static const String defaultUserAvatar = 'assets/images/default_avatar.png';
  
  // Iconos personalizados
  static const String iconTools = 'assets/icons/tools.png';
  static const String iconReservation = 'assets/icons/reservation.png';
  static const String iconSchedule = 'assets/icons/schedule.png';
  static const String iconInduction = 'assets/icons/induction.png';
  static const String iconNotification = 'assets/icons/notification.png';
  static const String iconAdmin = 'assets/icons/admin.png';
  
  // Imágenes de herramientas - Herramientas Manuales
  static const String toolHammer = 'assets/images/tools/martillo.jpg';
  static const String toolScrewdriver = 'assets/images/tools/destornillador.jpg';
  static const String toolWrench = 'assets/images/tools/llave_inglesa.jpg';
  static const String toolPliers = 'assets/images/tools/alicates.jpg';
  static const String toolHandsaw = 'assets/images/tools/serrucho.jpg';
  static const String toolChisel = 'assets/images/tools/formones.jpg';
  static const String toolFileSet = 'assets/images/tools/limas.jpg';
  static const String toolClamps = 'assets/images/tools/prensas.jpg';
  
  // Imágenes de herramientas - Herramientas Eléctricas
  static const String toolDrill = 'assets/images/tools/taladro.jpg';
  static const String toolCircularSaw = 'assets/images/tools/sierra_circular.jpg';
  static const String toolJigsaw = 'assets/images/tools/caladora.jpg';
  static const String toolSander = 'assets/images/tools/lijadora.jpg';
  static const String toolRouter = 'assets/images/tools/fresadora.jpg';
  static const String toolAngleGrinder = 'assets/images/tools/amoladora_angular.jpg';
  static const String toolHeatGun = 'assets/images/tools/pistola_calor.jpg';
  static const String toolSolderingIron = 'assets/images/tools/cautin.jpg';
  
  // Imágenes de herramientas - Instrumentos de Medición
  static const String toolRuler = 'assets/images/tools/regla.jpg';
  static const String toolTapemeasure = 'assets/images/tools/cinta_metrica.jpg';
  static const String toolCaliper = 'assets/images/tools/vernier.jpg';
  static const String toolSquare = 'assets/images/tools/escuadra.jpg';
  static const String toolLevel = 'assets/images/tools/nivel.jpg';
  
  // Videos de inducción
  static const String videoWelcome = 'assets/videos/induction/bienvenida.mp4';
  static const String videoSafety = 'assets/videos/induction/seguridad.mp4';
  static const String videoTools = 'assets/videos/induction/herramientas.mp4';
  static const String videoEmergency = 'assets/videos/induction/emergencias.mp4';
  static const String videoWorkshopRules = 'assets/videos/induction/normas_taller.mp4';
  
  // Imágenes de zonas del taller
  static const String zoneLaserCut = 'assets/images/zones/corte_laser.jpg';
  static const String zone3DPrint = 'assets/images/zones/impresion_3d.jpg';
  static const String zoneWoodwork = 'assets/images/zones/carpinteria.jpg';
  static const String zoneMetalwork = 'assets/images/zones/metalurgia.jpg';
  static const String zonePainting = 'assets/images/zones/pintura.jpg';
  static const String zoneGeneral = 'assets/images/zones/area_general.jpg';
  
  // Imágenes ilustrativas
  static const String illustrationEmpty = 'assets/images/illustrations/empty_state.png';
  static const String illustrationError = 'assets/images/illustrations/error_state.png';
  static const String illustrationSuccess = 'assets/images/illustrations/success_state.png';
  static const String illustrationLoading = 'assets/images/illustrations/loading_state.png';
  
  // Íconos de estado
  static const String iconSuccess = 'assets/icons/success.png';
  static const String iconWarning = 'assets/icons/warning.png';
  static const String iconError = 'assets/icons/error.png';
  static const String iconInfo = 'assets/icons/info.png';
  
  // Método helper para obtener la imagen de una herramienta por ID
  static String getToolImage(String toolId) {
    final Map<String, String> toolImages = {
      'martillo': toolHammer,
      'destornillador_phillips': toolScrewdriver,
      'llave_inglesa': toolWrench,
      'alicates': toolPliers,
      'serrucho': toolHandsaw,
      'formones': toolChisel,
      'limas': toolFileSet,
      'prensas': toolClamps,
      'taladro': toolDrill,
      'sierra_circular': toolCircularSaw,
      'caladora': toolJigsaw,
      'lijadora': toolSander,
      'fresadora': toolRouter,
      'amoladora_angular': toolAngleGrinder,
      'pistola_calor': toolHeatGun,
      'cautin': toolSolderingIron,
      'regla': toolRuler,
      'cinta_metrica': toolTapemeasure,
      'vernier': toolCaliper,
      'escuadra': toolSquare,
      'nivel': toolLevel,
    };
    
    return toolImages[toolId] ?? illustrationEmpty;
  }
  
  // Método helper para obtener la imagen de una zona
  static String getZoneImage(String zoneId) {
    final Map<String, String> zoneImages = {
      'corte_laser': zoneLaserCut,
      'impresion_3d': zone3DPrint,
      'carpinteria': zoneWoodwork,
      'metalurgia': zoneMetalwork,
      'pintura': zonePainting,
      'area_general': zoneGeneral,
    };
    
    return zoneImages[zoneId] ?? zoneGeneral;
  }
}