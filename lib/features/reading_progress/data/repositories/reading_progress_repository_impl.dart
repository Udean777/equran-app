import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/reading_progress/data/datasources/reading_history_local_data_source.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart';
import 'package:fpdart/fpdart.dart';

class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  const ReadingProgressRepositoryImpl(this._dataSource);

  final ReadingHistoryLocalDataSource _dataSource;

  @override
  Future<Either<Failure, ReadingHistory?>> getByDate(String date) async {
    return _safeCall(() => _dataSource.getByDate(date));
  }

  @override
  Future<Either<Failure, List<ReadingHistory>>> getByDateRange(
    List<String> dates,
  ) async {
    return _safeCall(() => _dataSource.getByDateRange(dates));
  }

  @override
  Future<Either<Failure, Unit>> saveAyat(String date, String ayatId) async {
    return _safeCallUnit(() => _dataSource.saveAyat(date, ayatId));
  }

  @override
  Future<Either<Failure, Unit>> saveAyatBatch(
    String date,
    Set<String> ayatIds,
  ) async {
    return _safeCallUnit(() => _dataSource.saveAyatBatch(date, ayatIds));
  }

  @override
  Future<Either<Failure, Unit>> cleanupOldData(int retentionDays) async {
    return _safeCallUnit(() => _dataSource.cleanupOldData(retentionDays));
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
