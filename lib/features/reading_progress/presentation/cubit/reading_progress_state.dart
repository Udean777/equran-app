part of 'reading_progress_cubit.dart';

@freezed
abstract class ReadingProgressState with _$ReadingProgressState {
  const factory ReadingProgressState.initial() = _Initial;
  const factory ReadingProgressState.loading() = _Loading;
  const factory ReadingProgressState.success(ReadingStats stats) = _Success;
  const factory ReadingProgressState.failure(String message) = _Failure;
}
