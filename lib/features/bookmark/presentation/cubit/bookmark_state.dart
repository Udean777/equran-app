part of 'bookmark_cubit.dart';

@freezed
sealed class BookmarkState with _$BookmarkState {
  const factory BookmarkState.initial() = BookmarkInitial;
  const factory BookmarkState.loading() = BookmarkLoading;
  const factory BookmarkState.success({
    required List<Bookmark> bookmarks,
    @Default([]) List<Doa> bookmarkedDoas,
    LastRead? lastRead,
  }) = BookmarkSuccess;
  const factory BookmarkState.failure({
    required Failure failure,
  }) = BookmarkFailure;
}
