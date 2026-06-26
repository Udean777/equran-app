import 'package:equran_app/features/surat_detail/presentation/viewmodels/card_stack_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier untuk card stack navigation di SuratDetailCardView.
///
/// Mengelola navigasi antar card (info → ayat 1..N → completion),
/// drag offset untuk animasi, dan progress tracking untuk last-read.
class CardStackNotifier extends AutoDisposeFamilyNotifier<CardStackState, int> {

  @override
  CardStackState build(int totalAyat) {
    // arg = totalAyat (jumlah ayat dalam surat)
    final totalCards = totalAyat + 2; // +1 info card, +1 completion card
    return CardStackState(
      currentIndex: 0,
      maxReachedIndex: 0,
      dragOffset: 0,
      totalCards: totalCards,
    );
  }

  /// Navigasi ke card berikutnya
  void goNext() {
    if (state.currentIndex >= state.totalCards - 1) return;
    final newIndex = state.currentIndex + 1;
    final newMaxReached = newIndex > state.maxReachedIndex
        ? newIndex
        : state.maxReachedIndex;

    state = state.copyWith(
      currentIndex: newIndex,
      maxReachedIndex: newMaxReached,
      dragOffset: 0,
    );
  }

  /// Navigasi ke card sebelumnya
  void goPrev() {
    if (state.currentIndex <= 0) return;
    state = state.copyWith(
      currentIndex: state.currentIndex - 1,
      dragOffset: 0,
    );
  }

  /// Jump ke index tertentu (misal dari "Lanjutkan Membaca")
  void jumpTo(int index) {
    final clamped = index.clamp(0, state.totalCards - 1);
    final newMaxReached = clamped > state.maxReachedIndex
        ? clamped
        : state.maxReachedIndex;

    state = state.copyWith(
      currentIndex: clamped,
      maxReachedIndex: newMaxReached,
      dragOffset: 0,
    );
  }

  /// Update drag offset (untuk animasi real-time saat drag)
  void updateDrag(double offset) {
    state = state.copyWith(dragOffset: offset);
  }

  /// Selesai drag — commit atau cancel berdasarkan threshold
  void endDrag({required double screenWidth}) {
    const threshold = 0.3; // 30% lebar layar
    final ratio = state.dragOffset / screenWidth;

    if (ratio < -threshold) {
      goNext();
    } else if (ratio > threshold) {
      goPrev();
    } else {
      // Snap back
      state = state.copyWith(dragOffset: 0);
    }
  }

  /// Reset ke state awal
  void reset() {
    state = state.copyWith(
      currentIndex: 0,
      maxReachedIndex: 0,
      dragOffset: 0,
    );
  }

  /// Jump ke ayat tertentu dengan initial index
  void jumpToInitial(int initialIndex) {
    final clamped = initialIndex.clamp(0, state.totalCards - 1);
    state = state.copyWith(
      currentIndex: clamped,
      maxReachedIndex: clamped,
      dragOffset: 0,
    );
  }
}
