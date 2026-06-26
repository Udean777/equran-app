import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/catatan_ayat/data/datasources/catatan_ayat_local_data_source.dart';
import 'package:equran_app/features/catatan_ayat/data/mappers/catatan_ayat_mapper.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/domain/repositories/catatan_ayat_repository.dart';
import 'package:fpdart/fpdart.dart';

class CatatanAyatRepositoryImpl implements CatatanAyatRepository {
  const CatatanAyatRepositoryImpl(this._datasource);

  final CatatanAyatLocalDataSource _datasource;

  @override
  Future<Either<Failure, List<CatatanAyat>>> getAll() async {
    try {
      final dtos = await _datasource.getAll();
      return Right(dtos.map((e) => e.toEntity()).toList());
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CatatanAyat?>> getByAyat({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    try {
      final dto = await _datasource.getByAyat(
        suratNomor: suratNomor,
        ayatNomor: ayatNomor,
      );
      return Right(dto?.toEntity());
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> save(CatatanAyat catatan) async {
    try {
      await _datasource.save(catatan.toDto());
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
