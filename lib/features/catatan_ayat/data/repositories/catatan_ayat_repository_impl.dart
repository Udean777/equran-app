import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/catatan_ayat/data/datasources/catatan_ayat_local_datasource.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/domain/repositories/catatan_ayat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CatatanAyatRepository)
class CatatanAyatRepositoryImpl implements CatatanAyatRepository {
  const CatatanAyatRepositoryImpl(this._datasource);

  final CatatanAyatLocalDatasource _datasource;

  @override
  Either<Failure, List<CatatanAyat>> getAll() {
    try {
      return Right(_datasource.getAll());
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Either<Failure, CatatanAyat?> getByAyat({
    required int suratNomor,
    required int ayatNomor,
  }) {
    try {
      return Right(
        _datasource.getByAyat(suratNomor: suratNomor, ayatNomor: ayatNomor),
      );
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> save(CatatanAyat catatan) async {
    try {
      await _datasource.save(catatan);
      return const Right(unit);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    try {
      await _datasource.delete(suratNomor: suratNomor, ayatNomor: ayatNomor);
      return const Right(unit);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
