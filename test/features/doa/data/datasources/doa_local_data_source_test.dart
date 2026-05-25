import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/doa/data/datasources/doa_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  late MockBox mockBox;
  late DoaLocalDataSourceImpl dataSource;

  setUp(() {
    mockBox = MockBox();
    dataSource = DoaLocalDataSourceImpl(mockBox);
  });

  // ── getCachedDoaList ────────────────────────────────────────────────────────

  group('getCachedDoaList()', () {
    test('return list jika cache valid dan belum expired', () async {
      final entry = CacheEntry(
        data: jsonEncode(tDoaDtoList.map((e) => e.toJson()).toList()),
        cachedAt: DateTime.now(),
      );
      when(() => mockBox.get('doa_list')).thenReturn(entry.encode());

      final result = await dataSource.getCachedDoaList();

      expect(result, isNotNull);
      expect(result!.length, 2);
      expect(result.first.nama, 'Doa Sebelum Tidur 1');
    });

    test('return null jika cache expired', () async {
      final entry = CacheEntry(
        data: jsonEncode(tDoaDtoList.map((e) => e.toJson()).toList()),
        cachedAt: DateTime.now().subtract(const Duration(days: 8)),
      );
      when(() => mockBox.get('doa_list')).thenReturn(entry.encode());

      final result = await dataSource.getCachedDoaList();

      expect(result, isNull);
    });

    test('return null jika tidak ada cache', () async {
      when(() => mockBox.get('doa_list')).thenReturn(null);

      final result = await dataSource.getCachedDoaList();

      expect(result, isNull);
    });

    test('return null jika data corrupt', () async {
      when(() => mockBox.get('doa_list')).thenReturn('corrupt_data');

      final result = await dataSource.getCachedDoaList();

      expect(result, isNull);
    });
  });

  // ── cacheDoaList ────────────────────────────────────────────────────────────

  group('cacheDoaList()', () {
    test('simpan CacheEntry dengan timestamp ke Hive', () async {
      when(
        () => mockBox.put(any<dynamic>(), any<dynamic>()),
      ).thenAnswer((_) async {});

      await dataSource.cacheDoaList(tDoaDtoList);

      final captured =
          verify(
                () => mockBox.put('doa_list', captureAny<dynamic>()),
              ).captured.first
              as String;

      final entry = CacheEntry.decode(captured);
      expect(entry, isNotNull);
      expect(entry!.isExpired, isFalse);

      final decoded = jsonDecode(entry.data) as List;
      expect(decoded.length, 2);
    });
  });

  // ── getCachedDoaDetail ──────────────────────────────────────────────────────

  group('getCachedDoaDetail()', () {
    test('return DoaDto jika cache valid', () async {
      final entry = CacheEntry(
        data: jsonEncode(tDoaDto1.toJson()),
        cachedAt: DateTime.now(),
      );
      when(() => mockBox.get('doa_detail_1')).thenReturn(entry.encode());

      final result = await dataSource.getCachedDoaDetail(1);

      expect(result, isNotNull);
      expect(result!.id, 1);
      expect(result.nama, 'Doa Sebelum Tidur 1');
    });

    test('return null jika cache detail expired', () async {
      final entry = CacheEntry(
        data: jsonEncode(tDoaDto1.toJson()),
        cachedAt: DateTime.now().subtract(const Duration(days: 8)),
      );
      when(() => mockBox.get('doa_detail_1')).thenReturn(entry.encode());

      final result = await dataSource.getCachedDoaDetail(1);

      expect(result, isNull);
    });

    test('return null jika tidak ada cache detail', () async {
      when(() => mockBox.get('doa_detail_1')).thenReturn(null);

      final result = await dataSource.getCachedDoaDetail(1);

      expect(result, isNull);
    });
  });

  // ── cacheDoaDetail ──────────────────────────────────────────────────────────

  group('cacheDoaDetail()', () {
    test('simpan DoaDto ke Hive dengan key doa_detail_{id}', () async {
      when(
        () => mockBox.put(any<dynamic>(), any<dynamic>()),
      ).thenAnswer((_) async {});

      await dataSource.cacheDoaDetail(1, tDoaDto1);

      final captured =
          verify(
                () => mockBox.put('doa_detail_1', captureAny<dynamic>()),
              ).captured.first
              as String;

      final entry = CacheEntry.decode(captured);
      expect(entry, isNotNull);
      final decoded = jsonDecode(entry!.data) as Map<String, dynamic>;
      expect(decoded['id'], 1);
    });
  });

  // ── edge case: id 42 (tr dan idn kosong) ───────────────────────────────────

  group('edge case doa id 42', () {
    test('getCachedDoaDetail handle tr dan idn kosong', () async {
      final entry = CacheEntry(
        data: jsonEncode(tDoaDto42.toJson()),
        cachedAt: DateTime.now(),
      );
      when(() => mockBox.get('doa_detail_42')).thenReturn(entry.encode());

      final result = await dataSource.getCachedDoaDetail(42);

      expect(result, isNotNull);
      expect(result!.tr, '');
      expect(result.idn, '');
    });
  });
}
