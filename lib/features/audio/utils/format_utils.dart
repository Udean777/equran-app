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
