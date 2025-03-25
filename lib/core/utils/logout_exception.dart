class LogoutException implements Exception {
  final String message;
  LogoutException(this.message);

  @override
  String toString() => message;
}