import 'dart:async';

import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/cleanup_old_reading_data.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/get_reading_stats.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/save_ayat_read.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

part 'reading_progress_cubit.freezed.dart';
part 'reading_progress_state.dart';

@injectable
class ReadingProgressCubit extends Cubit<ReadingProgressState> {
  ReadingProgressCubit(
    this._getReadingStats,
    this._saveAyatReadBatch,
    this._cleanupOldReadingData,
  ) : super(const ReadingProgressState.initial());

  final GetReadingStats _getReadingStats;
  final SaveAyatReadBatch _saveAyatReadBatch;
  final CleanupOldReadingData _cleanupOldReadingData;

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Buffer ayat yang belum di-flush ke Hive.
  final _pendingAyat = <String, Set<String>>{};

  /// Load statistik + auto-cleanup data lama.
  Future<void> load() async {
    emit(const ReadingProgressState.loading());

    // Auto-cleanup data > 90 hari (fire and forget)
    unawaited(_cleanupOldReadingData());

    final today = _dateFormat.format(DateTime.now());
    final result = _getReadingStats(today: today);

    final stats = result.getOrElse(
      (failure) {
        emit(ReadingProgressState.failure(failure.toUserMessage()));
        return const ReadingStats();
      },
    );
    if (result.isRight()) emit(ReadingProgressState.success(stats));
  }

  /// Tambah ayat ke buffer. Dipanggil saat ayat masuk viewport.
  void bufferAyat(int suratNomor, int ayatNomor) {
    final today = _dateFormat.format(DateTime.now());
    final ayatId = '$suratNomor:$ayatNomor';
    _pendingAyat.putIfAbsent(today, () => <String>{}).add(ayatId);
  }

  /// Flush buffer ke Hive. Dipanggil saat dispose SuratDetailPage.
  Future<void> flushBuffer() async {
    if (_pendingAyat.isEmpty) return;
    for (final entry in _pendingAyat.entries) {
      if (entry.value.isEmpty) continue;
      await _saveAyatReadBatch(entry.key, entry.value);
    }
    _pendingAyat.clear();
  }
}
