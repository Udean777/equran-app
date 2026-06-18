import 'package:flutter/material.dart';

/// Controller untuk card stack swipe per ayat.
///
/// Index 0 = SuratInfoCard (info surat)
/// Index 1..N = AyatSwipeCard (per ayat, ayatNomor = index)
class CardStackController extends ChangeNotifier {
  CardStackController({
    required int totalAyat,
    int initialIndex = 0,
    this.onProgressUpdate,
  }) : _currentIndex = initialIndex.clamp(0, totalAyat + 1),
       _totalCards =
           totalAyat + 2, // +1 untuk info card, +1 untuk completion card
       _maxReachedIndex = initialIndex.clamp(0, totalAyat + 1);

  /// Total cards = totalAyat + 2 (info card + completion card)
  final int _totalCards;

  /// Callback saat progress berubah (0.0–1.0)
  final void Function(double progress)? onProgressUpdate;

  int _currentIndex;
  int _maxReachedIndex;

  /// Offset drag saat ini (untuk animasi)
  double _dragOffset = 0;

  int get currentIndex => _currentIndex;
  int get totalCards => _totalCards;
  int get totalAyat => _totalCards - 2; // -2 karena info & completion
  double get dragOffset => _dragOffset;

  /// Index ayat saat ini (0 = info card, 1+ = ayat)
  int get currentAyatNomor {
    if (_currentIndex == 0) return 0;
    if (_currentIndex > totalAyat) return totalAyat;
    return _currentIndex;
  }

  /// Progress 0.0–1.0 berdasarkan index tertinggi yang pernah dicapai
  double get maxProgress =>
      totalAyat > 0 ? (_maxReachedIndex / totalAyat).clamp(0.0, 1.0) : 0;

  /// Progress saat ini (untuk progress bar real-time)
  double get currentProgress =>
      totalAyat > 0 ? (_currentIndex / totalAyat).clamp(0.0, 1.0) : 0;

  bool get isFirst => _currentIndex == 0;
  bool get isLast => _currentIndex == _totalCards - 1;
  bool get isInfoCard => _currentIndex == 0;

  /// Navigasi ke card berikutnya
  void goNext() {
    if (_currentIndex >= _totalCards - 1) return;
    _currentIndex++;
    _dragOffset = 0;
    if (_currentIndex > _maxReachedIndex) {
      _maxReachedIndex = _currentIndex;
    }
    onProgressUpdate?.call(maxProgress);
    notifyListeners();
  }

  /// Navigasi ke card sebelumnya
  void goPrev() {
    if (_currentIndex <= 0) return;
    _currentIndex--;
    _dragOffset = 0;
    notifyListeners();
  }

  /// Jump ke index tertentu (misal dari "Lanjutkan Membaca")
  void jumpTo(int index) {
    final clamped = index.clamp(0, _totalCards - 1);
    _currentIndex = clamped;
    _dragOffset = 0;
    if (clamped > _maxReachedIndex) {
      _maxReachedIndex = clamped;
      onProgressUpdate?.call(maxProgress);
    }
    notifyListeners();
  }

  /// Update drag offset (untuk animasi real-time saat drag)
  void updateDrag(double offset) {
    _dragOffset = offset;
    notifyListeners();
  }

  /// Selesai drag — commit atau cancel berdasarkan threshold
  void endDrag({required double screenWidth}) {
    const threshold = 0.3; // 30% lebar layar
    final ratio = _dragOffset / screenWidth;

    if (ratio < -threshold) {
      goNext();
    } else if (ratio > threshold) {
      goPrev();
    } else {
      // Snap back
      _dragOffset = 0;
      notifyListeners();
    }
  }

  /// Ayat nomor terakhir yang dibaca (untuk saveLastRead)
  int get lastReadAyatNomor {
    if (_maxReachedIndex == 0) return 1;
    return _maxReachedIndex;
  }
}
