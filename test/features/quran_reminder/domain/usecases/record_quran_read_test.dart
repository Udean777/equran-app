import 'package:equran_app/features/quran_reminder/domain/repositories/quran_streak_repository.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/record_quran_read.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

class MockQuranStreakRepository extends Mock implements QuranStreakRepository {}

void main() {
  late MockQuranStreakRepository mockRepository;
  late RecordQuranRead useCase;

  final dateFormat = DateFormat('yyyy-MM-dd');
  final today = dateFormat.format(DateTime.now());
  final yesterday = dateFormat.format(
    DateTime.now().subtract(const Duration(days: 1)),
  );
  final twoDaysAgo = dateFormat.format(
    DateTime.now().subtract(const Duration(days: 2)),
  );

  setUp(() {
    mockRepository = MockQuranStreakRepository();
    useCase = RecordQuranRead(mockRepository);
  });

  test('tidak update jika sudah baca hari ini', () async {
    when(() => mockRepository.getLastReadDate()).thenAnswer((_) async => today);

    final result = await useCase(5);

    expect(result, 5);
    verifyNever(
      () => mockRepository.saveStreak(date: any(named: 'date'), count: any(named: 'count')),
    );
  });

  test('increment streak jika baca kemarin', () async {
    when(() => mockRepository.getLastReadDate())
        .thenAnswer((_) async => yesterday);
    when(
      () => mockRepository.saveStreak(date: today, count: 6),
    ).thenAnswer((_) async {});

    final result = await useCase(5);

    expect(result, 6);
    verify(() => mockRepository.saveStreak(date: today, count: 6)).called(1);
  });

  test('reset ke 1 jika lebih dari kemarin', () async {
    when(() => mockRepository.getLastReadDate())
        .thenAnswer((_) async => twoDaysAgo);
    when(
      () => mockRepository.saveStreak(date: today, count: 1),
    ).thenAnswer((_) async {});

    final result = await useCase(5);

    expect(result, 1);
    verify(() => mockRepository.saveStreak(date: today, count: 1)).called(1);
  });

  test('reset ke 1 jika belum pernah baca (null)', () async {
    when(() => mockRepository.getLastReadDate()).thenAnswer((_) async => null);
    when(
      () => mockRepository.saveStreak(date: today, count: 1),
    ).thenAnswer((_) async {});

    final result = await useCase(0);

    expect(result, 1);
    verify(() => mockRepository.saveStreak(date: today, count: 1)).called(1);
  });
}
