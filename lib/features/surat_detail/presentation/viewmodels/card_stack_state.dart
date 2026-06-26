import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_stack_state.freezed.dart';

/// State untuk card stack navigation di SuratDetailCardView.
///
/// Index 0 = SuratInfoCard (info surat)
/// Index 1..N = AyatSwipeCard (per ayat, ayatNomor = index)
/// Index N+1 = CompletionCard
@freezed
sealed class CardStackState with _$CardStackState {
  const factory CardStackState({
    required int currentIndex,
    required int maxReachedIndex,
    required double dragOffset,
    required int totalCards,
  }) = _CardStackState;

  const CardStackState._();

  /// Total ayat (tidak termasuk info card & completion card)
  int get totalAyat => totalCards - 2;

  /// Index ayat saat ini (0 = info card, 1+ = ayat)
  int get currentAyatNomor {
    if (currentIndex == 0) return 0;
    if (currentIndex > totalAyat) return totalAyat;
    return currentIndex;
  }

  /// Progress 0.0–1.0 berdasarkan index tertinggi yang pernah dicapai
  double get maxProgress =>
      totalAyat > 0 ? (maxReachedIndex / totalAyat).clamp(0.0, 1.0) : 0;

  /// Progress saat ini (untuk progress bar real-time)
  double get currentProgress =>
      totalAyat > 0 ? (currentIndex / totalAyat).clamp(0.0, 1.0) : 0;

  bool get isFirst => currentIndex == 0;
  bool get isLast => currentIndex == totalCards - 1;
  bool get isInfoCard => currentIndex == 0;

  /// Ayat nomor terakhir yang dibaca (untuk saveLastRead)
  int get lastReadAyatNomor {
    if (maxReachedIndex == 0) return 1;
    return maxReachedIndex;
  }
}
