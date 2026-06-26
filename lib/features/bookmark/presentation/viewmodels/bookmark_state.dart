import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_state.freezed.dart';

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
