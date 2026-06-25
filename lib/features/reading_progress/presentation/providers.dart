import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/reading_progress/data/datasources/reading_history_local_data_source.dart';
import 'package:equran_app/features/reading_progress/data/repositories/reading_progress_repository_impl.dart';
import 'package:equran_app/features/reading_progress/domain/services/reading_stats_calculator.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/cleanup_old_reading_data.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/get_reading_stats.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/save_ayat_read_batch.dart';
import 'package:equran_app/features/reading_progress/presentation/viewmodels/reading_progress_state.dart';
import 'package:equran_app/features/reading_progress/presentation/viewmodels/reading_progress_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final readingHistoryLocalDataSourceProvider =
    Provider<ReadingHistoryLocalDataSource>((ref) {
      final box = ref.watch(readingHistoryBoxProvider).requireValue;
      return ReadingHistoryLocalDataSourceImpl(box);
    });

final readingProgressRepositoryProvider =
    Provider<ReadingProgressRepositoryImpl>((ref) {
      return ReadingProgressRepositoryImpl(
        ref.read(readingHistoryLocalDataSourceProvider),
      );
    });

final readingStatsCalculatorProvider = Provider<ReadingStatsCalculator>((ref) {
  return ReadingStatsCalculator();
});

final getReadingStatsProvider = Provider<GetReadingStats>((ref) {
  return GetReadingStats(
    ref.read(readingHistoryLocalDataSourceProvider),
    ref.read(readingStatsCalculatorProvider),
  );
});

final saveAyatReadBatchProvider = Provider<SaveAyatReadBatch>((ref) {
  return SaveAyatReadBatch(ref.read(readingProgressRepositoryProvider));
});

final cleanupOldReadingDataProvider = Provider<CleanupOldReadingData>((ref) {
  return CleanupOldReadingData(ref.read(readingProgressRepositoryProvider));
});

final readingProgressViewModelProvider =
    NotifierProvider<ReadingProgressViewModel, ReadingProgressState>(
      ReadingProgressViewModel.new,
    );
