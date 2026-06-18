import 'dart:convert';

import 'package:equran_app/features/reading_progress/data/datasources/reading_history_local_data_source.dart';
import 'package:equran_app/features/reading_progress/data/mappers/reading_history_mapper.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<String> {}

void main() {
  late MockBox mockBox;
  late ReadingHistoryLocalDataSourceImpl datasource;

  const tDate = '2026-05-26';
  const tDate2 = '2026-05-25';
  const tAyatId1 = '1:1';
  const tAyatId2 = '1:2';
  const tAyatId3 = '2:255';

  const tHistory = ReadingHistory(
    date: tDate,
    ayatRead: {tAyatId1, tAyatId2},
  );

  String encodeHistory(ReadingHistory h) => jsonEncode(h.toDto().toJson());

  setUp(() {
    mockBox = MockBox();
    datasource = ReadingHistoryLocalDataSourceImpl(mockBox);
  });

  group('ReadingHistoryLocalDataSource', () {
    // ─── getByDate ────────────────────────────────────────────────────────────

    group('getByDate()', () {
      test('return ReadingHistory jika key ada', () {
        when(
          () => mockBox.get('reading_$tDate'),
        ).thenReturn(encodeHistory(tHistory));

        final result = datasource.getByDate(tDate);

        expect(result, isNotNull);
        expect(result!.date, tDate);
        expect(result.ayatRead, {tAyatId1, tAyatId2});
      });

      test('return null jika key tidak ada', () {
        when(() => mockBox.get('reading_$tDate')).thenReturn(null);

        final result = datasource.getByDate(tDate);

        expect(result, isNull);
      });

      test('return null jika JSON corrupt', () {
        when(() => mockBox.get('reading_$tDate')).thenReturn('invalid_json');

        final result = datasource.getByDate(tDate);

        expect(result, isNull);
      });
    });

    // ─── getByDateRange ───────────────────────────────────────────────────────

    group('getByDateRange()', () {
      test('return list history untuk tanggal yang ada', () {
        when(
          () => mockBox.get('reading_$tDate'),
        ).thenReturn(encodeHistory(tHistory));
        when(() => mockBox.get('reading_$tDate2')).thenReturn(null);

        final result = datasource.getByDateRange([tDate, tDate2]);

        expect(result.length, 1);
        expect(result.first.date, tDate);
      });

      test('return list kosong jika semua tanggal tidak ada data', () {
        when(() => mockBox.get(any<String>())).thenReturn(null);

        final result = datasource.getByDateRange([tDate, tDate2]);

        expect(result, isEmpty);
      });
    });

    // ─── saveAyat ─────────────────────────────────────────────────────────────

    group('saveAyat()', () {
      test('simpan ayat baru ke Hive', () async {
        when(() => mockBox.get('reading_$tDate')).thenReturn(null);
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((_) async {});

        await datasource.saveAyat(tDate, tAyatId1);

        verify(() => mockBox.put('reading_$tDate', any<String>())).called(1);
      });

      test('merge ayat baru dengan existing', () async {
        when(
          () => mockBox.get('reading_$tDate'),
        ).thenReturn(encodeHistory(tHistory));

        String? savedJson;
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((inv) async {
          savedJson = inv.positionalArguments[1] as String;
        });

        await datasource.saveAyat(tDate, tAyatId3);

        expect(savedJson, isNotNull);
        final decoded = jsonDecode(savedJson!) as Map<String, dynamic>;
        final ayatList = (decoded['ayatRead'] as List).cast<String>();
        expect(ayatList, containsAll([tAyatId1, tAyatId2, tAyatId3]));
      });

      test('skip jika ayat sudah ada (tidak write ke Hive)', () async {
        when(
          () => mockBox.get('reading_$tDate'),
        ).thenReturn(encodeHistory(tHistory));

        await datasource.saveAyat(tDate, tAyatId1); // sudah ada

        verifyNever(() => mockBox.put(any<String>(), any<String>()));
      });
    });

    // ─── saveAyatBatch ────────────────────────────────────────────────────────

    group('saveAyatBatch()', () {
      test('simpan batch ayat baru', () async {
        when(() => mockBox.get('reading_$tDate')).thenReturn(null);
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((_) async {});

        await datasource.saveAyatBatch(tDate, {tAyatId1, tAyatId2});

        verify(() => mockBox.put('reading_$tDate', any<String>())).called(1);
      });

      test('skip jika semua ayat sudah ada', () async {
        when(
          () => mockBox.get('reading_$tDate'),
        ).thenReturn(encodeHistory(tHistory));

        await datasource.saveAyatBatch(tDate, {tAyatId1, tAyatId2});

        verifyNever(() => mockBox.put(any<String>(), any<String>()));
      });

      test('skip jika ayatIds kosong', () async {
        await datasource.saveAyatBatch(tDate, {});

        verifyNever(() => mockBox.get(any<String>()));
        verifyNever(() => mockBox.put(any<String>(), any<String>()));
      });
    });

    // ─── deleteByDate ─────────────────────────────────────────────────────────

    group('deleteByDate()', () {
      test('hapus data dari Hive', () async {
        when(
          () => mockBox.delete(any<String>()),
        ).thenAnswer((_) async {});

        await datasource.deleteByDate(tDate);

        verify(() => mockBox.delete('reading_$tDate')).called(1);
      });
    });

    // ─── cleanupOldData ───────────────────────────────────────────────────────

    group('cleanupOldData()', () {
      test('hapus key yang lebih lama dari retentionDays', () async {
        // Key lama (lebih dari 90 hari)
        when(() => mockBox.keys).thenReturn([
          'reading_2025-01-01', // lama → hapus
          'reading_2026-05-26', // baru → keep
          'other_key', // bukan reading → skip
        ]);
        when(
          () => mockBox.delete(any<String>()),
        ).thenAnswer((_) async {});

        await datasource.cleanupOldData(90);

        verify(() => mockBox.delete('reading_2025-01-01')).called(1);
        verifyNever(() => mockBox.delete('reading_2026-05-26'));
        verifyNever(() => mockBox.delete('other_key'));
      });
    });

    // ─── getAllDates ──────────────────────────────────────────────────────────

    group('getAllDates()', () {
      test('return list tanggal sorted ascending', () {
        when(() => mockBox.keys).thenReturn([
          'reading_2026-05-26',
          'reading_2026-05-24',
          'reading_2026-05-25',
          'other_key',
        ]);

        final result = datasource.getAllDates();

        expect(result, ['2026-05-24', '2026-05-25', '2026-05-26']);
      });

      test('return list kosong jika tidak ada data', () {
        when(() => mockBox.keys).thenReturn([]);

        final result = datasource.getAllDates();

        expect(result, isEmpty);
      });
    });
  });
}
