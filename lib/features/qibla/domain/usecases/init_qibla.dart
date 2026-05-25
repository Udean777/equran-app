import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitQibla {
  const InitQibla(this._repository);

  final QiblaRepository _repository;

  Future<Either<Failure, Unit>> call() => _repository.init();
}
