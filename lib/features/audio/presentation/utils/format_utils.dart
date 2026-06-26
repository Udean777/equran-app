/// Utility extensions untuk formatting nilai numerik.
library;

extension IntFormatExtension on int {
  /// Format bytes ke string yang mudah dibaca manusia.
  ///
  /// Contoh:
  /// - 512 → "512 B"
  /// - 1536 → "1.5 KB"
  /// - 2097152 → "2.0 MB"
  String toReadableBytes() {
    if (this < 1024) return '$this B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(1)} KB';
    return '${(this / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

extension DurationFormatExtension on Duration {
  /// Format durasi ke string HH:MM:SS atau MM:SS.
  String toReadableString() {
    if (inHours > 0) {
      final h = inHours.toString().padLeft(2, '0');
      final m = inMinutes.remainder(60).toString().padLeft(2, '0');
      final s = inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$h:$m:$s';
    }
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
