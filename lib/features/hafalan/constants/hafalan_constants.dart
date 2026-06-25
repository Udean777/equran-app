/// Constants for Hafalan AI Setoran feature.
abstract final class HafalanConstants {
  /// Base URL for the AI comparison server.
  ///
  /// **Development**: gunakan IP lokal laptop (e.g., http://192.168.1.100:8000)
  /// **Production**: gunakan Render URL (e.g., https://equran-hafalan-api.onrender.com)
  ///
  // TODO(developer): ganti dengan URL production setelah deploy ke Render
  static const String apiBaseUrl = 'http://192.168.1.100:8000';

  /// Production API URL (Render)
  /// Uncomment line di bawah dan comment line di atas untuk production build
  // static const String apiBaseUrl = 'https://equran-hafalan-api.onrender.com';

  /// Default similarity threshold (0-100).
  static const double defaultThreshold = 75;
}
