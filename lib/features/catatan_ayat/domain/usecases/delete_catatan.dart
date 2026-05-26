import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/catatan_ayat/domain/repositories/catatan_ayat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteCatatan {
  const DeleteCatatan(this._repository);

  final CatatanAyatRepository _repository;

  Future<Either<Failure, Unit>> call({
    required int suratNomor,
    required int ayatNomor,
  }) => _repository.delete(suratNomor: suratNomor, ayatNomor: ayatNomor);
}
