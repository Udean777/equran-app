import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/statistik_shalat/data/datasources/shalat_log_local_data_source.dart';
import 'package:equran_app/features/statistik_shalat/data/repositories/statistik_shalat_repository_impl.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockShalatLogLocalDataSource extends Mock
    implements ShalatLogLocalDataSource {}

void main() {
  late MockShalatLogLocalDataSource mockDataSource;
  late StatistikShalatRepositoryImpl repository;

  const tDate = '2026-05-26';
  const tDate2 = '2026-05-25';

  final tLog = ShalatLog(
    date: tDate,
    waktu: WaktuShalat.subuh,
    status: ShalatStatus.tepatWaktu,
    updatedAt: DateTime(2026, 5, 26, 5),
  );

  final tDayStats = ShalatDayStats(
    date: tDate,
    logs: {
      WaktuShalat.subuh.key: tLog,
      WaktuShalat.dzuhur.key: const ShalatLog(
        date: tDate,
        waktu: WaktuShalat.dzuhur,
        status: ShalatStatus.tepatWaktu,
      ),
      WaktuShalat.ashar.key: const ShalatLog(
        date: tDate,
        waktu: WaktuShalat.ashar,
        status: ShalatStatus.tepatWaktu,
      ),
      WaktuShalat.maghrib.key: const ShalatLog(
        date: tDate,
        waktu: WaktuShalat.maghrib,
        status: ShalatStatus.tepatWaktu,
      ),
      WaktuShalat.isya.key: const ShalatLog(
        date: tDate,
        waktu: WaktuShalat.isya,
        status: ShalatStatus.tepatWaktu,
      ),
    },
  );

  setUp(() {
    mockDataSource = MockShalatLogLocalDataSource();
    repository = StatistikShalatRepositoryImpl(mockDataSource);
    registerFallbackValue(tLog);
  });

  group('StatistikShalatRepositoryImpl', () {
    // ─── getByDate ────────────────────────────────────────────────────────────

    group('getByDate()', () {
      test('return Right(ShalatDayStats) jika data ada', () {
        when(() => mockDataSource.getByDate(tDate)).thenReturn(tDayStats);

        final result = repository.getByDate(tDate);

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('should be right'),
          (stats) {
            expect(stats, isNotNull);
            expect(stats!.date, tDate);
          },
        );
      });

      test('return Right(null) jika tidak ada data', () {
        when(() => mockDataSource.getByDate(tDate)).thenReturn(null);

        final result = repository.getByDate(tDate);

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('should be right'),
          (stats) => expect(stats, isNull),
        );
      });

      test('return Left(Failure) jika datasource throw', () {
        when(() => mockDataSource.getByDate(tDate)).thenThrow(Exception('err'));

        final result = repository.getByDate(tDate);

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (_) => fail('should be left'),
        );
      });
    });

    // ─── getByDateRange ───────────────────────────────────────────────────────

    group('getByDateRange()', () {
      test('return Right(list) dari datasource', () {
        when(
          () => mockDataSource.getByDateRange([tDate, tDate2]),
        ).thenReturn([tDayStats]);

        final result = repository.getByDateRange([tDate, tDate2]);

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('should be right'),
          (list) => expect(list.length, 1),
        );
      });
    });

    // ─── saveLog ──────────────────────────────────────────────────────────────

    group('saveLog()', () {
      test('return Right(unit) setelah save berhasil', () async {
        when(() => mockDataSource.saveLog(any())).thenAnswer((_) async {});

        final result = await repository.saveLog(tLog);

        expect(result, const Right<Failure, Unit>(unit));
        verify(() => mockDataSource.saveLog(tLog)).called(1);
      });

      test('return Left(Failure) jika datasource throw', () async {
        when(
          () => mockDataSource.saveLog(any()),
        ).thenThrow(Exception('save error'));

        final result = await repository.saveLog(tLog);

        expect(result.isLeft(), isTrue);
      });
    });

    // ─── deleteByDate ─────────────────────────────────────────────────────────

    group('deleteByDate()', () {
      test('return Right(unit) setelah delete berhasil', () async {
        when(() => mockDataSource.deleteByDate(tDate)).thenAnswer((_) async {});

        final result = await repository.deleteByDate(tDate);

        expect(result, const Right<Failure, Unit>(unit));
      });
    });

    // ─── getStats ─────────────────────────────────────────────────────────────

    group('getStats()', () {
      test('hitung persentase tepat waktu dengan benar', () {
        // tDayStats: 5 tepatWaktu, 0 qadha, 0 tidakShalat
        when(
          () => mockDataSource.getByDateRange([tDate]),
        ).thenReturn([tDayStats]);
        when(() => mockDataSource.getByDate(tDate)).thenReturn(tDayStats);

        final result = repository.getStats(dates: [tDate], today: tDate);

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('should be right'),
          (stats) {
            expect(stats.totalTepatWaktu, 5);
            expect(stats.totalQadha, 0);
            expect(stats.persentaseTepatWaktu, 1.0);
            expect(stats.totalHariDenganData, 1);
          },
        );
      });

      test('streak = 1 jika hari ini ada data, kemarin tidak', () {
        when(
          () => mockDataSource.getByDateRange([tDate]),
        ).thenReturn([tDayStats]);
        // Stub spesifik: hari ini ada data, semua tanggal lain null
        // any() harus di-register SEBELUM stub spesifik agar tidak override
        when(() => mockDataSource.getByDate(any())).thenReturn(null);
        when(() => mockDataSource.getByDate(tDate)).thenReturn(tDayStats);

        final result = repository.getStats(dates: [tDate], today: tDate);

        expect(result.isRight(), isTrue);
        final stats = result.getOrElse((_) => throw Exception());
        expect(stats.streak, 1);
      });

      test('return Right dengan stats kosong jika tidak ada data', () {
        when(() => mockDataSource.getByDateRange(any())).thenReturn([]);
        when(() => mockDataSource.getByDate(any())).thenReturn(null);

        final result = repository.getStats(dates: [tDate], today: tDate);

        expect(result.isRight(), isTrue);
        final stats = result.getOrElse((_) => throw Exception());
        expect(stats.totalTepatWaktu, 0);
        expect(stats.streak, 0);
        expect(stats.persentaseTepatWaktu, 0.0);
      });

      test('dailyStats berisi 7 hari terakhir', () {
        when(() => mockDataSource.getByDateRange(any())).thenReturn([]);
        when(() => mockDataSource.getByDate(any())).thenReturn(null);

        final result = repository.getStats(dates: [tDate], today: tDate);

        expect(result.isRight(), isTrue);
        final stats = result.getOrElse((_) => throw Exception());
        expect(stats.dailyStats.length, 7);
      });
    });
  });
}
