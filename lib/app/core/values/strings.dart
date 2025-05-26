/// Textos utilizados en toda la aplicación (fácil traducción)
class Strings {
  // Información general
  static const String appName = 'TallerURL';
  static const String universityName = 'Universidad Rafael Landívar';
  static const String facultyName = 'Facultad de Diseño Industrial';
  static const String tagline = 'Sistema de Gestión de Talleres';
  
  // Pantalla de login
  static const String welcomeTitle = 'Bienvenido a TallerURL';
  static const String welcomeSubtitle = 'Sistema de Gestión de Talleres de Diseño Industrial';
  static const String loginTitle = 'Iniciar Sesión';
  static const String usernameLabel = 'Nombre Completo';
  static const String usernameHint = 'Ingresa tu nombre completo';
  static const String passwordLabel = 'Carné Universitario';
  static const String passwordHint = 'Ingresa tu carné';
  static const String loginButton = 'Ingresar';
  static const String loginError = 'Usuario o contraseña incorrectos';
  static const String emptyFieldsError = 'Por favor completa todos los campos';
  
  // Pantalla principal
  static const String homeTitle = 'Inicio';
  static const String welcomeBack = 'Bienvenido de nuevo';
  static const String quickActions = 'Acciones Rápidas';
  
  // Menú principal
  static const String menuTools = 'Catálogo de Herramientas';
  static const String menuToolsDesc = 'Explora las herramientas disponibles';
  static const String menuReservations = 'Reservar Espacio';
  static const String menuReservationsDesc = 'Reserva espacios del taller';
  static const String menuMyReservations = 'Mis Reservaciones';
  static const String menuMyReservationsDesc = 'Ver mis reservaciones activas';
  static const String menuSchedule = 'Horarios';
  static const String menuScheduleDesc = 'Horarios de funcionamiento';
  static const String menuInduction = 'Videos de Inducción';
  static const String menuInductionDesc = 'Videos informativos y de seguridad';
  static const String menuNotifications = 'Notificaciones';
  static const String menuNotificationsDesc = 'Ver notificaciones importantes';
  static const String menuAdmin = 'Panel de Administración';
  static const String menuAdminDesc = 'Gestión de usuarios y sistema';
  
  // Catálogo de herramientas
  static const String toolsTitle = 'Catálogo de Herramientas';
  static const String toolsSearchHint = 'Buscar herramientas...';
  static const String toolsFilterAll = 'Todas';
  static const String toolsFilterManual = 'Manuales';
  static const String toolsFilterElectric = 'Eléctricas';
  static const String toolsFilterMeasurement = 'Medición';
  static const String toolsFilterSafety = 'Seguridad';
  static const String toolDetailTitle = 'Detalles de Herramienta';
  static const String toolDescription = 'Descripción';
  static const String toolSafetyInstructions = 'Instrucciones de Seguridad';
  static const String toolMaintenanceInfo = 'Cuidados y Mantenimiento';
  static const String toolLocation = 'Ubicación en el Taller';
  static const String toolStatus = 'Estado';
  static const String toolsEmptyState = 'No se encontraron herramientas';
  
  // Reservaciones
  static const String reservationsTitle = 'Reservar Espacio';
  static const String myReservationsTitle = 'Mis Reservaciones';
  static const String reservationFormTitle = 'Nueva Reservación';
  static const String selectDate = 'Seleccionar Fecha';
  static const String selectZone = 'Seleccionar Zona';
  static const String selectTimeSlot = 'Seleccionar Horario';
  static const String reservationPurpose = 'Propósito (Opcional)';
  static const String reservationPurposeHint = 'Describe brevemente tu proyecto';
  static const String confirmReservation = 'Confirmar Reservación';
  static const String cancelReservation = 'Cancelar Reservación';
  static const String reservationSuccess = 'Reservación creada exitosamente';
  static const String reservationError = 'Error al crear la reservación';
  static const String reservationCanceled = 'Reservación cancelada';
  static const String noReservations = 'No tienes reservaciones activas';
  static const String pastReservations = 'Reservaciones Pasadas';
  static const String upcomingReservations = 'Próximas Reservaciones';
  
  // Zonas del taller
  static const String zoneLaserCut = 'Corte Láser';
  static const String zone3DPrint = 'Impresión 3D';
  static const String zoneWoodwork = 'Carpintería';
  static const String zoneMetalwork = 'Metalurgia';
  static const String zonePainting = 'Pintura';
  static const String zoneGeneral = 'Área General';
  
  // Horarios
  static const String scheduleTitle = 'Horarios del Taller';
  static const String generalSchedule = 'Horario General';
  static const String mondayToFriday = 'Lunes a Viernes';
  static const String saturday = 'Sábado';
  static const String sunday = 'Domingo';
  static const String closed = 'Cerrado';
  static const String specialSchedules = 'Horarios Especiales';
  static const String holidaysSchedule = 'Días Festivos';
  static const String examPeriod = 'Período de Exámenes';
  
