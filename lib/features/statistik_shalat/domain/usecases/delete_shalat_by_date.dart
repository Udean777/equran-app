import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteShalatByDate implements UseCase<Unit, String> {
  const DeleteShalatByDate(this._repository);
  final StatistikShalatRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String date) =>
      _repository.deleteByDate(date);
}
