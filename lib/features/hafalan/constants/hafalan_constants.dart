/// Constants for Hafalan AI Setoran feature.
abstract final class HafalanConstants {
  /// Base URL for the AI comparison server.
  ///
  /// **Development**: gunakan IP lokal laptop (e.g., http://192.168.1.100:8000)
  /// **Production**: gunakan Render URL (e.g., https://equran-hafalan-api.onrender.com)
  ///
  static const String apiBaseUrl = 'http://10.226.172.1:8000';

  /// Production API URL (Render)
  /// Uncomment line di bawah dan comment line di atas untuk production build
  // static const String apiBaseUrl = 'https://equran-hafalan-api.onrender.com';

  /// Default similarity threshold for success (0-100).
  static const double defaultThreshold = 80;

  /// Threshold for warning/kurang tepat (0-100).
  static const double warningThreshold = 70;
}
