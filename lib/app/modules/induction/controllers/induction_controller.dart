import 'package:get/get.dart';
import '../../../data/providers/local_storage_provider.dart';
import '../../../core/utils/storage_keys.dart';
import '../../../core/values/assets.dart';

/// Modelo para videos de inducción
class InductionVideo {
  final String id;
  final String title;
  final String description;
  final String videoPath;
  final Duration duration;
  final bool isRequired;
  final int order;
  final String category;

  const InductionVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.videoPath,
    required this.duration,
    required this.isRequired,
    required this.order,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoPath': videoPath,
      'duration': duration.inSeconds,
      'isRequired': isRequired,
      'order': order,
      'category': category,
    };
  }

  factory InductionVideo.fromMap(Map<String, dynamic> map) {
    return InductionVideo(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      videoPath: map['videoPath'] ?? '',
      duration: Duration(seconds: map['duration'] ?? 0),
      isRequired: map['isRequired'] ?? false,
      order: map['order'] ?? 0,
      category: map['category'] ?? '',
    );
  }
}

/// Controlador para el módulo de inducción
class InductionController extends GetxController {
  final LocalStorageProvider _storage;

  InductionController(this._storage);

  // Estado reactivo
  final RxList<InductionVideo> _videos = <InductionVideo>[].obs;
  final RxSet<String> _watchedVideos = <String>{}.obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedCategory = 'all'.obs;

  // Getters
  List<InductionVideo> get videos => _videos;
  Set<String> get watchedVideos => _watchedVideos;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;

  // Videos filtrados
  List<InductionVideo> get filteredVideos {
    var filtered =
        _videos.where((video) {
          final matchesSearch =
              searchQuery.isEmpty ||
              video.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              video.description.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );

          final matchesCategory =
              selectedCategory == 'all' || video.category == selectedCategory;

          return matchesSearch && matchesCategory;
        }).toList();

    // Ordenar por orden y por requeridos primero
    filtered.sort((a, b) {
      if (a.isRequired && !b.isRequired) return -1;
      if (!a.isRequired && b.isRequired) return 1;
      return a.order.compareTo(b.order);
    });

