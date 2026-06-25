import 'package:equran_app/features/quran_reminder/domain/usecases/get_streak_count.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/record_quran_read.dart';
import 'package:equran_app/features/quran_reminder/presentation/viewmodels/quran_streak_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuranStreakViewModel extends StateNotifier<QuranStreakState> {
  QuranStreakViewModel(
    this._getStreakCount,
    this._recordQuranRead,
  ) : super(const QuranStreakState.initial());

  final GetStreakCount _getStreakCount;
  final RecordQuranRead _recordQuranRead;

  Future<void> load() async {
    final result = await _getStreakCount();
    result.fold(
      (failure) => state = QuranStreakState.error(failure),
      (count) => state = QuranStreakState.loaded(count),
    );
  }

  Future<void> recordRead() async {
    final currentStreak = state.mapOrNull(loaded: (s) => s.streak) ?? 0;
    final result = await _recordQuranRead(currentStreak);
    result.fold(
      (failure) => state = QuranStreakState.error(failure),
      (newCount) {
        if (newCount != currentStreak) {
          state = QuranStreakState.loaded(newCount);
        }
      },
    );
  }
}
