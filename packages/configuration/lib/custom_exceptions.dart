class NoConfigFoundException implements Exception {}

class InvalidFormatException implements Exception {
  InvalidFormatException({this.message});

  String? message;
}
