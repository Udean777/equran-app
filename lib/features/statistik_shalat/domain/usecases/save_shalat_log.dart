import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveShalatLog {
  const SaveShalatLog(this._repository);
  final StatistikShalatRepository _repository;

  Future<Either<Failure, Unit>> call(ShalatLog log) => _repository.saveLog(log);
}
