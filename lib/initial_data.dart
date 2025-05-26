import 'app/data/providers/local_storage_provider.dart';
import 'app/data/models/user_model.dart';
import 'app/data/models/tool_model.dart';
import 'app/data/models/notification_model.dart';
import 'app/core/utils/constants.dart';
import 'app/core/values/assets.dart';

/// Clase para cargar datos iniciales en la aplicación
class InitialData {
  static final LocalStorageProvider _storage = LocalStorageProvider();
  
  /// Cargar todos los datos iniciales
  static Future<void> loadInitialData() async {
    try {
      // Inicializar el almacenamiento
      await _storage.init();
      
      // Cargar solo si es la primera vez
      if (_storage.isFirstTime()) {
        await loadUsers();
        await loadTools();
        await loadInitialNotifications();
        
        // Marcar que ya no es la primera vez
        await _storage.setNotFirstTime();
        
        print('✅ Datos iniciales cargados exitosamente');
      } else {
        print('ℹ️ Datos ya existentes, omitiendo carga inicial');
      }
    } catch (e) {
      print('❌ Error cargando datos iniciales: $e');
      // Continuar sin datos iniciales
    }
  }
  
  /// Cargar usuarios predefinidos
  static Future<void> loadUsers() async {
    final users = [
      // Administrador
      UserModel.create(
        id: 'admin',
        fullName: 'admin',
        role: UserRole.admin,
        plainPassword: 'admin',
        email: 'admin@url.edu.gt',
      ).copyWith(hasCompletedInduction: true),
      
      // Estudiantes predefinidos
      UserModel.create(
        id: '1159925',
        fullName: 'Emily Sophia Cruz Coronado',
        role: UserRole.estudiante,
        plainPassword: '1159925',
        email: 'emily.cruz@url.edu.gt',
      ),
      
      UserModel.create(
        id: '1010025',
        fullName: 'Eileen Mariana Canté Monzón',
        role: UserRole.estudiante,
        plainPassword: '1010025',
        email: 'eileen.cante@url.edu.gt',
      ),
      
      // Docente de ejemplo
      UserModel.create(
        id: '2001001',
        fullName: 'María José González Rodríguez',
        role: UserRole.docente,
        plainPassword: '2001001',
        email: 'maria.gonzalez@url.edu.gt',
      ).copyWith(hasCompletedInduction: true),
      
      // Auxiliar de taller
      UserModel.create(
        id: '3001001',
        fullName: 'Carlos Alberto Méndez López',
        role: UserRole.auxiliar,
        plainPassword: '3001001',
        email: 'carlos.mendez@url.edu.gt',
      ).copyWith(hasCompletedInduction: true),
    ];
    
    final usersData = users.map((user) => user.toMap()).toList();
    await _storage.saveUsers(usersData);
    
    print('👥 ${users.length} usuarios cargados');
  }
  
