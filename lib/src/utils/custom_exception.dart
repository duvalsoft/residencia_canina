
// lib/src/utils/custom_exception.dart
class OdooException implements Exception {
  final String message;

  OdooException(this.message);

  @override
  String toString() => message;
}
