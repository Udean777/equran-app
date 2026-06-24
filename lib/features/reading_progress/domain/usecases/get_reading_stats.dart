import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/reading_progress/data/datasources/reading_history_local_data_source.dart';
import 'package:equran_app/features/reading_progress/domain/constants/reading_progress_constants.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/domain/services/reading_stats_calculator.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetReadingStats implements UseCase<ReadingStats, String> {
  const GetReadingStats(this._dataSource, this._calculator);

  final ReadingHistoryLocalDataSource _dataSource;
  final ReadingStatsCalculator _calculator;

  @override
  Future<Either<Failure, ReadingStats>> call(String today) async {
    try {
      // Ambil 90 hari terakhir
      final last90Dates = _calculator.generateDateRange(
        today,
        ReadingProgressConstants.retentionDays,
      );
      final allHistory = await _dataSource.getByDateRange(last90Dates);
      final historyMap = {for (final h in allHistory) h.date: h};

      // Total ayat dibaca (unique per surat:ayat, all-time dari 90 hari)
      final allAyatRead = <String>{};
      for (final h in allHistory) {
        allAyatRead.addAll(h.ayatRead);
      }
      final totalAyatRead = allAyatRead.length;

      // Total hari dengan data
      final totalHariDenganData = allHistory.where((h) => h.hasData).length;

      // Rata-rata per hari
      final rataRata = totalHariDenganData == 0
          ? 0.0
          : totalAyatRead / totalHariDenganData;

      // Progress per juz
      final progressPerJuz = _calculator.computeProgressPerJuz(allAyatRead);

      // Top 5 surat
      final topSurat = _calculator.computeTopSurat(allAyatRead);

      // 90 hari untuk heatmap (termasuk hari tanpa data)
      final last90 = last90Dates
          .map((d) => historyMap[d] ?? ReadingHistory(date: d))
          .toList();

      return Right(
        ReadingStats(
          totalAyatRead: totalAyatRead,
          totalHariDenganData: totalHariDenganData,
          rataRataPerHari: rataRata,
          progressPerJuz: progressPerJuz,
          last90Days: last90,
          topSurat: topSurat,
        ),
      );
    } on FormatException {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      if (e is HiveError) return const Left(Failure.storage());
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