    return filtered;
  }

  // Videos requeridos
  List<InductionVideo> get requiredVideos {
    return _videos.where((video) => video.isRequired).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  // Videos opcionales
  List<InductionVideo> get optionalVideos {
    return _videos.where((video) => !video.isRequired).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  // Categorías disponibles
  List<String> get categories {
    final cats = <String>{'all'};
    cats.addAll(_videos.map((video) => video.category));
    return cats.toList();
  }

  // Progreso de inducción
  double get inductionProgress {
    if (requiredVideos.isEmpty) return 1.0;

    final watchedRequired =
        requiredVideos
            .where((video) => _watchedVideos.contains(video.id))
            .length;

    return watchedRequired / requiredVideos.length;
  }

  // ¿Inducción completada?
  bool get isInductionCompleted {
    return requiredVideos.every((video) => _watchedVideos.contains(video.id));
  }

  @override
  void onInit() {
    super.onInit();
    _loadInductionData();
  }

  /// Cargar datos de inducción
  Future<void> _loadInductionData() async {
    _isLoading.value = true;

    try {
      await _loadWatchedVideos();
      await _loadVideos();
    } catch (e) {
      print('Error cargando datos de inducción: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Cargar videos vistos desde storage
  Future<void> _loadWatchedVideos() async {
    try {
      final watchedList = _storage.getWatchedVideos();
      _watchedVideos.assignAll(watchedList.toSet());
    } catch (e) {
      print('Error cargando videos vistos: $e');
    }
  }

  /// Cargar lista de videos de inducción
  Future<void> _loadVideos() async {
    try {
      final videosList = _getDefaultVideos();
      _videos.assignAll(videosList);
    } catch (e) {
      print('Error cargando videos: $e');
    }
  }

  /// Videos predefinidos del sistema
  List<InductionVideo> _getDefaultVideos() {
    return [
      const InductionVideo(
        id: 'welcome',
        title: 'Bienvenida al Taller',
        description:
            'Video introductorio sobre el uso del taller de diseño industrial. Conoce las normas básicas y la filosofía de trabajo colaborativo.',
        videoPath: Assets.videoWelcome,
        duration: Duration(minutes: 8, seconds: 30),
        isRequired: true,
        order: 1,
        category: 'básico',
      ),

      const InductionVideo(
        id: 'safety',
        title: 'Normas de Seguridad',
        description:
            'Normas fundamentales de seguridad en el taller. Uso correcto del equipo de protección personal y protocolo de emergencias.',
        videoPath: Assets.videoSafety,
        duration: Duration(minutes: 12, seconds: 15),
        isRequired: true,
        order: 2,
        category: 'seguridad',
      ),

      const InductionVideo(
        id: 'tools',
        title: 'Uso de Herramientas',
        description:
            'Introducción al catálogo de herramientas disponibles. Instrucciones básicas de uso y cuidado de las herramientas manuales y eléctricas.',
        videoPath: Assets.videoTools,
        duration: Duration(minutes: 15, seconds: 45),
        isRequired: true,
        order: 3,
        category: 'herramientas',
      ),

      const InductionVideo(
        id: 'emergency',
        title: 'Procedimientos de Emergencia',
        description:
            'Qué hacer en caso de emergencia. Ubicación de salidas, extintores, botiquín de primeros auxilios y contactos importantes.',
        videoPath: Assets.videoEmergency,
        duration: Duration(minutes: 6, seconds: 20),
        isRequired: true,
        order: 4,
        category: 'seguridad',
      ),

      const InductionVideo(
        id: 'workshop_rules',
        title: 'Normas del Taller',
        description:
            'Reglas de convivencia, horarios, sistema de reservas, limpieza y mantenimiento del espacio de trabajo.',
        videoPath: Assets.videoWorkshopRules,
        duration: Duration(minutes: 10, seconds: 0),
        isRequired: false,
        order: 5,
        category: 'normas',
      ),
    ];
  }

  /// Marcar video como visto
  Future<void> markVideoAsWatched(String videoId) async {
    try {
      _watchedVideos.add(videoId);
      await _saveWatchedVideos();

      // Actualizar estado de inducción del usuario si se completó
      if (isInductionCompleted) {
        await _updateUserInductionStatus();
      }

      Get.snackbar(
        'Video Completado',
        'Has completado este video de inducción',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error marcando video como visto: $e');
    }
  }

  /// Guardar videos vistos en storage
  Future<void> _saveWatchedVideos() async {
    try {
      await _storage.saveWatchedVideos(_watchedVideos.toList());
    } catch (e) {
      print('Error guardando videos vistos: $e');
    }
  }

  /// Actualizar estado de inducción del usuario
  Future<void> _updateUserInductionStatus() async {
    try {
      final currentUser = _storage.getCurrentUser();
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(hasCompletedInduction: true);
        await _storage.updateCurrentUser(updatedUser);

        Get.snackbar(
          '¡Felicitaciones!',
          'Has completado la inducción al taller',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Error actualizando estado de inducción: $e');
    }
  }

  /// Actualizar búsqueda
  void updateSearch(String query) {
    _searchQuery.value = query;
  }

  /// Limpiar búsqueda
  void clearSearch() {
    _searchQuery.value = '';
  }

  /// Cambiar categoría seleccionada
  void selectCategory(String category) {
    _selectedCategory.value = category;
  }

  /// Verificar si un video fue visto
  bool isVideoWatched(String videoId) {
    return _watchedVideos.contains(videoId);
  }

  /// Obtener video por ID
  InductionVideo? getVideoById(String videoId) {
    try {
      return _videos.firstWhere((video) => video.id == videoId);
    } catch (e) {
      return null;
    }
  }

  /// Refrescar datos
  Future<void> refresh() async {
    await _loadInductionData();
  }

  /// Resetear progreso de inducción (solo para testing)
  Future<void> resetInductionProgress() async {
    try {
      _watchedVideos.clear();
      await _storage.clearWatchedVideos();

      Get.snackbar(
        'Progreso Reseteado',
        'El progreso de inducción ha sido reiniciado',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error reseteando progreso: $e');
    }
  }
}
