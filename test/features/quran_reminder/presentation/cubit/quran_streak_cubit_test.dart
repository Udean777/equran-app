import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/get_streak_count.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/record_quran_read.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetStreakCount extends Mock implements GetStreakCount {}

class MockRecordQuranRead extends Mock implements RecordQuranRead {}

void main() {
  late MockGetStreakCount mockGetStreakCount;
  late MockRecordQuranRead mockRecordQuranRead;

  setUp(() {
    mockGetStreakCount = MockGetStreakCount();
    mockRecordQuranRead = MockRecordQuranRead();
  });

  QuranStreakCubit buildCubit() =>
      QuranStreakCubit(mockGetStreakCount, mockRecordQuranRead);

  group('load()', () {
    blocTest<QuranStreakCubit, QuranStreakState>(
      'emit loaded(7) dari use case',
      build: buildCubit,
      setUp: () {
        when(() => mockGetStreakCount()).thenAnswer((_) async => 7);
      },
      act: (cubit) => cubit.load(),
      expect: () => [const QuranStreakState.loaded(7)],
    );
  });

  group('recordRead()', () {
    blocTest<QuranStreakCubit, QuranStreakState>(
      'emit loaded(4) jika streak berubah',
      build: buildCubit,
      seed: () => const QuranStreakState.loaded(3),
      setUp: () {
        when(() => mockRecordQuranRead(3)).thenAnswer((_) async => 4);
      },
      act: (cubit) => cubit.recordRead(),
      expect: () => [const QuranStreakState.loaded(4)],
    );

    blocTest<QuranStreakCubit, QuranStreakState>(
      'tidak emit jika streak tidak berubah (sudah baca hari ini)',
      build: buildCubit,
      seed: () => const QuranStreakState.loaded(3),
      setUp: () {
        when(() => mockRecordQuranRead(3)).thenAnswer((_) async => 3);
      },
      act: (cubit) => cubit.recordRead(),
      expect: () => <QuranStreakState>[],
    );
  });
}
