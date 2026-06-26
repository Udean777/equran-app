import 'package:equran_app/features/quran_reminder/domain/usecases/get_streak_count.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/record_quran_read.dart';
import 'package:equran_app/features/quran_reminder/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuranStreakViewModel extends Notifier<QuranStreakState> {
  @override
  QuranStreakState build() => const QuranStreakState.initial();

  GetStreakCount get _getStreakCount => ref.read(getStreakCountProvider);
  RecordQuranRead get _recordQuranRead => ref.read(recordQuranReadProvider);

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
