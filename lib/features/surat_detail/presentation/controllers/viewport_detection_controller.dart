import 'dart:async';

import 'package:flutter/widgets.dart';

/// Controller untuk mendeteksi ayat yang sedang dibaca di viewport.
///
/// Ayat dianggap "dibaca" jika:
/// - Minimal 50% visible di layar
/// - Sudah visible selama minimal 2 detik
///
/// Menggunakan [GlobalObjectKey] (lebih ringan dari [GlobalKey]) karena
/// tidak perlu terdaftar di global registry Flutter.
class ViewportDetectionController {
  ViewportDetectionController({
    required this.onAyatRead,
    this.visibilityThreshold = 0.5,
    this.durationThreshold = const Duration(seconds: 2),
    this.throttleDuration = const Duration(milliseconds: 1500),
  });

  /// Dipanggil saat ayat dianggap sudah dibaca.
  final void Function(int suratNomor, int ayatNomor) onAyatRead;

  /// Minimal rasio visible untuk dianggap "terlihat" (default 50%).
  final double visibilityThreshold;

  /// Durasi minimal visible sebelum dianggap "dibaca" (default 2 detik).
  final Duration durationThreshold;

  /// Throttle interval untuk pengecekan viewport (default 1.5 detik).
  final Duration throttleDuration;

  final _itemKeys = <int, GlobalObjectKey>{};
  final _ayatVisibleSince = <int, DateTime>{};
  final _reportedAyat = <int>{};

  Timer? _checkTimer;
  int? _currentSuratNomor;

  /// Semua keys yang terdaftar — digunakan oleh last-read detection.
  Map<int, GlobalObjectKey> get keys => Map.unmodifiable(_itemKeys);

  /// Ambil atau buat [GlobalObjectKey] untuk ayat tertentu.
  GlobalObjectKey keyFor(int ayatNomor) {
    return _itemKeys.putIfAbsent(
      ayatNomor,
      () => GlobalObjectKey('ayat_${_currentSuratNomor}_$ayatNomor'),
    );
  }

  /// Set surat yang sedang aktif. Reset state jika surat berbeda.
  void setSurat(int suratNomor) {
    if (_currentSuratNomor != suratNomor) {
      reset();
      _currentSuratNomor = suratNomor;
    }
  }

  /// Jadwalkan pengecekan viewport (dipanggil dari scroll listener).
  /// Throttled — hanya satu pengecekan per [throttleDuration].
  void scheduleCheck(double screenHeight) {
    _checkTimer?.cancel();
    _checkTimer = Timer(throttleDuration, () => _check(screenHeight));
  }

  void _check(double screenHeight) {
    final suratNomor = _currentSuratNomor;
    if (suratNomor == null) return;

    final now = DateTime.now();
    final currentlyVisible = <int>{};

    for (final entry in _itemKeys.entries) {
      final ctx = entry.value.currentContext;
      if (ctx == null) continue;
      final renderObj = ctx.findRenderObject();
      if (renderObj is! RenderBox) continue;

      final pos = renderObj.localToGlobal(Offset.zero);
      final height = renderObj.size.height;
      if (height <= 0) continue;

      final visibleTop = pos.dy.clamp(0.0, screenHeight);
      final visibleBottom = (pos.dy + height).clamp(0.0, screenHeight);
      final visibleRatio = (visibleBottom - visibleTop) / height;

      if (visibleRatio >= visibilityThreshold) {
        currentlyVisible.add(entry.key);
        _ayatVisibleSince.putIfAbsent(entry.key, () => now);

        final since = _ayatVisibleSince[entry.key]!;
        if (!_reportedAyat.contains(entry.key) &&
            now.difference(since) >= durationThreshold) {
          _reportedAyat.add(entry.key);
          onAyatRead(suratNomor, entry.key);
        }
      }
    }

    // Hapus ayat yang sudah tidak visible dari tracking
    _ayatVisibleSince.removeWhere(
      (ayatNomor, _) => !currentlyVisible.contains(ayatNomor),
    );
  }

  /// Reset semua state (dipanggil saat ganti surat).
  void reset() {
    _checkTimer?.cancel();
    _itemKeys.clear();
    _ayatVisibleSince.clear();
    _reportedAyat.clear();
  }

  /// Dispose semua resources.
  void dispose() {
    _checkTimer?.cancel();
  }
}
