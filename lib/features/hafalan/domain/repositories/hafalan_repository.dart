import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class HafalanRepository {
  Future<Either<Failure, List<HafalanSurat>>> getAllHafalan();
  Future<Either<Failure, HafalanSurat?>> getHafalanBySurat(int suratNomor);
  Future<Either<Failure, Unit>> saveHafalanSurat(HafalanSurat hafalan);
  Future<Either<Failure, Unit>> deleteHafalanSurat(int suratNomor);
  Future<Either<Failure, HafalanStats>> getHafalanStats();
}
