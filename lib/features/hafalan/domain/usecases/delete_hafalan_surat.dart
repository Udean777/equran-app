import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteHafalanSurat {
  const DeleteHafalanSurat(this._repository);

  final HafalanRepository _repository;

  Future<Either<Failure, Unit>> call(int suratNomor) =>
      _repository.deleteHafalanSurat(suratNomor);
}
