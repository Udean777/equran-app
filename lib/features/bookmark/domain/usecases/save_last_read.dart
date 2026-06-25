import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:equran_app/features/bookmark/domain/repositories/last_read_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveLastRead implements UseCase<Unit, LastRead> {
  const SaveLastRead(this._repository);

  final LastReadRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(LastRead params) =>
      _repository.saveLastRead(params);
}
