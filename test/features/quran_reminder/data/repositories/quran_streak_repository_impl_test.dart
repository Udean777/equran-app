import 'package:equran_app/features/quran_reminder/data/datasources/quran_streak_local_data_source.dart';
import 'package:equran_app/features/quran_reminder/data/repositories/quran_streak_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockQuranStreakLocalDataSource extends Mock
    implements QuranStreakLocalDataSource {}

void main() {
  late MockQuranStreakLocalDataSource mockDataSource;
  late QuranStreakRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockQuranStreakLocalDataSource();
    repository = QuranStreakRepositoryImpl(mockDataSource);
  });

  test('getStreakCount() delegates ke datasource', () async {
    when(() => mockDataSource.getStreakCount()).thenAnswer((_) async => 3);

    final result = await repository.getStreakCount();

    expect(result, 3);
    verify(() => mockDataSource.getStreakCount()).called(1);
  });

  test('getLastReadDate() delegates ke datasource', () async {
    when(() => mockDataSource.getLastReadDate())
        .thenAnswer((_) async => '2026-05-25');

    final result = await repository.getLastReadDate();

    expect(result, '2026-05-25');
    verify(() => mockDataSource.getLastReadDate()).called(1);
  });

  test('saveStreak() delegates ke datasource', () async {
    when(
      () => mockDataSource.saveStreak(date: '2026-05-26', count: 4),
    ).thenAnswer((_) async {});

    await repository.saveStreak(date: '2026-05-26', count: 4);

    verify(
      () => mockDataSource.saveStreak(date: '2026-05-26', count: 4),
    ).called(1);
  });
}
