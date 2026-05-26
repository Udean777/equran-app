import 'package:equran_app/features/quran_reminder/data/datasources/quran_streak_local_data_source.dart';
import 'package:equran_app/features/quran_reminder/domain/repositories/quran_streak_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: QuranStreakRepository)
class QuranStreakRepositoryImpl implements QuranStreakRepository {
  const QuranStreakRepositoryImpl(this._dataSource);

  final QuranStreakLocalDataSource _dataSource;

  @override
  Future<int> getStreakCount() => _dataSource.getStreakCount();

  @override
  Future<String?> getLastReadDate() => _dataSource.getLastReadDate();

  @override
  Future<void> saveStreak({required String date, required int count}) =>
      _dataSource.saveStreak(date: date, count: count);
}
