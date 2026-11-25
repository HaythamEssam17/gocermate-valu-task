class NetworkException implements Exception {
  const NetworkException([this.message = 'Network error']);
  final String message;
  @override
  String toString() => 'NetworkException: $message';
}

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;
  @override
  String toString() => 'ApiException($statusCode): $message';
}
