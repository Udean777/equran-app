/// Constants for Hafalan AI Setoran feature.
abstract final class HafalanConstants {
  /// Base URL for the AI comparison server.
  ///
  /// **Development**: gunakan IP lokal laptop (e.g., http://192.168.1.100:8000)
  /// **Production**: Hugging Face Spaces (https://ssajudn-equran-hafalan-api.hf.space)
  ///
  static const String apiBaseUrl = 'https://ssajudn-equran-hafalan-api.hf.space';

  /// Local development
  // static const String apiBaseUrl = 'http://192.168.1.100:8000';

  /// Default similarity threshold for success (0-100).
  static const double defaultThreshold = 80;

  /// Threshold for warning/kurang tepat (0-100).
  static const double warningThreshold = 70;
}
