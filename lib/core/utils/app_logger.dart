import 'package:flutter/foundation.dart';

/// Logger terpusat untuk equran-app.
///
/// - `debug`, `info`, `warning` — hanya aktif di debug mode
/// - `error` — selalu di-log (untuk crash reporting di production)
///
/// Ganti semua `print()` dengan [AppLogger] agar tidak ada log
/// yang bocor ke production.
class AppLogger {
  AppLogger._();

  /// Log pesan debug — hanya di debug mode.
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (!kDebugMode) return;
    debugPrint('[DEBUG] $message');
    if (error != null) debugPrint('[ERROR] $error');
    if (stackTrace != null) debugPrint('[STACK] $stackTrace');
  }

  /// Log pesan info — hanya di debug mode.
  static void info(String message) {
    if (!kDebugMode) return;
    debugPrint('[INFO] $message');
  }

  /// Log pesan warning — hanya di debug mode.
  static void warning(String message, [Object? error]) {
    if (!kDebugMode) return;
    debugPrint('[WARN] $message');
    if (error != null) debugPrint('[ERROR] $error');
  }

  /// Log error — selalu di-log di semua mode.
  /// Gunakan untuk catch blocks yang perlu dimonitor di production.
  ///
  // Integrasikan dengan crash reporting service
  // (Firebase Crashlytics, Sentry, dll) jika diperlukan.
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message');
    if (error != null) debugPrint('$error');
    if (stackTrace != null && kDebugMode) debugPrint('$stackTrace');
  }
}
