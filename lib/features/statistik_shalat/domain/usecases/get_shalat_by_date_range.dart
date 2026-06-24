import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/params/get_shalat_by_date_range_params.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetShalatByDateRange
    implements UseCase<List<ShalatDayStats>, GetShalatByDateRangeParams> {
  const GetShalatByDateRange(this._repository);
  final StatistikShalatRepository _repository;

  @override
  Future<Either<Failure, List<ShalatDayStats>>> call(
    GetShalatByDateRangeParams params,
  ) => _repository.getByDateRange(params.dates);
}
