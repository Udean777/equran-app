// Core exceptions thrown by data layer.
// These are caught in repository and mapped to Failure.

class ServerException implements Exception {
  const ServerException({required this.statusCode, this.message});

  final int statusCode;
  final String? message;

  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

class NetworkException implements Exception {
  const NetworkException({this.message});

  final String? message;

  @override
  String toString() => 'NetworkException(message: $message)';
}

class CacheException implements Exception {
  const CacheException({this.message});

  final String? message;

  @override
  String toString() => 'CacheException(message: $message)';
}
