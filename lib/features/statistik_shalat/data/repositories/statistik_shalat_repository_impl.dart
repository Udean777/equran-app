import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/statistik_shalat/data/datasources/shalat_log_local_data_source.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/repositories/statistik_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';

class StatistikShalatRepositoryImpl implements StatistikShalatRepository {
  const StatistikShalatRepositoryImpl(this._dataSource);

  final ShalatLogLocalDataSource _dataSource;

  @override
  Future<Either<Failure, ShalatDayStats?>> getByDate(String date) async {
    return _safeCall(() => _dataSource.getByDate(date));
  }

  @override
  Future<Either<Failure, List<ShalatDayStats>>> getByDateRange(
    List<String> dates,
  ) async {
    return _safeCall(() => _dataSource.getByDateRange(dates));
  }

  @override
  Future<Either<Failure, Unit>> saveLog(ShalatLog log) async {
    return _safeCallUnit(() => _dataSource.saveLog(log));
  }

  @override
  Future<Either<Failure, Unit>> deleteByDate(String date) async {
    return _safeCallUnit(() => _dataSource.deleteByDate(date));
  }

  static Future<Either<Failure, T>> _safeCall<T>(
    Future<T> Function() block,
  ) async {
    try {
      return Right(await block());
    } on FormatException {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  static Future<Either<Failure, Unit>> _safeCallUnit(
    Future<void> Function() block,
  ) async {
    try {
      await block();
      return const Right(unit);
    } on FormatException {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
