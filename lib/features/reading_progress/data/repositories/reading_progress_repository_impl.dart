import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/reading_progress/data/datasources/reading_history_local_data_source.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/domain/repositories/reading_progress_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReadingProgressRepository)
class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  const ReadingProgressRepositoryImpl(this._dataSource);

  final ReadingHistoryLocalDataSource _dataSource;

  @override
  Future<Either<Failure, ReadingHistory?>> getByDate(String date) async {
    try {
      final result = await _dataSource.getByDate(date);
      return Right(result);
    } on FormatException {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      if (e is HiveError) return const Left(Failure.storage());
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReadingHistory>>> getByDateRange(
    List<String> dates,
  ) async {
    try {
      final result = await _dataSource.getByDateRange(dates);
      return Right(result);
    } on FormatException {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      if (e is HiveError) return const Left(Failure.storage());
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveAyat(String date, String ayatId) async {
    try {
      await _dataSource.saveAyat(date, ayatId);
      return const Right(unit);
    } on FormatException {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      if (e is HiveError) return const Left(Failure.storage());
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveAyatBatch(
    String date,
    Set<String> ayatIds,
  ) async {
    try {
      await _dataSource.saveAyatBatch(date, ayatIds);
      return const Right(unit);
    } on FormatException {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      if (e is HiveError) return const Left(Failure.storage());
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> cleanupOldData(int retentionDays) async {
    try {
      await _dataSource.cleanupOldData(retentionDays);
      return const Right(unit);
    } on FormatException {
      return const Left(Failure.parsing());
    } on Object catch (e) {
      if (e is HiveError) return const Left(Failure.storage());
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