  /// Cargar catálogo de herramientas
  static Future<void> loadTools() async {
    final tools = [
      // Herramientas Manuales
      ToolModel(
        id: 'martillo',
        name: 'Martillo de Carpintero',
        description: 'Martillo con mango de madera para trabajos de carpintería general. Peso de 16 oz, ideal para clavado y extracción de clavos.',
        category: ToolCategory.manuales,
        imagePath: Assets.toolHammer,
        safetyInstructions: 'Usar siempre gafas de seguridad. Verificar que el mango esté bien fijo. Golpear siempre de frente, nunca de lado. Mantener el área de trabajo despejada.',
        maintenanceInfo: 'Limpiar después de cada uso. Revisar el mango regularmente en busca de grietas. Almacenar en lugar seco para evitar oxidación.',
        workshopZone: 'Área de Carpintería',
        tags: ['carpintería', 'construcción', 'clavos'],
      ),
      
      ToolModel(
        id: 'destornillador_phillips',
        name: 'Destornillador Phillips',
        description: 'Set de destornilladores Phillips de diferentes tamaños (#1, #2, #3). Mango ergonómico antideslizante para mejor agarre.',
        category: ToolCategory.manuales,
        imagePath: Assets.toolScrewdriver,
        safetyInstructions: 'Usar el tamaño correcto para cada tornillo. No usar como palanca. Mantener la punta en buen estado para evitar que se resbale.',
        maintenanceInfo: 'Limpiar las puntas regularmente. Verificar que no estén desgastadas o dañadas. Almacenar en lugar seco.',
        workshopZone: 'Área General',
        tags: ['tornillos', 'ensamble', 'phillips'],
      ),
      
      ToolModel(
        id: 'llave_inglesa',
        name: 'Llave Inglesa Ajustable',
        description: 'Llave inglesa de 10 pulgadas con apertura ajustable. Construcción en acero al cromo-vanadio para mayor durabilidad.',
        category: ToolCategory.manuales,
        imagePath: Assets.toolWrench,
        safetyInstructions: 'Ajustar firmemente antes de aplicar fuerza. Tirar hacia usted, no empujar. Verificar que esté completamente cerrada en la tuerca.',
        maintenanceInfo: 'Limpiar y aceitar el mecanismo de ajuste regularmente. Verificar que las mordazas estén en buen estado.',
        workshopZone: 'Área de Metalurgia',
        tags: ['tuercas', 'pernos', 'ajustable'],
      ),
      
      ToolModel(
        id: 'alicates',
        name: 'Alicates Universales',
        description: 'Alicates universales de 8 pulgadas con mango aislado. Incluye cortador de alambre y superficie de agarre estriada.',
        category: ToolCategory.manuales,
        imagePath: Assets.toolPliers,
        safetyInstructions: 'No usar para cortar materiales más duros que el alambre. Verificar el aislamiento del mango si se trabaja cerca de electricidad.',
        maintenanceInfo: 'Limpiar las articulaciones regularmente. Aceitar si es necesario. Verificar el filo del cortador.',
        workshopZone: 'Área General',
        tags: ['alambre', 'agarre', 'corte'],
      ),
      
      ToolModel(
        id: 'serrucho',
        name: 'Serrucho de Carpintero',
        description: 'Serrucho tradicional de 20 pulgadas con dientes endurecidos. Mango de madera ergonómico para cortes precisos.',
        category: ToolCategory.manuales,
        imagePath: Assets.toolHandsaw,
        safetyInstructions: 'Mantener los dedos alejados de la línea de corte. Asegurar la pieza antes de cortar. Usar movimientos largos y uniformes.',
        maintenanceInfo: 'Limpiar la hoja después del uso. Mantener los dientes afilados. Almacenar protegiendo los dientes.',
        workshopZone: 'Área de Carpintería',
        tags: ['madera', 'corte', 'carpintería'],
      ),
      
      ToolModel(
        id: 'formones',
        name: 'Set de Formones',
        description: 'Set de 4 formones de diferentes anchos (6mm, 12mm, 18mm, 25mm). Hojas de acero al carbono con mango de madera.',
        category: ToolCategory.manuales,
        imagePath: Assets.toolChisel,
        safetyInstructions: 'Mantener las manos detrás del filo. Usar martillo de madera o mazo. Trabajar alejándose del cuerpo.',
        maintenanceInfo: 'Mantener el filo afilado. Proteger las hojas cuando no se usen. Aceitar ocasionalmente.',
        workshopZone: 'Área de Carpintería',
        tags: ['tallado', 'madera', 'precisión'],
      ),
      
      ToolModel(
        id: 'limas',
        name: 'Set de Limas',
        description: 'Set de limas de diferentes granos y formas: plana, redonda, triangular. Para trabajo en metal y madera.',
        category: ToolCategory.manuales,
        imagePath: Assets.toolFileSet,
        safetyInstructions: 'Usar siempre con mango. Trabajar en una sola dirección. Usar gafas de protección.',
        maintenanceInfo: 'Limpiar con cepillo de alambre. Almacenar separadas para evitar daños. Mantener secas.',
        workshopZone: 'Área de Metalurgia',
        tags: ['acabado', 'metal', 'desbaste'],
      ),
      
      ToolModel(
        id: 'prensas',
        name: 'Prensas Tipo C',
        description: 'Set de prensas tipo C de diferentes tamaños (4", 6", 8"). Ideales para sujetar piezas durante el trabajo.',
        category: ToolCategory.manuales,
        imagePath: Assets.toolClamps,
        safetyInstructions: 'No sobre-apretar. Verificar que la pieza esté bien posicionada. Usar protectores si es necesario.',
        maintenanceInfo: 'Limpiar las roscas regularmente. Aceitar los mecanismos. Verificar que no haya deformaciones.',
        workshopZone: 'Área General',
        tags: ['sujeción', 'fijación', 'prensa'],
      ),
      
      // Herramientas Eléctricas
      ToolModel(
        id: 'taladro',
        name: 'Taladro Eléctrico',
        description: 'Taladro eléctrico de 1/2" con velocidad variable y reversa. Incluye set básico de brocas para madera y metal.',
        category: ToolCategory.electricas,
        imagePath: Assets.toolDrill,
        safetyInstructions: 'Usar gafas y guantes de seguridad. Asegurar la pieza antes de perforar. Verificar que no haya cables eléctricos en el área.',
        maintenanceInfo: 'Limpiar después de cada uso. Verificar el estado del cable eléctrico. Mantener las brocas afiladas.',
        workshopZone: 'Área General',
        tags: ['perforación', 'eléctrico', 'brocas'],
      ),
      
      ToolModel(
        id: 'sierra_circular',
        name: 'Sierra Circular',
        description: 'Sierra circular de 7-1/4" con motor de 15 amperios. Ideal para cortes rectos en madera y materiales similares.',
        category: ToolCategory.electricas,
        imagePath: Assets.toolCircularSaw,
        safetyInstructions: 'OBLIGATORIO: Capacitación previa. Usar gafas, guantes y protección auditiva. Verificar la profundidad de corte.',
        maintenanceInfo: 'Mantener la hoja afilada y limpia. Verificar todas las guardas de seguridad. Revisar el cable eléctrico.',
        workshopZone: 'Área de Carpintería',
        tags: ['corte', 'madera', 'circular'],
        status: ToolStatus.mantenimiento,
      ),
      
      ToolModel(
        id: 'caladora',
        name: 'Caladora',
        description: 'Caladora con velocidad variable y movimiento orbital. Incluye hojas para madera, metal y plástico.',
        category: ToolCategory.electricas,
        imagePath: Assets.toolJigsaw,
        safetyInstructions: 'Asegurar la pieza firmemente. Usar la hoja correcta para el material. Mantener la base apoyada.',
        maintenanceInfo: 'Cambiar las hojas cuando estén desafiladas. Limpiar el motor de aserrín. Verificar el mecanismo orbital.',
        workshopZone: 'Área de Carpintería',
        tags: ['corte', 'curvas', 'precisión'],
      ),
      
      ToolModel(
        id: 'lijadora',
        name: 'Lijadora Orbital',
        description: 'Lijadora orbital de palma con sistema de recolección de polvo. Ideal para acabados finos.',
        category: ToolCategory.electricas,
        imagePath: Assets.toolSander,
        safetyInstructions: 'Usar mascarilla antipolvo. Cambiar lijas regularmente. No presionar excesivamente.',
        maintenanceInfo: 'Vaciar el depósito de polvo frecuentemente. Cambiar lijas desgastadas. Limpiar las perforaciones.',
        workshopZone: 'Área de Carpintería',
        tags: ['lijado', 'acabado', 'orbital'],
      ),
      
      ToolModel(
        id: 'fresadora',
        name: 'Fresadora de Mano',
        description: 'Fresadora de mano de 1/4" con control de velocidad variable. Incluye set básico de fresas.',
        category: ToolCategory.electricas,
        imagePath: Assets.toolRouter,
        safetyInstructions: 'REQUIERE CAPACITACIÓN. Usar protección facial completa. Sujetar firmemente con ambas manos.',
        maintenanceInfo: 'Mantener las fresas afiladas. Limpiar las ranuras de ventilación. Verificar el mecanismo de ajuste.',
        workshopZone: 'Área de Carpintería',
        tags: ['fresado', 'molduras', 'ranuras'],
      ),
      
      ToolModel(
        id: 'amoladora_angular',
        name: 'Amoladora Angular',
        description: 'Amoladora angular de 4-1/2" con motor de 7.5 amperios. Para corte y desbaste de metal.',
        category: ToolCategory.electricas,
        imagePath: Assets.toolAngleGrinder,
        safetyInstructions: 'OBLIGATORIO: Capacitación y EPP completo. Verificar la guarda de seguridad. Nunca usar discos dañados.',
        maintenanceInfo: 'Cambiar discos cuando estén desgastados. Limpiar las ranuras de ventilación. Verificar el interruptor.',
        workshopZone: 'Área de Metalurgia',
        tags: ['desbaste', 'corte', 'metal'],
      ),
      
      ToolModel(
        id: 'pistola_calor',
        name: 'Pistola de Calor',
        description: 'Pistola de calor con control de temperatura variable (300°-1000°F). Para remoción de pintura y termo-contracción.',
        category: ToolCategory.electricas,
        imagePath: Assets.toolHeatGun,
        safetyInstructions: 'Nunca dirigir hacia personas. Usar en área ventilada. Permitir enfriamiento antes de guardar.',
        maintenanceInfo: 'Limpiar las rejillas de ventilación. Verificar el cable eléctrico. No usar en ambientes húmedos.',
        workshopZone: 'Área de Pintura',
        tags: ['calor', 'pintura', 'secado'],
      ),
      
      ToolModel(
        id: 'cautin',
        name: 'Cautín Eléctrico',
        description: 'Cautín de soldadura de 40W con punta intercambiable. Incluye soporte y esponja de limpieza.',
        category: ToolCategory.electricas,
        imagePath: Assets.toolSolderingIron,
        safetyInstructions: 'Usar en área ventilada. No tocar la punta caliente. Usar soporte cuando no se use.',
        maintenanceInfo: 'Limpiar la punta regularmente. Verificar el cable. Almacenar con la punta protegida.',
        workshopZone: 'Área General',
        tags: ['soldadura', 'electrónica', 'estaño'],
      ),
      
      // Instrumentos de Medición
      ToolModel(
        id: 'regla',
        name: 'Regla Metálica',
        description: 'Regla de acero inoxidable de 30cm con graduaciones en milímetros y pulgadas. Bordes biselados.',
        category: ToolCategory.medicion,
        imagePath: Assets.toolRuler,
        safetyInstructions: 'Cuidado con los bordes afilados. Mantener limpia para lecturas precisas.',
        maintenanceInfo: 'Limpiar con paño seco. Verificar que las graduaciones sean legibles. Almacenar plana.',
        workshopZone: 'Área General',
        tags: ['medición', 'precisión', 'acero'],
      ),
      
      ToolModel(
        id: 'cinta_metrica',
        name: 'Cinta Métrica',
        description: 'Cinta métrica de 5 metros con cinta de acero y graduaciones claras. Mecanismo de bloqueo automático.',
        category: ToolCategory.medicion,
        imagePath: Assets.toolTapemeasure,
        safetyInstructions: 'Permitir que la cinta se retraiga lentamente. No tirar bruscamente.',
        maintenanceInfo: 'Limpiar la cinta después del uso. Verificar el mecanismo de retracción. Proteger de la humedad.',
        workshopZone: 'Área General',
        tags: ['medición', 'distancia', 'métrica'],
      ),
      
      ToolModel(
        id: 'vernier',
        name: 'Vernier Digital',
        description: 'Calibrador vernier digital de 6" con precisión de 0.01mm. Display LCD y función de cambio mm/pulgadas.',
        category: ToolCategory.medicion,
        imagePath: Assets.toolCaliper,
        safetyInstructions: 'Manejar con cuidado. No forzar las mordazas. Limpiar antes y después del uso.',
        maintenanceInfo: 'Cambiar la batería regularmente. Calibrar periódicamente. Almacenar en estuche protector.',
        workshopZone: 'Área General',
        tags: ['precisión', 'digital', 'calibración'],
      ),
      
      ToolModel(
        id: 'escuadra',
        name: 'Escuadra de Carpintero',
        description: 'Escuadra de acero de 12" con ángulo garantizado de 90°. Graduaciones en ambos brazos.',
        category: ToolCategory.medicion,
        imagePath: Assets.toolSquare,
        safetyInstructions: 'Verificar la precisión regularmente. Manejar con cuidado para mantener la escuadra.',
        maintenanceInfo: 'Mantener limpia y seca. Verificar que mantenga el ángulo de 90°. Proteger de golpes.',
        workshopZone: 'Área de Carpintería',
        tags: ['ángulo', 'carpintería', '90 grados'],
      ),
      
      ToolModel(
        id: 'nivel',
        name: 'Nivel de Burbuja',
        description: 'Nivel de aluminio de 24" con 3 burbujas (horizontal, vertical y 45°). Precisión garantizada.',
        category: ToolCategory.medicion,
        imagePath: Assets.toolLevel,
        safetyInstructions: 'Manejar con cuidado. Verificar la calibración antes de usar en trabajos críticos.',
        maintenanceInfo: 'Limpiar las burbujas regularmente. Verificar la precisión. Almacenar en posición horizontal.',
        workshopZone: 'Área de Carpintería',
        tags: ['nivel', 'horizontal', 'vertical'],
      ),
    ];
    
    final toolsData = tools.map((tool) => tool.toMap()).toList();
    await _storage.saveTools(toolsData);
    
    print('🔧 ${tools.length} herramientas cargadas');
  }
  
