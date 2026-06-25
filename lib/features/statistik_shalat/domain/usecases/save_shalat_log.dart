import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveShalatLog implements UseCase<Unit, ShalatLog> {
  const SaveShalatLog(this._repository);
  final StatistikShalatRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ShalatLog params) =>
      _repository.saveLog(params);
}
