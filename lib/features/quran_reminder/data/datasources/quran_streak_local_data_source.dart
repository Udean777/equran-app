import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class QuranStreakLocalDataSource {
  /// Ambil streak count saat ini. Returns 0 jika belum ada data.
  Future<int> getStreakCount();

  /// Ambil tanggal terakhir baca. Returns null jika belum pernah baca.
  Future<String?> getLastReadDate();

  /// Simpan streak — date format: 'yyyy-MM-dd'.
  Future<void> saveStreak({required String date, required int count});
}

@LazySingleton(as: QuranStreakLocalDataSource)
class QuranStreakLocalDataSourceImpl implements QuranStreakLocalDataSource {
  const QuranStreakLocalDataSourceImpl(
    @Named('settingsBox') this._box,
  );

  final Box<String> _box;

  static const _lastDateKey = 'quran_streak_last_date';
  static const _countKey = 'quran_streak_count';

  @override
  Future<int> getStreakCount() async {
    final raw = _box.get(_countKey);
    return int.tryParse(raw ?? '') ?? 0;
  }

  @override
  Future<String?> getLastReadDate() async {
    return _box.get(_lastDateKey);
  }

  @override
  Future<void> saveStreak({required String date, required int count}) async {
    await _box.put(_lastDateKey, date);
    await _box.put(_countKey, count.toString());
  }
}
