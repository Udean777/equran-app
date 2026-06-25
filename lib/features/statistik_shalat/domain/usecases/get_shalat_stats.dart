import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/statistik_shalat/data/datasources/shalat_log_local_data_source.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/services/shalat_stats_calculator.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/params/get_shalat_stats_params.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';

class GetShalatStats implements UseCase<ShalatStats, GetShalatStatsParams> {
  const GetShalatStats(this._dataSource, this._calculator);
  final ShalatLogLocalDataSource _dataSource;
  final ShalatStatsCalculator _calculator;

  @override
  Future<Either<Failure, ShalatStats>> call(GetShalatStatsParams params) async {
    try {
      final allDayStats = await _dataSource.getByDateRange(params.dates);
      final stats = await _calculator.calculateStats(
        dates: params.dates,
        today: params.today,
        allDayStats: allDayStats,
      );
      return Right(stats);
      // Menangkap HiveError secara spesifik untuk membedakan error storage
      // ignore: avoid_catching_errors
    } on HiveError catch (_) {
      return const Left(Failure.storage());
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
