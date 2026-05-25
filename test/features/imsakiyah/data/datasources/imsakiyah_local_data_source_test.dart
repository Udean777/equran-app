import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  late MockBox mockBox;
  late ImsakiyahLocalDataSourceImpl dataSource;

  setUp(() {
    mockBox = MockBox();
    dataSource = ImsakiyahLocalDataSourceImpl(mockBox);
  });

  group('getCachedProvinsi', () {
    test('mengembalikan list saat cache valid', () async {
      final entry = CacheEntry(
        data: jsonEncode(tProvinsiList),
        cachedAt: DateTime.now(),
      );
      when(() => mockBox.get('provinsi_list')).thenReturn(entry.encode());

      final result = await dataSource.getCachedProvinsi();

      expect(result, tProvinsiList);
    });

    test('mengembalikan null saat cache tidak ada', () async {
      when(() => mockBox.get('provinsi_list')).thenReturn(null);

      final result = await dataSource.getCachedProvinsi();

      expect(result, isNull);
    });

    test('mengembalikan null saat cache expired (> 30 hari)', () async {
      final entry = CacheEntry(
        data: jsonEncode(tProvinsiList),
        cachedAt: DateTime.now().subtract(const Duration(days: 31)),
      );
      when(() => mockBox.get('provinsi_list')).thenReturn(entry.encode());

      final result = await dataSource.getCachedProvinsi();

      expect(result, isNull);
    });
  });

  group('cacheProvinsi', () {
    test('menyimpan provinsi ke box', () async {
      when(
        () => mockBox.put(any<dynamic>(), any<dynamic>()),
      ).thenAnswer((_) async {});

      await dataSource.cacheProvinsi(tProvinsiList);

      verify(() => mockBox.put('provinsi_list', any<dynamic>())).called(1);
    });
  });

  group('getCachedKabkota', () {
    test('mengembalikan list saat cache valid', () async {
      final entry = CacheEntry(
        data: jsonEncode(tKabkotaList),
        cachedAt: DateTime.now(),
      );
      when(
        () => mockBox.get('kabkota_Sumatera_Utara'),
      ).thenReturn(entry.encode());

      final result = await dataSource.getCachedKabkota('Sumatera Utara');

      expect(result, tKabkotaList);
    });

    test('mengembalikan null saat cache tidak ada', () async {
      when(() => mockBox.get(any<dynamic>())).thenReturn(null);

      final result = await dataSource.getCachedKabkota('Sumatera Utara');

      expect(result, isNull);
    });
  });

  group('getCachedImsakiyah', () {
    test('mengembalikan ImsakiyahDto saat cache valid', () async {
      final entry = CacheEntry(
        data: jsonEncode(tImsakiyahDto.toJson()),
        cachedAt: DateTime.now(),
      );
      when(
        () => mockBox.get('imsakiyah_Sumatera_Utara_Kab._Deli_Serdang'),
      ).thenReturn(entry.encode());

      final result = await dataSource.getCachedImsakiyah(
        'Sumatera Utara',
        'Kab. Deli Serdang',
      );

      expect(result?.provinsi, 'Sumatera Utara');
      expect(result?.kabkota, 'Kab. Deli Serdang');
    });

    test('mengembalikan null saat cache expired (> 1 hari)', () async {
      final entry = CacheEntry(
        data: jsonEncode(tImsakiyahDto.toJson()),
        cachedAt: DateTime.now().subtract(const Duration(days: 2)),
      );
      when(
        () => mockBox.get('imsakiyah_Sumatera_Utara_Kab._Deli_Serdang'),
      ).thenReturn(entry.encode());

      final result = await dataSource.getCachedImsakiyah(
        'Sumatera Utara',
        'Kab. Deli Serdang',
      );

      expect(result, isNull);
    });
  });

  group('last location', () {
    test('saveLastProvinsi dan getLastProvinsi', () async {
      when(
        () => mockBox.put('last_provinsi', 'Sumatera Utara'),
      ).thenAnswer((_) async {});
      when(
        () => mockBox.get('last_provinsi'),
      ).thenReturn('Sumatera Utara');

      await dataSource.saveLastProvinsi('Sumatera Utara');
      final result = await dataSource.getLastProvinsi();

      expect(result, 'Sumatera Utara');
    });

    test('saveLastKabkota dan getLastKabkota', () async {
      when(
        () => mockBox.put('last_kabkota', 'Kab. Deli Serdang'),
      ).thenAnswer((_) async {});
      when(
        () => mockBox.get('last_kabkota'),
      ).thenReturn('Kab. Deli Serdang');

      await dataSource.saveLastKabkota('Kab. Deli Serdang');
      final result = await dataSource.getLastKabkota();

      expect(result, 'Kab. Deli Serdang');
    });

    test('getLastProvinsi mengembalikan null jika belum disimpan', () async {
      when(() => mockBox.get('last_provinsi')).thenReturn(null);

      final result = await dataSource.getLastProvinsi();

      expect(result, isNull);
    });
  });
}
