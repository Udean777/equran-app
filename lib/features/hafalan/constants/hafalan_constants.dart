/// Constants for Hafalan AI Setoran feature.
abstract final class HafalanConstants {
  /// Base URL for the AI comparison server.
  ///
  /// Ganti ke IP laptop/VPS saat development/production.
  static const String apiBaseUrl = 'http://192.168.1.100:8000';

  /// Default similarity threshold (0-100).
  static const double defaultThreshold = 75;
}
