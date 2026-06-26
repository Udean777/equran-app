import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/tasbih/domain/repositories/tasbih_repository.dart';
import 'package:fpdart/fpdart.dart';

class ClearTasbihSessions implements UseCaseNoParams<Unit> {
  const ClearTasbihSessions(this._repository);

  final TasbihRepository _repository;

  @override
  Future<Either<Failure, Unit>> call() => _repository.clearSessions();
}
