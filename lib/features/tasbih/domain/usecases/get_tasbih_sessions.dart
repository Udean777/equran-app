import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_session.dart';
import 'package:equran_app/features/tasbih/domain/repositories/tasbih_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetTasbihSessions implements UseCaseNoParams<List<TasbihSession>> {
  const GetTasbihSessions(this._repository);

  final TasbihRepository _repository;

  @override
  Future<Either<Failure, List<TasbihSession>>> call() =>
      _repository.getSessions();
}
