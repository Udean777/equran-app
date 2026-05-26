import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/cleanup_old_reading_data.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/get_reading_stats.dart';
import 'package:equran_app/features/reading_progress/domain/usecases/save_ayat_read.dart';
import 'package:equran_app/features/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetReadingStats extends Mock implements GetReadingStats {}

class MockSaveAyatReadBatch extends Mock implements SaveAyatReadBatch {}

class MockCleanupOldReadingData extends Mock implements CleanupOldReadingData {}

void main() {
  late MockGetReadingStats mockGetStats;
  late MockSaveAyatReadBatch mockSaveBatch;
  late MockCleanupOldReadingData mockCleanup;

  final tStats = ReadingStats(
    totalAyatRead: 10,
    totalHariDenganData: 2,
    rataRataPerHari: 5,
    progressPerJuz: {for (var i = 1; i <= 30; i++) i: 0.0},
    last90Days: List.generate(90, (i) => ReadingHistory(date: '2026-05-${(i % 28) + 1}'.padLeft(10, '0'))),
  );

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(<String>{});
  });

  setUp(() {
    mockGetStats = MockGetReadingStats();
    mockSaveBatch = MockSaveAyatReadBatch();
    mockCleanup = MockCleanupOldReadingData();

    // Default: cleanup selalu sukses
    when(() => mockCleanup(retentionDays: any(named: 'retentionDays')))
        .thenAnswer((_) async => const Right(unit));
  });

  ReadingProgressCubit buildCubit() => ReadingProgressCubit(
    mockGetStats,
    mockSaveBatch,
    mockCleanup,
  );

  group('ReadingProgressCubit', () {
    // ─── Initial State ────────────────────────────────────────────────────────

    test('initial state adalah ReadingProgressState.initial()', () {
      expect(
        buildCubit().state,
        const ReadingProgressState.initial(),
      );
    });

    // ─── load() ───────────────────────────────────────────────────────────────

    group('load()', () {
      blocTest<ReadingProgressCubit, ReadingProgressState>(
        'emit [loading, success] jika getStats berhasil',
        build: () {
          when(() => mockGetStats(today: any(named: 'today')))
              .thenReturn(Right(tStats));
          return buildCubit();
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          const ReadingProgressState.loading(),
          ReadingProgressState.success(tStats),
        ],
        verify: (_) {
          verify(
            () => mockCleanup(retentionDays: any(named: 'retentionDays')),
          ).called(1);
        },
      );

      blocTest<ReadingProgressCubit, ReadingProgressState>(
        'emit [loading, failure] jika getStats gagal',
        build: () {
          when(() => mockGetStats(today: any(named: 'today')))
              .thenReturn(const Left(Failure.unknown(message: 'error')));
          return buildCubit();
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          const ReadingProgressState.loading(),
          isA<ReadingProgressState>().having(
            (s) => s.maybeWhen(failure: (_) => true, orElse: () => false),
            'is failure',
            isTrue,
          ),
        ],
      );
    });

    // ─── bufferAyat() ─────────────────────────────────────────────────────────

    group('bufferAyat()', () {
      test('tidak emit state baru saat buffer ayat', () {
        final cubit = buildCubit()
          ..bufferAyat(1, 1)
          ..bufferAyat(1, 2)
          ..bufferAyat(2, 255);

        // State tidak berubah
        expect(cubit.state, const ReadingProgressState.initial());
      });
    });

    // ─── flushBuffer() ────────────────────────────────────────────────────────

    group('flushBuffer()', () {
      test('flush buffer ke Hive jika ada pending ayat', () async {
        when(() => mockSaveBatch(any(), any()))
            .thenAnswer((_) async => const Right(unit));

        final cubit = buildCubit()
          ..bufferAyat(1, 1)
          ..bufferAyat(1, 2);

        await cubit.flushBuffer();

        verify(() => mockSaveBatch(any(), any())).called(1);
      });

      test('tidak call saveBatch jika buffer kosong', () async {
        final cubit = buildCubit();

        await cubit.flushBuffer();

        verifyNever(() => mockSaveBatch(any(), any()));
      });

      test('buffer kosong setelah flush', () async {
        when(() => mockSaveBatch(any(), any()))
            .thenAnswer((_) async => const Right(unit));

        final cubit = buildCubit()..bufferAyat(1, 1);
        await cubit.flushBuffer();

        // Flush kedua tidak call saveBatch
        await cubit.flushBuffer();
        verify(() => mockSaveBatch(any(), any())).called(1);
      });
    });

    // ─── close() ──────────────────────────────────────────────────────────────

    group('close()', () {
      test('flush buffer sebelum close jika ada pending ayat', () async {
        when(() => mockSaveBatch(any(), any()))
            .thenAnswer((_) async => const Right(unit));

        final cubit = buildCubit()..bufferAyat(1, 1);
        await cubit.close();

        verify(() => mockSaveBatch(any(), any())).called(1);
      });

      test('tidak call saveBatch saat close jika buffer kosong', () async {
        final cubit = buildCubit();
        await cubit.close();

        verifyNever(() => mockSaveBatch(any(), any()));
      });
    });

    // ─── didChangeAppLifecycleState() ─────────────────────────────────────────

    group('didChangeAppLifecycleState()', () {
      test('flush buffer saat app paused', () async {
        when(() => mockSaveBatch(any(), any()))
            .thenAnswer((_) async => const Right(unit));

        buildCubit()
          ..bufferAyat(1, 1)
          ..didChangeAppLifecycleState(AppLifecycleState.paused);

        // Beri waktu async flush selesai
        await Future<void>.delayed(Duration.zero);

        verify(() => mockSaveBatch(any(), any())).called(1);
      });

      test('flush buffer saat app detached', () async {
        when(() => mockSaveBatch(any(), any()))
            .thenAnswer((_) async => const Right(unit));

        buildCubit()
          ..bufferAyat(2, 255)
          ..didChangeAppLifecycleState(AppLifecycleState.detached);

        await Future<void>.delayed(Duration.zero);

        verify(() => mockSaveBatch(any(), any())).called(1);
      });

      test('tidak flush saat app resumed', () async {
        buildCubit()
          ..bufferAyat(1, 1)
          ..didChangeAppLifecycleState(AppLifecycleState.resumed);

        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockSaveBatch(any(), any()));
      });
    });
  });
}
