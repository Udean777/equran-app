/// Constants for Hafalan AI Setoran feature — Data layer.
abstract final class HafalanApiConfig {
  /// Base URL for the AI comparison server.
  ///
  /// **Development**: gunakan IP lokal laptop (e.g., http://192.168.1.100:8000)
  /// **Production**: Hugging Face Spaces (https://ssajudn-equran-hafalan-api.hf.space)
  ///
  static const String apiBaseUrl =
      'https://ssajudn-equran-hafalan-api.hf.space';

  /// Local development
  // static const String apiBaseUrl = 'http://192.168.1.100:8000';
}
