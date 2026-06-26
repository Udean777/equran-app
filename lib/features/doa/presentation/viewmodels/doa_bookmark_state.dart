import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doa_bookmark_state.freezed.dart';

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
