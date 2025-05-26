# 🛠️ TallerURL - Sistema de Gestión de Talleres

**Universidad Rafael Landívar**  
*Facultad de Diseño Industrial*

## 📱 Descripción

TallerURL es una aplicación móvil MVP (Minimum Viable Product) desarrollada en Flutter para la gestión integral de los talleres de diseño industrial de la Universidad Rafael Landívar. La aplicación centraliza la información, mejora la comunicación y optimiza el acceso a los recursos del taller.

## 🎯 Problemática Identificada

- **Desorganización administrativa**: Ausencia de protocolos claros
- **Comunicación deficiente**: Estudiantes desconocen horarios y normas
- **Procesos informales**: Sistema de acceso improvisado
- **Inequidad**: Diferencias entre estudiantes nuevos y veteranos

## ✨ Funcionalidades Principales

### 👤 Sistema de Usuarios
- **Estudiantes**: Acceso completo a herramientas y reservaciones
- **Docentes**: Funciones de estudiante + supervisión
- **Auxiliares**: Gestión de talleres y reservaciones
- **Administradores**: Control total del sistema

### 🔧 Catálogo de Herramientas
- Listado completo con fotografías
- Categorización (manuales/eléctricas)
- Instrucciones de seguridad detalladas
- Información de mantenimiento
- Ubicación en el taller
- Sistema de búsqueda y filtros

### 📅 Sistema de Reservaciones
- Reserva de espacios específicos del taller
- Calendario visual interactivo
- Bloques de tiempo predefinidos
- Gestión de "Mis Reservaciones"
- Sin requerimiento de aprobación

### 🎥 Videos de Inducción
- Normas generales del taller
- Uso seguro de herramientas
- Procedimientos de emergencia
- Reproducción integrada
- Seguimiento de progreso

### 🕐 Horarios del Taller
- Horario general de operación
- Horarios específicos por zona
- Calendario de días no laborables
- Notificaciones de cambios

### 👥 Gestión de Usuarios (Admin)
- Crear, modificar y eliminar usuarios
- Asignación de roles
- Vista de lista completa
- Estadísticas de uso

## 🏗️ Arquitectura Técnica

### Framework y Tecnologías
- **Flutter**: Framework multiplataforma
- **GetX**: Gestión de estado y navegación
- **GetStorage**: Almacenamiento local
- **Dart**: Lenguaje de programación

### Patrones de Diseño
- **GetX Pattern**: Separación clara de responsabilidades
- **Repository Pattern**: Abstracción de datos
- **MVC**: Modelo-Vista-Controlador adaptado

### Estructura del Proyecto
```
lib/
├── app/
│   ├── core/           # Configuraciones globales
│   ├── data/           # Modelos y repositorios
│   ├── modules/        # Módulos funcionales
│   ├── routes/         # Navegación
│   └── widgets/        # Componentes compartidos
├── assets/             # Recursos multimedia
└── initial_data.dart   # Datos precargados
```

## 👥 Usuarios Predefinidos

### Estudiantes de Prueba
```
Usuario: Emily Sophia Cruz Coronado
Contraseña: 1159925

Usuario: Eileen Mariana Canté Monzón
Contraseña: 1010025
```

### Administrador
```
Usuario: admin
Contraseña: admin
```

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK (versión 3.7.0 o superior)
- Dart SDK
- Android Studio / VS Code
- Dispositivo Android o emulador

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/tu-repo/taller_url.git
cd taller_url
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar assets**
- Colocar imágenes de herramientas en `assets/images/tools/`
- Colocar videos de inducción en `assets/videos/induction/`
- Colocar logo de la universidad en `assets/images/logo_url.png`

4. **Ejecutar la aplicación**
```bash
flutter run
```

## 📱 Uso de la Aplicación

### Primera Ejecución
1. La aplicación carga datos iniciales automáticamente
2. Usar credenciales predefinidas para acceder
3. Completar videos de inducción (recomendado)

### Flujo Principal
1. **Login** → Ingresar credenciales
2. **Dashboard** → Vista general del sistema
3. **Navegar** → Usar menú para acceder a funciones
4. **Reservar** → Seleccionar fecha, zona y horario
5. **Consultar** → Ver catálogo de herramientas

## 🎨 Diseño Visual

### Paleta de Colores
- **Azul Principal**: #003DA5
- **Verde Secundario**: #7BA428
- **Naranja Acento**: #F39200
- **Gris Neutro**: #6C757D

### Principios de Diseño
- Interfaz limpia y minimalista
- Navegación intuitiva
- Iconografía clara y consistente
- Tipografía legible
- Compatible con diferentes tamaños de pantalla

## 📊 Datos y Almacenamiento

### Almacenamiento Local
- **GetStorage**: Persistencia de datos sin internet
- **Formato JSON**: Estructura de datos consistente
- **Backup automático**: Protección de información
- **Datos iniciales**: Catálogo precargado

### Modelos de Datos
- **UserModel**: Información de usuarios
- **ToolModel**: Catálogo de herramientas
- **ReservationModel**: Sistema de reservas
- **NotificationModel**: Gestión de notificaciones

## 🔒 Seguridad y Permisos

### Seguridad de Datos
- Contraseñas hasheadas (SHA-256)
- Validación de roles y permisos
- Sesiones con tiempo de expiración
- Datos encriptados localmente

### Permisos de la App
- Almacenamiento local
- Notificaciones locales
- Reproducción de multimedia

## 🔮 Roadmap y Futuras Mejoras

### Fase 2 - Conexión a la Nube
- [ ] Migración a Firebase
- [ ] Sincronización en tiempo real
- [ ] Backup en la nube
- [ ] Autenticación universitaria

### Fase 3 - Funcionalidades Avanzadas
- [ ] Sistema de préstamo QR
- [ ] Estadísticas de uso
- [ ] Gamificación
- [ ] Chat de soporte
- [ ] Notificaciones push

### Fase 4 - Integraciones
- [ ] API universitaria
- [ ] Calendario académico
- [ ] Múltiples talleres
- [ ] Reportes avanzados

## 🐛 Resolución de Problemas

### Problemas Comunes

**Error al cargar datos iniciales**
- Reiniciar la aplicación
- Limpiar datos de la app
- Verificar espacio de almacenamiento

**Problemas de login**
- Verificar credenciales exactas
- Revisar conexión de red (opcional)
- Usar botones de acceso rápido (modo desarrollo)

**Videos no reproducen**
- Verificar que los archivos estén en assets/videos/
- Reiniciar la aplicación
- Comprobar formato de video compatible

## 📞 Soporte y Contacto

**Desarrollado para:**  
Universidad Rafael Landívar  
Facultad de Diseño Industrial

**Equipo de Desarrollo:**  
Estudiantes de Diseño Industrial URL

**Curso:**  
Service Design

**Versión Actual:** 1.0.0 MVP

## 📄 Licencia

Este proyecto es desarrollado con fines académicos para la Universidad Rafael Landívar. Todos los derechos reservados.

---

*Última actualización: Mayo 2025*
*Desarrollado con ❤️ para la comunidad URL*