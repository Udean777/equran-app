import 'package:equran_app/core/error/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quran_streak_state.freezed.dart';

@freezed
sealed class QuranStreakState with _$QuranStreakState {
  const factory QuranStreakState.initial() = QuranStreakInitial;
  const factory QuranStreakState.loaded(int streak) = QuranStreakLoaded;
  const factory QuranStreakState.error(Failure failure) = QuranStreakError;
}
