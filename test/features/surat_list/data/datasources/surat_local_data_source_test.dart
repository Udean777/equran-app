import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/surat_list/data/datasources/surat_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockBox extends Mock implements Box<String> {}

void main() {
  late MockBox mockBox;
  late SuratLocalDataSourceImpl dataSource;

  setUp(() {
    mockBox = MockBox();
    dataSource = SuratLocalDataSourceImpl(mockBox);
  });

  group('getCachedSuratList()', () {
    test('return list jika cache valid dan belum expired', () async {
      final entry = CacheEntry(
        data: jsonEncode(tSuratDtoList.map((e) => e.toJson()).toList()),
        cachedAt: DateTime.now(),
      );
      when(() => mockBox.get('surat_list')).thenReturn(entry.encode());

      final result = await dataSource.getCachedSuratList();

      expect(result, isNotNull);
      expect(result!.length, 2);
      expect(result.first.namaLatin, 'Al-Fatihah');
    });

    test('return null jika cache expired', () async {
      final entry = CacheEntry(
        data: jsonEncode(tSuratDtoList.map((e) => e.toJson()).toList()),
        cachedAt: DateTime.now().subtract(const Duration(days: 8)),
      );
      when(() => mockBox.get('surat_list')).thenReturn(entry.encode());

      final result = await dataSource.getCachedSuratList();

      expect(result, isNull);
    });

    test('return null jika tidak ada cache', () async {
      when(() => mockBox.get('surat_list')).thenReturn(null);

      final result = await dataSource.getCachedSuratList();

      expect(result, isNull);
    });

    test('return null jika data corrupt', () async {
      when(() => mockBox.get('surat_list')).thenReturn('corrupt_data');

      final result = await dataSource.getCachedSuratList();

      expect(result, isNull);
    });
  });

  group('cacheSuratList()', () {
    test('simpan CacheEntry dengan timestamp ke Hive', () async {
      when(
        () => mockBox.put(any<String>(), any<String>()),
      ).thenAnswer((_) async {});

      await dataSource.cacheSuratList(tSuratDtoList);

      final captured =
          verify(
                () => mockBox.put('surat_list', captureAny<String>()),
              ).captured.first
              as String;

      final entry = CacheEntry.decode(captured);
      expect(entry, isNotNull);
      expect(entry!.isExpired, isFalse);

      final decoded = jsonDecode(entry.data) as List;
      expect(decoded.length, 2);
    });
  });

  group('getCachedSuratDetail()', () {
    test('return detail jika cache valid', () async {
      final entry = CacheEntry(
        data: jsonEncode(tSuratDetailDto.toJson()),
        cachedAt: DateTime.now(),
      );
      when(() => mockBox.get('surat_detail_1')).thenReturn(entry.encode());

      final result = await dataSource.getCachedSuratDetail(1);

      expect(result, isNotNull);
      expect(result!['nomor'], 1);
    });

    test('return null jika cache detail expired', () async {
      final entry = CacheEntry(
        data: jsonEncode(tSuratDetailDto.toJson()),
        cachedAt: DateTime.now().subtract(const Duration(days: 8)),
      );
      when(() => mockBox.get('surat_detail_1')).thenReturn(entry.encode());

      final result = await dataSource.getCachedSuratDetail(1);

      expect(result, isNull);
    });
  });
}
