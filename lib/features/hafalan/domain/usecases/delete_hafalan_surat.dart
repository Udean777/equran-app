import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:equran_app/features/hafalan/domain/usecases/params/hafalan_params.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteHafalanSurat implements UseCase<Unit, HafalanSuratParams> {
  const DeleteHafalanSurat(this._repository);

  final HafalanRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(HafalanSuratParams params) =>
      _repository.deleteHafalanSurat(params.suratNomor);
}
