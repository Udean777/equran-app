import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/qibla/domain/entities/qibla_direction.dart';
import 'package:equran_app/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:fpdart/fpdart.dart';

class WatchQiblaDirection implements UseCaseNoParams<Stream<QiblaDirection>> {
  const WatchQiblaDirection(this._repository);

  final QiblaRepository _repository;

  @override
  Future<Either<Failure, Stream<QiblaDirection>>> call() async =>
      _repository.watch();
}
