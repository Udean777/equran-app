import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/reading_progress/data/datasources/reading_history_local_data_source.dart';
import 'package:equran_app/features/reading_progress/data/repositories/reading_progress_repository_impl.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockReadingHistoryLocalDataSource extends Mock
    implements ReadingHistoryLocalDataSource {}

void main() {
  late MockReadingHistoryLocalDataSource mockDataSource;
  late ReadingProgressRepositoryImpl repository;

  const tDate = '2026-05-26';
  const tDate2 = '2026-05-25';

  const tHistory = ReadingHistory(
    date: tDate,
    ayatRead: {'1:1', '1:2', '1:3', '1:4', '1:5', '1:6', '1:7'},
  );

  const tHistory2 = ReadingHistory(
    date: tDate2,
    ayatRead: {'2:255', '2:256'},
  );

  setUp(() {
    mockDataSource = MockReadingHistoryLocalDataSource();
    repository = ReadingProgressRepositoryImpl(mockDataSource);
  });

  group('ReadingProgressRepositoryImpl', () {
    // ─── getByDate ────────────────────────────────────────────────────────────

    group('getByDate()', () {
      test('return Right(history) jika data ada', () {
        when(() => mockDataSource.getByDate(tDate)).thenReturn(tHistory);

        final result = repository.getByDate(tDate);

        expect(result.isRight(), isTrue);
        final history = result.getOrElse((_) => throw Exception());
        expect(history?.date, tDate);
        expect(history?.ayatRead.length, 7);
      });

      test('return Right(null) jika tidak ada data', () {
        when(() => mockDataSource.getByDate(tDate)).thenReturn(null);

        final result = repository.getByDate(tDate);

        expect(result.isRight(), isTrue);
        expect(result.getOrElse((_) => throw Exception()), isNull);
      });

      test('return Left(Failure) jika datasource throw', () {
        when(() => mockDataSource.getByDate(tDate))
            .thenThrow(Exception('error'));

        final result = repository.getByDate(tDate);

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect(f, isA<UnknownFailure>()),
          (_) => fail('should be left'),
        );
      });
    });

    // ─── saveAyat ─────────────────────────────────────────────────────────────

    group('saveAyat()', () {
      test('return Right(unit) setelah save berhasil', () async {
        when(() => mockDataSource.saveAyat(tDate, '1:1'))
            .thenAnswer((_) async {});

        final result = await repository.saveAyat(tDate, '1:1');

        expect(result, const Right<Failure, Unit>(unit));
        verify(() => mockDataSource.saveAyat(tDate, '1:1')).called(1);
      });

      test('return Left(Failure) jika datasource throw', () async {
        when(() => mockDataSource.saveAyat(any(), any()))
            .thenThrow(Exception('save error'));

        final result = await repository.saveAyat(tDate, '1:1');

        expect(result.isLeft(), isTrue);
      });
    });

    // ─── saveAyatBatch ────────────────────────────────────────────────────────

    group('saveAyatBatch()', () {
      test('return Right(unit) setelah batch save berhasil', () async {
        when(() => mockDataSource.saveAyatBatch(tDate, {'1:1', '1:2'}))
            .thenAnswer((_) async {});

        final result = await repository.saveAyatBatch(tDate, {'1:1', '1:2'});

        expect(result, const Right<Failure, Unit>(unit));
      });
    });

    // ─── cleanupOldData ───────────────────────────────────────────────────────

    group('cleanupOldData()', () {
      test('return Right(unit) setelah cleanup berhasil', () async {
        when(() => mockDataSource.cleanupOldData(90))
            .thenAnswer((_) async {});

        final result = await repository.cleanupOldData(90);

        expect(result, const Right<Failure, Unit>(unit));
        verify(() => mockDataSource.cleanupOldData(90)).called(1);
      });
    });

    // ─── getStats ─────────────────────────────────────────────────────────────

    group('getStats()', () {
      test('hitung totalAyatRead dengan benar', () {
        // tHistory: 7 ayat (surat 1), tHistory2: 2 ayat (surat 2)
        when(() => mockDataSource.getByDateRange(any()))
            .thenReturn([tHistory, tHistory2]);

        final result = repository.getStats(today: tDate);

        expect(result.isRight(), isTrue);
        final stats = result.getOrElse((_) => throw Exception());
        expect(stats.totalAyatRead, 9); // 7 + 2
      });

      test('hitung totalHariDenganData dengan benar', () {
        when(() => mockDataSource.getByDateRange(any()))
            .thenReturn([tHistory, tHistory2]);

        final result = repository.getStats(today: tDate);

        final stats = result.getOrElse((_) => throw Exception());
        expect(stats.totalHariDenganData, 2);
      });

      test('hitung rataRataPerHari dengan benar', () {
        when(() => mockDataSource.getByDateRange(any()))
            .thenReturn([tHistory, tHistory2]);

        final result = repository.getStats(today: tDate);

        final stats = result.getOrElse((_) => throw Exception());
        // 9 ayat / 2 hari = 4.5
        expect(stats.rataRataPerHari, closeTo(4.5, 0.01));
      });

      test('return stats kosong jika tidak ada data', () {
        when(() => mockDataSource.getByDateRange(any())).thenReturn([]);

        final result = repository.getStats(today: tDate);

        expect(result.isRight(), isTrue);
        final stats = result.getOrElse((_) => throw Exception());
        expect(stats.totalAyatRead, 0);
        expect(stats.totalHariDenganData, 0);
        expect(stats.rataRataPerHari, 0.0);
        expect(stats.isEmpty, isTrue);
      });

      test('last90Days berisi 90 hari', () {
        when(() => mockDataSource.getByDateRange(any())).thenReturn([]);

        final result = repository.getStats(today: tDate);

        final stats = result.getOrElse((_) => throw Exception());
        expect(stats.last90Days.length, 90);
      });

      test('progressPerJuz berisi 30 juz', () {
        when(() => mockDataSource.getByDateRange(any())).thenReturn([]);

        final result = repository.getStats(today: tDate);

        final stats = result.getOrElse((_) => throw Exception());
        expect(stats.progressPerJuz.length, 30);
      });

      test('progress juz 1 benar jika ada ayat surat 1 dan 2', () {
        // Surat 1 (7 ayat) + surat 2 (2 ayat) = 9 ayat dari juz 1
        // Total ayat juz 1 = 148
        when(() => mockDataSource.getByDateRange(any()))
            .thenReturn([tHistory, tHistory2]);

        final result = repository.getStats(today: tDate);

        final stats = result.getOrElse((_) => throw Exception());
        final progressJuz1 = stats.progressPerJuz[1] ?? 0.0;
        expect(progressJuz1, closeTo(9 / 148, 0.001));
      });

      test('topSurat berisi surat yang paling banyak dibaca', () {
        when(() => mockDataSource.getByDateRange(any()))
            .thenReturn([tHistory, tHistory2]);

        final result = repository.getStats(today: tDate);

        final stats = result.getOrElse((_) => throw Exception());
        expect(stats.topSurat.isNotEmpty, isTrue);
        // Surat 1 (7 ayat) harus di atas surat 2 (2 ayat)
        expect(stats.topSurat.first.suratNomor, 1);
        expect(stats.topSurat.first.jumlahAyatDibaca, 7);
      });

      test('return Left(Failure) jika datasource throw', () {
        when(() => mockDataSource.getByDateRange(any()))
            .thenThrow(Exception('error'));

        final result = repository.getStats(today: tDate);

        expect(result.isLeft(), isTrue);
      });
    });
  });
}
