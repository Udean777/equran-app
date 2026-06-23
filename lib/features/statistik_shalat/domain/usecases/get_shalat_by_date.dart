import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetShalatByDate implements UseCase<ShalatDayStats?, String> {
  const GetShalatByDate(this._repository);
  final StatistikShalatRepository _repository;

  @override
  Future<Either<Failure, ShalatDayStats?>> call(String params) =>
      _repository.getByDate(params);
}
