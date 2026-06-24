import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/usecase/use_case.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/domain/repositories/catatan_ayat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveCatatan implements UseCase<Unit, CatatanAyat> {
  const SaveCatatan(this._repository);

  final CatatanAyatRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CatatanAyat params) =>
      _repository.save(params);
}
