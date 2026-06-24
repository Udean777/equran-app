import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/get_streak_count.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/record_quran_read.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'quran_streak_cubit.freezed.dart';
part 'quran_streak_state.dart';

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
    final result = await _getStreakCount();
    result.fold(
      (failure) => emit(QuranStreakState.error(failure)),
      (count) => emit(QuranStreakState.loaded(count)),
    );
  }

  /// Dipanggil saat user membuka SuratDetailPage.
  ///
  /// Tidak emit jika streak tidak berubah (sudah baca hari ini).
  Future<void> recordRead() async {
    final currentStreak = state.mapOrNull(loaded: (s) => s.streak) ?? 0;
    final result = await _recordQuranRead(currentStreak);
    result.fold(
      (failure) => emit(QuranStreakState.error(failure)),
      (newCount) {
        if (newCount != currentStreak) {
          emit(QuranStreakState.loaded(newCount));
        }
      },
    );
  }
}
