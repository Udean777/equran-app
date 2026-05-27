import 'package:equran_app/features/quran_reminder/domain/usecases/get_streak_count.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/record_quran_read.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

export 'quran_streak_state.dart';

@singleton
class QuranStreakCubit extends Cubit<QuranStreakState> {
  QuranStreakCubit(
    this._getStreakCount,
    this._recordQuranRead,
  ) : super(const QuranStreakState.initial());

  final GetStreakCount _getStreakCount;
  final RecordQuranRead _recordQuranRead;

  /// Load streak count dari storage.
  Future<void> load() async {
    final count = await _getStreakCount();
    emit(QuranStreakState.loaded(count));
  }

  /// Dipanggil saat user membuka SuratDetailPage.
  ///
  /// Tidak emit jika streak tidak berubah (sudah baca hari ini).
  Future<void> recordRead() async {
    final currentStreak = state.mapOrNull(loaded: (s) => s.streak) ?? 0;
    final newCount = await _recordQuranRead(currentStreak);
    if (newCount != currentStreak) emit(QuranStreakState.loaded(newCount));
  }
}
