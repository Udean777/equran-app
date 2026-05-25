import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/qibla/domain/entities/qibla_direction.dart';
import 'package:equran_app/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchQiblaDirection {
  const WatchQiblaDirection(this._repository);

  final QiblaRepository _repository;

  Either<Failure, Stream<QiblaDirection>> call() => _repository.watch();
}
