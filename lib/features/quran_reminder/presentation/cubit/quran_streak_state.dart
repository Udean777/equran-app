part of 'quran_streak_cubit.dart';

@freezed
sealed class QuranStreakState with _$QuranStreakState {
  const factory QuranStreakState.initial() = QuranStreakInitial;
  const factory QuranStreakState.loaded(int streak) = QuranStreakLoaded;
  const factory QuranStreakState.error(Failure failure) = QuranStreakError;
}
