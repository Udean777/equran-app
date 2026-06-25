import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:fpdart/fpdart.dart';

class InitQibla implements UseCaseNoParams<Unit> {
  const InitQibla(this._repository);

  final QiblaRepository _repository;

  @override
  Future<Either<Failure, Unit>> call() => _repository.init();
}
