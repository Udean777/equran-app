part of 'doa_bookmark_cubit.dart';

@freezed
sealed class DoaBookmarkState with _$DoaBookmarkState {
  const factory DoaBookmarkState.initial() = DoaBookmarkInitial;
  const factory DoaBookmarkState.loading() = DoaBookmarkLoading;
  const factory DoaBookmarkState.success({
    required List<Doa> bookmarkedDoas,
  }) = DoaBookmarkSuccess;
  const factory DoaBookmarkState.failure({
    required Failure failure,
  }) = DoaBookmarkFailure;
}
