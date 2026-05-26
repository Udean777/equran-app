import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/domain/repositories/catatan_ayat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCatatanByAyat {
  const GetCatatanByAyat(this._repository);

  final CatatanAyatRepository _repository;

  Either<Failure, CatatanAyat?> call({
    required int suratNomor,
    required int ayatNomor,
  }) => _repository.getByAyat(suratNomor: suratNomor, ayatNomor: ayatNomor);
}
