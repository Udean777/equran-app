import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_by_date.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/get_shalat_stats.dart';
import 'package:equran_app/features/statistik_shalat/domain/usecases/save_shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/cubit/statistik_shalat_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetShalatByDate extends Mock implements GetShalatByDate {}

class MockGetShalatStats extends Mock implements GetShalatStats {}

class MockSaveShalatLog extends Mock implements SaveShalatLog {}

void main() {
  late MockGetShalatByDate mockGetByDate;
  late MockGetShalatStats mockGetStats;
  late MockSaveShalatLog mockSaveLog;

  const tToday = '2026-05-26';

  final tLog = ShalatLog(
    date: tToday,
    waktu: WaktuShalat.subuh,
    status: ShalatStatus.tepatWaktu,
    updatedAt: DateTime(2026, 5, 26, 5),
  );

  final tDayStats = ShalatDayStats(
    date: tToday,
    logs: {WaktuShalat.subuh.key: tLog},
  );

  final tStats = ShalatStats(
    totalHariDenganData: 1,
    totalTepatWaktu: 1,
    streak: 1,
    persentaseTepatWaktu: 1,
    dailyStats: List.generate(
      7,
      (i) => ShalatDayStats(date: '2026-05-${20 + i}'),
    ),
  );

  setUpAll(() {
    registerFallbackValue(tLog);
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    mockGetByDate = MockGetShalatByDate();
    mockGetStats = MockGetShalatStats();
    mockSaveLog = MockSaveShalatLog();
  });

  StatistikShalatCubit buildCubit() => StatistikShalatCubit(
    mockGetByDate,
    mockGetStats,
    mockSaveLog,
  );

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  void mockLoadSuccess() {
    when(() => mockGetByDate(any())).thenReturn(Right(tDayStats));
    when(
      () => mockGetStats(
        dates: any(named: 'dates'),
        today: any(named: 'today'),
      ),
    ).thenReturn(Right(tStats));
  }

  void mockLoadFailure() {
    when(() => mockGetByDate(any())).thenReturn(
      const Left(Failure.unknown(message: 'error')),
    );
    // getStats tidak akan dipanggil karena getByDate sudah gagal,
    // tapi stub tetap diperlukan agar mocktail tidak throw null
    when(
      () => mockGetStats(
        dates: any(named: 'dates'),
        today: any(named: 'today'),
      ),
    ).thenReturn(const Left(Failure.unknown(message: 'error')));
  }

  group('StatistikShalatCubit', () {
    // ─── Initial State ────────────────────────────────────────────────────────

    test('initial state adalah StatistikShalatState.initial()', () {
      expect(
        buildCubit().state,
        const StatistikShalatState.initial(),
      );
    });

    // ─── load() ───────────────────────────────────────────────────────────────

    group('load()', () {
      blocTest<StatistikShalatCubit, StatistikShalatState>(
        'emit [loading, success] jika data berhasil diload',
        build: () {
          mockLoadSuccess();
          return buildCubit();
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          const StatistikShalatState.loading(),
          StatistikShalatState.success(today: tDayStats, stats: tStats),
        ],
      );

      blocTest<StatistikShalatCubit, StatistikShalatState>(
        'emit [loading, success] dengan today kosong jika tidak ada data hari ini',
        build: () {
          when(() => mockGetByDate(any())).thenReturn(const Right(null));
          when(
            () => mockGetStats(
              dates: any(named: 'dates'),
              today: any(named: 'today'),
            ),
          ).thenReturn(Right(tStats));
          return buildCubit();
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          const StatistikShalatState.loading(),
          isA<StatistikShalatState>().having(
            (s) => s.maybeWhen(success: (_, _) => true, orElse: () => false),
            'is success',
            isTrue,
          ),
        ],
      );

      blocTest<StatistikShalatCubit, StatistikShalatState>(
        'emit [loading, failure] jika getByDate gagal',
        build: () {
          mockLoadFailure();
          return buildCubit();
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          const StatistikShalatState.loading(),
          isA<StatistikShalatState>().having(
            (s) => s.maybeWhen(failure: (_) => true, orElse: () => false),
            'is failure',
            isTrue,
          ),
        ],
      );

      blocTest<StatistikShalatCubit, StatistikShalatState>(
        'emit [loading, failure] jika getStats gagal',
        build: () {
          when(() => mockGetByDate(any())).thenReturn(Right(tDayStats));
          when(
            () => mockGetStats(
              dates: any(named: 'dates'),
              today: any(named: 'today'),
            ),
          ).thenReturn(const Left(Failure.unknown(message: 'stats error')));
          return buildCubit();
        },
        act: (cubit) => cubit.load(),
        expect: () => [
          const StatistikShalatState.loading(),
          isA<StatistikShalatState>().having(
            (s) => s.maybeWhen(failure: (_) => true, orElse: () => false),
            'is failure',
            isTrue,
          ),
        ],
      );
    });

    // ─── updateShalat() ───────────────────────────────────────────────────────

    group('updateShalat()', () {
      blocTest<StatistikShalatCubit, StatistikShalatState>(
        'save log lalu reload jika berhasil',
        build: () {
          when(() => mockSaveLog(any())).thenAnswer(
            (_) async => const Right(unit),
          );
          mockLoadSuccess();
          return buildCubit();
        },
        act: (cubit) => cubit.updateShalat(
          waktu: WaktuShalat.subuh,
          status: ShalatStatus.tepatWaktu,
        ),
        expect: () => [
          const StatistikShalatState.loading(),
          StatistikShalatState.success(today: tDayStats, stats: tStats),
        ],
        verify: (_) {
          verify(() => mockSaveLog(any())).called(1);
        },
      );

      blocTest<StatistikShalatCubit, StatistikShalatState>(
        'emit failure jika save gagal',
        build: () {
          when(() => mockSaveLog(any())).thenAnswer(
            (_) async => const Left(Failure.unknown(message: 'save error')),
          );
          return buildCubit();
        },
        act: (cubit) => cubit.updateShalat(
          waktu: WaktuShalat.subuh,
          status: ShalatStatus.tepatWaktu,
        ),
        expect: () => [
          isA<StatistikShalatState>().having(
            (s) => s.maybeWhen(failure: (_) => true, orElse: () => false),
            'is failure',
            isTrue,
          ),
        ],
      );
    });

    // ─── updateShalatForDate() ────────────────────────────────────────────────

    group('updateShalatForDate()', () {
      blocTest<StatistikShalatCubit, StatistikShalatState>(
        'save log untuk tanggal tertentu lalu reload',
        build: () {
          when(() => mockSaveLog(any())).thenAnswer(
            (_) async => const Right(unit),
          );
          mockLoadSuccess();
          return buildCubit();
        },
        act: (cubit) => cubit.updateShalatForDate(
          date: '2026-05-25',
          waktu: WaktuShalat.maghrib,
          status: ShalatStatus.qadha,
          catatan: 'Lupa',
        ),
        expect: () => [
          const StatistikShalatState.loading(),
          StatistikShalatState.success(today: tDayStats, stats: tStats),
        ],
        verify: (_) {
          verify(
            () => mockSaveLog(
              any(
                that: predicate<ShalatLog>(
                  (l) =>
                      l.date == '2026-05-25' &&
                      l.waktu == WaktuShalat.maghrib &&
                      l.status == ShalatStatus.qadha &&
                      l.catatan == 'Lupa',
                ),
              ),
            ),
          ).called(1);
        },
      );
    });
  });
}
