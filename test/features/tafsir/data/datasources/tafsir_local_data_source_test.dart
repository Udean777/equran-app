import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/tafsir/data/datasources/tafsir_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockLazyBox extends Mock implements LazyBox<String> {}

void main() {
  late MockLazyBox mockBox;
  late TafsirLocalDataSourceImpl dataSource;

  setUp(() {
    mockBox = MockLazyBox();
    dataSource = TafsirLocalDataSourceImpl(mockBox);
  });

  group('getCachedTafsir()', () {
    test('return tafsir jika cache valid dan belum expired', () async {
      final entry = CacheEntry(
        data: jsonEncode(tTafsirDataDto.toJson()),
        cachedAt: DateTime.now(),
      );
      when(() => mockBox.get('tafsir_1')).thenAnswer((_) async => entry.encode());

      final result = await dataSource.getCachedTafsir(1);

      expect(result, isNotNull);
      expect(result!.nomor, 1);
      expect(result.namaLatin, 'Al-Fatihah');
    });

    test('return null jika cache expired', () async {
      final entry = CacheEntry(
        data: jsonEncode(tTafsirDataDto.toJson()),
        cachedAt: DateTime.now().subtract(const Duration(days: 8)),
      );
      when(() => mockBox.get('tafsir_1')).thenAnswer((_) async => entry.encode());

      final result = await dataSource.getCachedTafsir(1);

      expect(result, isNull);
    });

    test('return null jika tidak ada cache', () async {
      when(() => mockBox.get('tafsir_1')).thenAnswer((_) async => null);

      final result = await dataSource.getCachedTafsir(1);

      expect(result, isNull);
    });

    test('return null jika data corrupt', () async {
      when(() => mockBox.get('tafsir_1')).thenAnswer((_) async => 'corrupt_data');

      final result = await dataSource.getCachedTafsir(1);

      expect(result, isNull);
    });
  });

  group('cacheTafsir()', () {
    test('simpan CacheEntry dengan timestamp ke Hive', () async {
      when(
        () => mockBox.put(any<String>(), any<String>()),
      ).thenAnswer((_) async {});

      await dataSource.cacheTafsir(1, tTafsirDataDto);

      final captured =
          verify(
                () => mockBox.put('tafsir_1', captureAny<String>()),
              ).captured.first
              as String;

      final entry = CacheEntry.decode(captured);
      expect(entry, isNotNull);
      expect(entry!.isExpired, isFalse);

      final decoded = jsonDecode(entry.data) as Map<String, dynamic>;
      expect(decoded['nomor'], 1);
    });
  });
}
