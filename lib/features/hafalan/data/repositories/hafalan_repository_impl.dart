import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/data/datasources/hafalan_local_datasource.dart';
import 'package:equran_app/features/hafalan/data/mappers/hafalan_mapper.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:equran_app/features/hafalan/domain/services/hafalan_stats_calculator.dart';
import 'package:fpdart/fpdart.dart';

class HafalanRepositoryImpl implements HafalanRepository {
  const HafalanRepositoryImpl(this._datasource);

  final HafalanLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<HafalanSurat>>> getAllHafalan() async {
    try {
      final dtos = await _datasource.getAll();
      final resolved = dtos
          .map((dto) => HafalanStatsCalculator.resolveStatus(dto.toEntity()))
          .toList();
      return Right(resolved);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HafalanSurat?>> getHafalanBySurat(
    int suratNomor,
  ) async {
    try {
      final dto = await _datasource.getBySurat(suratNomor);
      if (dto == null) return const Right(null);
      return Right(HafalanStatsCalculator.resolveStatus(dto.toEntity()));
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveHafalanSurat(HafalanSurat hafalan) async {
    try {
      await _datasource.save(hafalan.toDto());
      return const Right(unit);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteHafalanSurat(int suratNomor) async {
    try {
      await _datasource.delete(suratNomor);
      return const Right(unit);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HafalanStats>> getHafalanStats() async {
    try {
      final list = (await _datasource.getAll())
          .map((dto) => HafalanStatsCalculator.resolveStatus(dto.toEntity()))
          .toList();
      return Right(HafalanStatsCalculator.compute(list));
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
