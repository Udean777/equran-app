import 'dart:convert';

import 'package:equran_app/features/statistik_shalat/data/datasources/shalat_log_local_data_source.dart';
import 'package:equran_app/features/statistik_shalat/data/mappers/shalat_log_mapper.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<String> {}

void main() {
  late MockBox mockBox;
  late ShalatLogLocalDataSourceImpl datasource;

  const tDate = '2026-05-26';
  const tDate2 = '2026-05-25';

  final tLog = ShalatLog(
    date: tDate,
    waktu: WaktuShalat.subuh,
    status: ShalatStatus.tepatWaktu,
    updatedAt: DateTime(2026, 5, 26, 5),
  );

  final tLogDzuhur = ShalatLog(
    date: tDate,
    waktu: WaktuShalat.dzuhur,
    status: ShalatStatus.qadha,
    updatedAt: DateTime(2026, 5, 26, 14),
  );

  final tDayStats = ShalatDayStats(
    date: tDate,
    logs: {
      WaktuShalat.subuh.key: tLog,
      WaktuShalat.dzuhur.key: tLogDzuhur,
    },
  );

  String encodeDay(ShalatDayStats day) => jsonEncode(day.toDto().toJson());

  setUp(() {
    mockBox = MockBox();
    datasource = ShalatLogLocalDataSourceImpl(mockBox);
  });

  group('ShalatLogLocalDataSource', () {
    // ─── getByDate ────────────────────────────────────────────────────────────

    group('getByDate()', () {
      test('return ShalatDayStats jika key ada', () {
        when(
          () => mockBox.get('shalat_$tDate'),
        ).thenReturn(encodeDay(tDayStats));

        final result = datasource.getByDate(tDate);

        expect(result, isNotNull);
        expect(result!.date, tDate);
        expect(result.logs.length, 2);
        expect(
          result.logFor(WaktuShalat.subuh).status,
          ShalatStatus.tepatWaktu,
        );
        expect(
          result.logFor(WaktuShalat.dzuhur).status,
          ShalatStatus.qadha,
        );
      });

      test('return null jika key tidak ada', () {
        when(() => mockBox.get('shalat_$tDate')).thenReturn(null);

        final result = datasource.getByDate(tDate);

        expect(result, isNull);
      });

      test('return null jika JSON corrupt', () {
        when(() => mockBox.get('shalat_$tDate')).thenReturn('invalid_json');

        final result = datasource.getByDate(tDate);

        expect(result, isNull);
      });
    });

    // ─── getByDateRange ───────────────────────────────────────────────────────

    group('getByDateRange()', () {
      test('return list ShalatDayStats untuk tanggal yang ada', () {
        when(
          () => mockBox.get('shalat_$tDate'),
        ).thenReturn(encodeDay(tDayStats));
        when(() => mockBox.get('shalat_$tDate2')).thenReturn(null);

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

    // ─── saveLog ──────────────────────────────────────────────────────────────

    group('saveLog()', () {
      test('simpan log baru ke Hive dengan key yang benar', () async {
        // Tidak ada data existing
        when(() => mockBox.get('shalat_$tDate')).thenReturn(null);
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((_) async {});

        await datasource.saveLog(tLog);

        verify(() => mockBox.put('shalat_$tDate', any<String>())).called(1);
      });

      test('merge log baru dengan data existing', () async {
        // Ada data existing dengan subuh saja
        final existing = ShalatDayStats(
          date: tDate,
          logs: {WaktuShalat.subuh.key: tLog},
        );
        when(
          () => mockBox.get('shalat_$tDate'),
        ).thenReturn(encodeDay(existing));

        String? savedJson;
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((inv) async {
          savedJson = inv.positionalArguments[1] as String;
        });

        await datasource.saveLog(tLogDzuhur);

        expect(savedJson, isNotNull);
        final decoded = jsonDecode(savedJson!) as Map<String, dynamic>;
        final logsMap = decoded['logs'] as Map<String, dynamic>;
        // Harus ada subuh (existing) + dzuhur (baru)
        expect(logsMap.containsKey('subuh'), isTrue);
        expect(logsMap.containsKey('dzuhur'), isTrue);
      });

      test('overwrite log yang sudah ada untuk waktu yang sama', () async {
        final existing = ShalatDayStats(
          date: tDate,
          logs: {WaktuShalat.subuh.key: tLog},
        );
        when(
          () => mockBox.get('shalat_$tDate'),
        ).thenReturn(encodeDay(existing));

        String? savedJson;
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((inv) async {
          savedJson = inv.positionalArguments[1] as String;
        });

        // Update subuh ke qadha
        final updatedLog = tLog.copyWith(status: ShalatStatus.qadha);
        await datasource.saveLog(updatedLog);

        expect(savedJson, isNotNull);
        final decoded = jsonDecode(savedJson!) as Map<String, dynamic>;
        final logsMap = decoded['logs'] as Map<String, dynamic>;
        final subuhLog = logsMap['subuh'] as Map<String, dynamic>;
        expect(subuhLog['status'], 'qadha');
      });
    });

    // ─── deleteByDate ─────────────────────────────────────────────────────────

    group('deleteByDate()', () {
      test('hapus data dari Hive', () async {
        when(
          () => mockBox.delete(any<String>()),
        ).thenAnswer((_) async {});

        await datasource.deleteByDate(tDate);

        verify(() => mockBox.delete('shalat_$tDate')).called(1);
      });
    });

    // ─── getAllDates ──────────────────────────────────────────────────────────

    group('getAllDates()', () {
      test('return list tanggal sorted ascending', () {
        when(() => mockBox.keys).thenReturn([
          'shalat_2026-05-26',
          'shalat_2026-05-24',
          'shalat_2026-05-25',
          'other_key', // harus di-skip
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
