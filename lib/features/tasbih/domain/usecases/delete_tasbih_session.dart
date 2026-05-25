import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/tasbih/domain/repositories/tasbih_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteTasbihSession implements UseCase<Unit, String> {
  const DeleteTasbihSession(this._repository);

  final TasbihRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String params) =>
      _repository.deleteSession(params);
}
