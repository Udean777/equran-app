import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_progress_state.freezed.dart';

@freezed
sealed class ReadingProgressState with _$ReadingProgressState {
  const ReadingProgressState._();

  const factory ReadingProgressState.initial() = _Initial;
  const factory ReadingProgressState.loading() = _Loading;
  const factory ReadingProgressState.success(ReadingStats stats) = _Success;
  const factory ReadingProgressState.failure(String message) = _Failure;

  ReadingStats? get statsOrNull => switch (this) {
    _Success(:final stats) => stats,
    _ => null,
  };
}
