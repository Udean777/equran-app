abstract final class NetworkConfig {
  static const connectTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 15);
  static const locationTimeout = Duration(seconds: 10);
  static const locationFallbackTimeout = Duration(seconds: 8);
  static const unknownStatusCode = -1;
}
