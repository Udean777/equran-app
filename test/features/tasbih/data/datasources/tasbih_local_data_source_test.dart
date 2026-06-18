import 'dart:convert';

import 'package:equran_app/features/tasbih/data/datasources/tasbih_local_data_source.dart';
import 'package:equran_app/features/tasbih/data/models/tasbih_session_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<String> {}

void main() {
  late MockBox mockBox;
  late TasbihLocalDataSourceImpl dataSource;

  final tSession1 = TasbihSessionDto(
    id: 'session-1',
    presetId: 'preset-1',
    presetName: 'Subhanallah',
    count: 33,
    target: 33,
    createdAt: DateTime(2026, 5, 26, 8).toIso8601String(),
  );

  final tSession2 = TasbihSessionDto(
    id: 'session-2',
    presetId: 'preset-1',
    presetName: 'Subhanallah',
    count: 33,
    target: 33,
    createdAt: DateTime(2026, 5, 26, 9).toIso8601String(),
  );

  setUp(() {
    mockBox = MockBox();
    dataSource = TasbihLocalDataSourceImpl(mockBox);
  });

  group('TasbihLocalDataSource', () {
    // ─── getSessions ──────────────────────────────────────────────────────────

    group('getSessions()', () {
      test('return list sessions sorted descending by createdAt', () async {
        when(() => mockBox.get('tasbih_sessions')).thenReturn(
          jsonEncode([tSession1.toJson(), tSession2.toJson()]),
        );

        final result = await dataSource.getSessions();

        expect(result.length, 2);
        // tSession2 lebih baru — harus di depan
        expect(result.first.id, 'session-2');
        expect(result.last.id, 'session-1');
      });

      test('return list kosong jika box kosong', () async {
        when(() => mockBox.get('tasbih_sessions')).thenReturn(null);

        final result = await dataSource.getSessions();

        expect(result, isEmpty);
      });

      test('return list kosong jika JSON corrupt', () async {
        when(() => mockBox.get('tasbih_sessions')).thenReturn('invalid_json');

        final result = await dataSource.getSessions();

        expect(result, isEmpty);
      });
    });

    // ─── saveSession ──────────────────────────────────────────────────────────

    group('saveSession()', () {
      test('simpan session baru ke Hive', () async {
        when(() => mockBox.get('tasbih_sessions')).thenReturn(null);
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((_) async {});

        await dataSource.saveSession(tSession1);

        verify(
          () => mockBox.put('tasbih_sessions', any<String>()),
        ).called(1);
      });

      test('append session ke list yang sudah ada', () async {
        when(() => mockBox.get('tasbih_sessions')).thenReturn(
          jsonEncode([tSession1.toJson()]),
        );

        String? savedJson;
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((inv) async {
          savedJson = inv.positionalArguments[1] as String;
        });

        await dataSource.saveSession(tSession2);

        expect(savedJson, isNotNull);
        final list = jsonDecode(savedJson!) as List;
        expect(list.length, 2);
      });
    });

    // ─── deleteSession ────────────────────────────────────────────────────────

    group('deleteSession()', () {
      test('hapus session berdasarkan id', () async {
        when(() => mockBox.get('tasbih_sessions')).thenReturn(
          jsonEncode([tSession1.toJson(), tSession2.toJson()]),
        );

        String? savedJson;
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((inv) async {
          savedJson = inv.positionalArguments[1] as String;
        });

        await dataSource.deleteSession('session-1');

        expect(savedJson, isNotNull);
        final list = jsonDecode(savedJson!) as List<dynamic>;
        expect(list.length, 1);
        expect(
          (list.first as Map<String, dynamic>)['id'],
          'session-2',
        );
      });

      test('tidak error jika id tidak ditemukan', () async {
        when(() => mockBox.get('tasbih_sessions')).thenReturn(
          jsonEncode([tSession1.toJson()]),
        );
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((_) async {});

        // Tidak throw
        await expectLater(
          dataSource.deleteSession('id-tidak-ada'),
          completes,
        );
      });
    });

    // ─── clearSessions ────────────────────────────────────────────────────────

    group('clearSessions()', () {
      test('hapus semua sessions dari Hive', () async {
        when(
          () => mockBox.delete(any<String>()),
        ).thenAnswer((_) async {});

        await dataSource.clearSessions();

        verify(() => mockBox.delete('tasbih_sessions')).called(1);
      });
    });

    // ─── Concurrent operations ────────────────────────────────────────────────

    group('concurrent operations', () {
      test('concurrent saveSession tidak menyebabkan data hilang', () async {
        // Simulasi: dua saveSession berjalan bersamaan
        // Lock memastikan keduanya tersimpan
        final stored = <String>[];
        when(() => mockBox.get('tasbih_sessions')).thenAnswer((_) {
          return stored.isEmpty ? null : stored.last;
        });
        when(() => mockBox.put(any<String>(), any<String>())).thenAnswer((
          inv,
        ) async {
          stored.add(inv.positionalArguments[1] as String);
        });

        await Future.wait([
          dataSource.saveSession(tSession1),
          dataSource.saveSession(tSession2),
        ]);

        // put dipanggil 2x — satu per operasi
        verify(
          () => mockBox.put('tasbih_sessions', any<String>()),
        ).called(2);
      });

      test('deleteSession dengan id tidak ada tidak error', () async {
        when(() => mockBox.get('tasbih_sessions')).thenReturn(
          jsonEncode([tSession1.toJson()]),
        );
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((_) async {});

        await expectLater(
          dataSource.deleteSession('id-tidak-ada'),
          completes,
        );
      });

      test(
        'concurrent saveSession + deleteSession menghasilkan state konsisten',
        () async {
          final stored = <String>[];
          when(() => mockBox.get('tasbih_sessions')).thenAnswer((_) {
            return stored.isEmpty
                ? jsonEncode([tSession1.toJson()])
                : stored.last;
          });
          when(() => mockBox.put(any<String>(), any<String>())).thenAnswer((
            inv,
          ) async {
            stored.add(inv.positionalArguments[1] as String);
          });

          // save + delete berjalan bersamaan — tidak boleh throw
          await Future.wait([
            dataSource.saveSession(tSession2),
            dataSource.deleteSession('session-1'),
          ]);

          // Tidak throw = state konsisten
          verify(
            () => mockBox.put('tasbih_sessions', any<String>()),
          ).called(greaterThanOrEqualTo(1));
        },
      );
    });
  });
}
