import 'package:equran_app/features/quran_reminder/data/datasources/quran_streak_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<String> {}

void main() {
  late MockBox mockBox;
  late QuranStreakLocalDataSourceImpl dataSource;

  setUp(() {
    mockBox = MockBox();
    dataSource = QuranStreakLocalDataSourceImpl(mockBox);
  });

  group('getStreakCount()', () {
    test('returns 0 jika belum ada data', () async {
      when(() => mockBox.get('quran_streak_count')).thenReturn(null);

      final result = await dataSource.getStreakCount();

      expect(result, 0);
    });

    test('returns nilai yang tersimpan', () async {
      when(() => mockBox.get('quran_streak_count')).thenReturn('7');

      final result = await dataSource.getStreakCount();

      expect(result, 7);
    });

    test('returns 0 jika nilai bukan angka valid', () async {
      when(() => mockBox.get('quran_streak_count')).thenReturn('invalid');

      final result = await dataSource.getStreakCount();

      expect(result, 0);
    });
  });

  group('getLastReadDate()', () {
    test('returns null jika belum ada data', () async {
      when(() => mockBox.get('quran_streak_last_date')).thenReturn(null);

      final result = await dataSource.getLastReadDate();

      expect(result, isNull);
    });

    test('returns tanggal yang tersimpan', () async {
      when(() => mockBox.get('quran_streak_last_date'))
          .thenReturn('2026-05-26');

      final result = await dataSource.getLastReadDate();

      expect(result, '2026-05-26');
    });
  });

  group('saveStreak()', () {
    test('menyimpan date dan count dengan benar', () async {
      when(
        () => mockBox.put('quran_streak_last_date', '2026-05-26'),
      ).thenAnswer((_) async {});
      when(
        () => mockBox.put('quran_streak_count', '5'),
      ).thenAnswer((_) async {});

      await dataSource.saveStreak(date: '2026-05-26', count: 5);

      verify(() => mockBox.put('quran_streak_last_date', '2026-05-26'))
          .called(1);
      verify(() => mockBox.put('quran_streak_count', '5')).called(1);
    });
  });
}
