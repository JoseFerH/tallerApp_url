/// Validadores para formularios de la aplicación
class Validators {
  /// Validar que un campo no esté vacío
  static String? required(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  /// Validar email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Permitir vacío para campos opcionales
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Ingresa un email válido';
    }

    return null;
  }

  /// Validar carné universitario (7 dígitos)
  static String? carne(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El carné es requerido';
    }

    if (value.length != 7) {
      return 'El carné debe tener 7 dígitos';
    }

    if (!RegExp(r'^\d{7}$').hasMatch(value)) {
      return 'El carné debe contener solo números';
    }

    return null;
  }

  /// Validar nombre completo
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre completo es requerido';
    }

    if (value.trim().length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }

    if (!value.trim().contains(' ')) {
      return 'Debe incluir al menos nombre y apellido';
    }

    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value.trim())) {
      return 'El nombre solo puede contener letras y espacios';
    }

    return null;
  }

  /// Validar contraseña
  static String? password(String? value, {int minLength = 4}) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (value.length < minLength) {
      return 'La contraseña debe tener al menos $minLength caracteres';
    }

    return null;
  }

  /// Validar teléfono guatemalteco
  static String? guatemalaPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Permitir vacío para campos opcionales
    }

    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!RegExp(r'^(\+502)?[0-9]{8}$').hasMatch(cleanPhone)) {
      return 'Teléfono inválido (debe tener 8 dígitos)';
    }

    return null;
  }

  /// Validar longitud mínima
  static String? minLength(
    String? value,
    int min, {
    String fieldName = 'Campo',
  }) {
    if (value == null || value.isEmpty) {
      return null; // Permitir vacío si no es requerido
    }

    if (value.length < min) {
      return '$fieldName debe tener al menos $min caracteres';
    }

    return null;
  }

  /// Validar longitud máxima
  static String? maxLength(
    String? value,
    int max, {
    String fieldName = 'Campo',
  }) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > max) {
      return '$fieldName no puede tener más de $max caracteres';
    }

    return null;
  }

  /// Validar rango de longitud
  static String? lengthRange(
    String? value,
    int min,
    int max, {
    String fieldName = 'Campo',
  }) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length < min || value.length > max) {
      return '$fieldName debe tener entre $min y $max caracteres';
    }

    return null;
  }

  /// Validar solo números
  static String? numbersOnly(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return '$fieldName debe contener solo números';
    }

    return null;
  }

  /// Validar solo letras
  static String? lettersOnly(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
      return '$fieldName debe contener solo letras';
    }

    return null;
  }

  /// Validar fecha no pasada
  static String? notPastDate(DateTime? value, {String fieldName = 'Fecha'}) {
    if (value == null) {
      return null;
    }

    if (value.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return '$fieldName no puede ser una fecha pasada';
    }

    return null;
  }

  /// Validar fecha no muy lejana
  static String? notTooFarDate(
    DateTime? value, {
    int maxDays = 365,
    String fieldName = 'Fecha',
  }) {
    if (value == null) {
      return null;
    }

    final maxDate = DateTime.now().add(Duration(days: maxDays));
    if (value.isAfter(maxDate)) {
      return '$fieldName no puede ser más de $maxDays días en el futuro';
    }

    return null;
  }

  /// Combinar múltiples validadores
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// Validador personalizado para confirmación de contraseña
  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }

    if (value != originalPassword) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  /// Validar URL simple
  static String? url(String? value, {String fieldName = 'URL'}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (!RegExp(
      r'^https?:\/\/[\w\-]+(\.[\w\-]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$',
    ).hasMatch(value.trim())) {
      return '$fieldName no es válida';
    }

    return null;
  }
}
