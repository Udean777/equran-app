import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/statistik_shalat/data/datasources/shalat_log_local_data_source.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: StatistikShalatRepository)
class StatistikShalatRepositoryImpl implements StatistikShalatRepository {
  const StatistikShalatRepositoryImpl(this._dataSource);

  final ShalatLogLocalDataSource _dataSource;

  @override
  Future<Either<Failure, ShalatDayStats?>> getByDate(String date) async {
    try {
      final result = await _dataSource.getByDate(date);
      return Right(result);
      // Menangkap HiveError secara spesifik untuk membedakan error storage
      // ignore: avoid_catching_errors
    } on HiveError catch (_) {
      return const Left(Failure.storage());
    } on FormatException catch (_) {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShalatDayStats>>> getByDateRange(
    List<String> dates,
  ) async {
    try {
      final result = await _dataSource.getByDateRange(dates);
      return Right(result);
      // Menangkap HiveError secara spesifik untuk membedakan error storage
      // ignore: avoid_catching_errors
    } on HiveError catch (_) {
      return const Left(Failure.storage());
    } on FormatException catch (_) {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLog(ShalatLog log) async {
    try {
      await _dataSource.saveLog(log);
      return const Right(unit);
      // Menangkap HiveError secara spesifik untuk membedakan error storage
      // ignore: avoid_catching_errors
    } on HiveError catch (_) {
      return const Left(Failure.storage());
    } on FormatException catch (_) {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteByDate(String date) async {
    try {
      await _dataSource.deleteByDate(date);
      return const Right(unit);
      // Menangkap HiveError secara spesifik untuk membedakan error storage
      // ignore: avoid_catching_errors
    } on HiveError catch (_) {
      return const Left(Failure.storage());
    } on FormatException catch (_) {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
