part of 'bookmark_cubit.dart';

@freezed
sealed class BookmarkState with _$BookmarkState {
  const factory BookmarkState.initial() = BookmarkInitial;
  const factory BookmarkState.loading() = BookmarkLoading;
  const factory BookmarkState.success({
    required List<Bookmark> bookmarks,
    LastRead? lastRead,

    /// Progress per surat — key: suratNomor, value: maxScrollPercent (0.0–1.0)
    @Default(<int, double>{}) Map<int, double> suratProgressMap,
  }) = BookmarkSuccess;
  const factory BookmarkState.failure({
    required Failure failure,
  }) = BookmarkFailure;
}
