import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/quran_reminder/data/datasources/quran_streak_local_data_source.dart';
import 'package:equran_app/features/quran_reminder/domain/repositories/quran_streak_repository.dart';
import 'package:fpdart/fpdart.dart';

class QuranStreakRepositoryImpl implements QuranStreakRepository {
  const QuranStreakRepositoryImpl(this._dataSource);

  final QuranStreakLocalDataSource _dataSource;

  @override
  Future<Either<Failure, int>> getStreakCount() async {
    try {
      return right(await _dataSource.getStreakCount());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getLastReadDate() async {
    try {
      return right(await _dataSource.getLastReadDate());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveStreak({
    required String date,
    required int count,
  }) async {
    try {
      await _dataSource.saveStreak(date: date, count: count);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
