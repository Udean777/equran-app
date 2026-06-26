import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:equran_app/features/statistik_shalat/domain/services/shalat_stats_calculator.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/params/get_shalat_stats_params.dart';
import 'package:fpdart/fpdart.dart';

class GetShalatStats implements UseCase<ShalatStats, GetShalatStatsParams> {
  const GetShalatStats(this._repository, this._calculator);
  final StatistikShalatRepository _repository;
  final ShalatStatsCalculator _calculator;

  @override
  Future<Either<Failure, ShalatStats>> call(GetShalatStatsParams params) async {
    final result = await _repository.getByDateRange(params.dates);
    return result.fold(
      Left.new,
      (allDayStats) => Right(
        _calculator.calculateStats(
          dates: params.dates,
          today: params.today,
          allDayStats: allDayStats,
        ),
      ),
    );
  }
}
