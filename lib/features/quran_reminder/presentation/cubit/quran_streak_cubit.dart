import 'package:equran_app/features/quran_reminder/domain/usecases/get_streak_count.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/record_quran_read.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class QuranStreakCubit extends Cubit<int> {
  QuranStreakCubit(
    this._getStreakCount,
    this._recordQuranRead,
  ) : super(0);

  final GetStreakCount _getStreakCount;
  final RecordQuranRead _recordQuranRead;

  /// Load streak count dari storage.
  Future<void> load() async {
    final count = await _getStreakCount();
    emit(count);
  }

  /// Dipanggil saat user membuka SuratDetailPage.
  ///
  /// Tidak emit jika streak tidak berubah (sudah baca hari ini).
  Future<void> recordRead() async {
    final newCount = await _recordQuranRead(state);
    if (newCount != state) emit(newCount);
  }
}
