import 'dart:async';

import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/features/reading_progress/domain/constants/reading_progress_constants.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/cleanup_old_reading_data.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/get_reading_stats.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/params/save_ayat_read_batch_params.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/save_ayat_read_batch.dart';
import 'package:equran_app/features/reading_progress/presentation/providers.dart';
import 'package:equran_app/features/reading_progress/presentation/viewmodels/reading_progress_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ReadingProgressViewModel extends Notifier<ReadingProgressState>
    with WidgetsBindingObserver {
  GetReadingStats get _getReadingStats => ref.read(getReadingStatsProvider);
  SaveAyatReadBatch get _saveAyatReadBatch =>
      ref.read(saveAyatReadBatchProvider);
  CleanupOldReadingData get _cleanupOldReadingData =>
      ref.read(cleanupOldReadingDataProvider);

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Buffer ayat yang belum di-flush ke Hive.
  final _pendingAyat = <String, Set<String>>{};

  /// Timer untuk auto-flush setiap autoFlushSeconds detik — safety net jika app di-kill.
  Timer? _autoFlushTimer;

  @override
  ReadingProgressState build() {
    WidgetsBinding.instance.removeObserver(this);
    WidgetsBinding.instance.addObserver(this);
    _startAutoFlush();
    ref.onDispose(_dispose);
    return const ReadingProgressState.initial();
  }

  void _dispose() {
    _autoFlushTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  /// Mulai periodic auto-flush.
  void _startAutoFlush() {
    _autoFlushTimer = Timer.periodic(
      const Duration(seconds: ReadingProgressConstants.autoFlushSeconds),
      (_) => unawaited(flushBuffer()),
    );
  }

  /// Flush buffer saat app masuk background atau di-detach.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      unawaited(flushBuffer());
    }
  }

  /// Load statistik + auto-cleanup data lama.
  Future<void> load() async {
    state = const ReadingProgressState.loading();

    // Auto-cleanup data > retentionDays (fire and forget)
    unawaited(_cleanupOldReadingData(ReadingProgressConstants.retentionDays));

    final today = _dateFormat.format(DateTime.now());
    final result = await _getReadingStats(today);

    result.fold(
      (failure) =>
          state = ReadingProgressState.failure(failure.toUserMessage()),
      (stats) => state = ReadingProgressState.success(stats),
    );
  }

  /// Tambah ayat ke buffer. Dipanggil saat ayat masuk viewport.
  void bufferAyat(int suratNomor, int ayatNomor) {
    final today = _dateFormat.format(DateTime.now());
    final ayatId = '$suratNomor:$ayatNomor';
    _pendingAyat.putIfAbsent(today, () => <String>{}).add(ayatId);
  }

  /// Flush buffer ke Hive. Dipanggil saat dispose SuratDetailPage,
  /// auto-flush timer, atau app masuk background.
  Future<void> flushBuffer() async {
    if (_pendingAyat.isEmpty) return;
    final snapshot = Map<String, Set<String>>.from(_pendingAyat);
    _pendingAyat.clear();
    for (final entry in snapshot.entries) {
      if (entry.value.isEmpty) continue;
      try {
        await _saveAyatReadBatch(
          SaveAyatReadBatchParams(date: entry.key, ayatIds: entry.value),
        );
      } on Object catch (e) {
        debugPrint('ReadingProgressViewModel: flush error: $e');
      }
    }
  }
}
