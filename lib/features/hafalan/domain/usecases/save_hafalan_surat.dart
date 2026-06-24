import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:equran_app/features/hafalan/domain/usecases/params/save_hafalan_params.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveHafalanSurat implements UseCase<Unit, SaveHafalanParams> {
  const SaveHafalanSurat(this._repository);

  final HafalanRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(SaveHafalanParams params) =>
      _repository.saveHafalanSurat(params.hafalan);
}
