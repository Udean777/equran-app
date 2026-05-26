import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class CatatanAyatRepository {
  Future<Either<Failure, List<CatatanAyat>>> getAll();
  Future<Either<Failure, CatatanAyat?>> getByAyat({
    required int suratNomor,
    required int ayatNomor,
  });
  Future<Either<Failure, Unit>> save(CatatanAyat catatan);
  Future<Either<Failure, Unit>> delete({
    required int suratNomor,
    required int ayatNomor,
  });
}