  /// Cargar notificaciones iniciales
  static Future<void> loadInitialNotifications() async {
    final notifications = [
      NotificationModel.systemUpdate(
        message: 'Bienvenido a TallerURL v1.0.0. Sistema de gestión de talleres ahora disponible.',
      ),
      
      NotificationModel.scheduleChange(
        title: 'Horario Actualizado',
        message: 'Los horarios del taller han sido actualizados. Revisa la sección de horarios para más información.',
      ),
      
      NotificationModel.create(
        title: 'Completa tu Inducción',
        message: 'Recuerda completar los videos de inducción para acceder a todas las funciones del taller.',
        type: NotificationType.general,
        priority: NotificationPriority.high,
      ),
    ];
    
    final notificationsData = notifications.map((notif) => notif.toMap()).toList();
    await _storage.saveNotifications(notificationsData);
    
    print('📢 ${notifications.length} notificaciones iniciales cargadas');
  }
  
  /// Resetear todos los datos (para testing)
  static Future<void> resetAllData() async {
    try {
      await _storage.clearAll();
      await loadInitialData();
      print('🔄 Datos reseteados y recargados');
    } catch (e) {
      print('❌ Error reseteando datos: $e');
    }
  }
  
  /// Verificar integridad de los datos
  static Future<bool> verifyDataIntegrity() async {
    try {
      final users = _storage.getUsers();
      final tools = _storage.getTools();
      
      bool hasAdmin = users.any((user) => user['role'] == 'admin');
      bool hasTools = tools.isNotEmpty;
      
      if (!hasAdmin || !hasTools) {
        print('⚠️ Datos incompletos detectados, recargando...');
        await loadInitialData();
      }
      
      return true;
    } catch (e) {
      print('❌ Error verificando integridad: $e');
      return false;
    }
  }
}