  // Videos de inducción
  static const String inductionTitle = 'Videos de Inducción';
  static const String inductionRequired = 'Videos Requeridos';
  static const String inductionOptional = 'Videos Opcionales';
  static const String videoWelcome = 'Bienvenida al Taller';
  static const String videoSafety = 'Normas de Seguridad';
  static const String videoTools = 'Uso de Herramientas';
  static const String videoEmergency = 'Procedimientos de Emergencia';
  static const String videoWorkshopRules = 'Normas del Taller';
  static const String videoCompleted = 'Video Completado';
  static const String markAsViewed = 'Marcar como Visto';
  
  // Notificaciones
  static const String notificationsTitle = 'Notificaciones';
  static const String noNotifications = 'No hay notificaciones nuevas';
  static const String markAllRead = 'Marcar Todas como Leídas';
  static const String notificationReservationReminder = 'Recordatorio de Reservación';
  static const String notificationScheduleChange = 'Cambio de Horario';
  static const String notificationSystemUpdate = 'Actualización del Sistema';
  
  // Panel de administración
  static const String adminTitle = 'Panel de Administración';
  static const String userManagement = 'Gestión de Usuarios';
  static const String createUser = 'Crear Usuario';
  static const String editUser = 'Editar Usuario';
  static const String deleteUser = 'Eliminar Usuario';
  static const String usersList = 'Lista de Usuarios';
  static const String userCreated = 'Usuario creado exitosamente';
  static const String userUpdated = 'Usuario actualizado exitosamente';
  static const String userDeleted = 'Usuario eliminado exitosamente';
  static const String confirmDeleteUser = '¿Estás seguro de eliminar este usuario?';
  
  // Roles de usuario
  static const String roleStudent = 'Estudiante';
  static const String roleTeacher = 'Docente';
  static const String roleAssistant = 'Auxiliar de Taller';
  static const String roleAdmin = 'Administrador';
  
  // Estados de reservación
  static const String statusActive = 'Activa';
  static const String statusCompleted = 'Completada';
  static const String statusCanceled = 'Cancelada';
  static const String statusNoShow = 'No se presentó';
  
  // Estados de herramientas
  static const String toolAvailable = 'Disponible';
  static const String toolMaintenance = 'En Mantenimiento';
  static const String toolUnavailable = 'No Disponible';
  static const String toolBorrowed = 'Prestada';
  
  // Formularios
  static const String save = 'Guardar';
  static const String cancel = 'Cancelar';
  static const String edit = 'Editar';
  static const String delete = 'Eliminar';
  static const String confirm = 'Confirmar';
  static const String back = 'Regresar';
  static const String next = 'Siguiente';
  static const String finish = 'Finalizar';
  static const String required = 'Campo requerido';
  static const String optional = 'Opcional';
  
  // Mensajes de error
  static const String errorGeneral = 'Ha ocurrido un error inesperado';
  static const String errorNetwork = 'Error de conexión';
  static const String errorNotFound = 'Elemento no encontrado';
  static const String errorUnauthorized = 'No tienes permisos para esta acción';
  static const String errorValidation = 'Por favor verifica los datos ingresados';
  
  // Mensajes de éxito
  static const String successSaved = 'Guardado exitosamente';
  static const String successDeleted = 'Eliminado exitosamente';
  static const String successUpdated = 'Actualizado exitosamente';
  
  // Botones de acción
  static const String retry = 'Reintentar';
  static const String close = 'Cerrar';
  static const String ok = 'Aceptar';
  static const String yes = 'Sí';
  static const String no = 'No';
  static const String logout = 'Cerrar Sesión';
  static const String profile = 'Perfil';
  static const String settings = 'Configuración';
  static const String help = 'Ayuda';
  static const String about = 'Acerca de';
  
  // Estados vacíos
  static const String emptyStateTitle = 'No hay elementos';
  static const String emptyStateMessage = 'Aún no hay información disponible';
  static const String emptyStateAction = 'Agregar Elemento';
  
  // Pantalla de carga
  static const String loading = 'Cargando...';
  static const String loadingData = 'Cargando datos...';
  static const String loadingPlease = 'Por favor espera...';
  
  // Días de la semana
  static const String monday = 'Lunes';
  static const String tuesday = 'Martes';
  static const String wednesday = 'Miércoles';
  static const String thursday = 'Jueves';
  static const String friday = 'Viernes';
  static const String saturdayShort = 'Sábado';
  static const String sundayShort = 'Domingo';
  
  // Meses
  static const String january = 'Enero';
  static const String february = 'Febrero';
  static const String march = 'Marzo';
  static const String april = 'Abril';
  static const String may = 'Mayo';
  static const String june = 'Junio';
  static const String july = 'Julio';
  static const String august = 'Agosto';
  static const String september = 'Septiembre';
  static const String october = 'Octubre';
  static const String november = 'Noviembre';
  static const String december = 'Diciembre';
}