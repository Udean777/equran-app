import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/reading_progress/domain/constants/reading_progress_constants.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart';
import 'package:equran_app/features/reading_progress/domain/services/reading_stats_calculator.dart';
import 'package:fpdart/fpdart.dart';

class GetReadingStats implements UseCase<ReadingStats, String> {
  const GetReadingStats(this._repository, this._calculator);

  final ReadingProgressRepository _repository;
  final ReadingStatsCalculator _calculator;

  @override
  Future<Either<Failure, ReadingStats>> call(String today) async {
    final last90Dates = _calculator.generateDateRange(
      today,
      ReadingProgressConstants.retentionDays,
    );
    final result = await _repository.getByDateRange(last90Dates);

    return result.fold(
      Left.new,
      (allHistory) {
        final historyMap = {for (final h in allHistory) h.date: h};

        final allAyatRead = <String>{};
        for (final h in allHistory) {
          allAyatRead.addAll(h.ayatRead);
        }
        final totalAyatRead = allAyatRead.length;

        final totalHariDenganData = allHistory.where((h) => h.hasData).length;
        final rataRata = totalHariDenganData == 0
            ? 0.0
            : totalAyatRead / totalHariDenganData;

        final progressPerJuz = _calculator.computeProgressPerJuz(allAyatRead);
        final topSurat = _calculator.computeTopSurat(allAyatRead);

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
      },
    );
  }
}
