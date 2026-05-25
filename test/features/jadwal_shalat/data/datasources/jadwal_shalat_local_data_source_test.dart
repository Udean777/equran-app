import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  late MockBox mockBox;
  late JadwalShalatLocalDataSourceImpl dataSource;

  setUp(() {
    mockBox = MockBox();
    dataSource = JadwalShalatLocalDataSourceImpl(mockBox);
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

    test('mengembalikan null saat cache expired (> 30 hari)', () async {
      final entry = CacheEntry(
        data: jsonEncode(tProvinsiList),
        cachedAt: DateTime.now().subtract(const Duration(days: 31)),
      );
      when(() => mockBox.get('provinsi_list')).thenReturn(entry.encode());

      final result = await dataSource.getCachedProvinsi();

      expect(result, isNull);
    });

    test('mengembalikan null saat tidak ada cache', () async {
      when(() => mockBox.get('provinsi_list')).thenReturn(null);

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
        data: jsonEncode(tKabkotaJakartaList),
        cachedAt: DateTime.now(),
      );
      when(
        () => mockBox.get('kabkota_DKI_Jakarta'),
      ).thenReturn(entry.encode());

      final result = await dataSource.getCachedKabkota('DKI Jakarta');

      expect(result, tKabkotaJakartaList);
    });

    test('mengembalikan null saat cache expired', () async {
      final entry = CacheEntry(
        data: jsonEncode(tKabkotaJakartaList),
        cachedAt: DateTime.now().subtract(const Duration(days: 31)),
      );
      when(
        () => mockBox.get('kabkota_DKI_Jakarta'),
      ).thenReturn(entry.encode());

      final result = await dataSource.getCachedKabkota('DKI Jakarta');

      expect(result, isNull);
    });
  });

  group('getCachedJadwalShalat', () {
    test('mengembalikan dto saat cache valid', () async {
      final entry = CacheEntry(
        data: jsonEncode(tJadwalShalatDto.toJson()),
        cachedAt: DateTime.now(),
      );
      when(
        () => mockBox.get('shalat_DKI_Jakarta_Kota_Jakarta_5_2026'),
      ).thenReturn(entry.encode());

      final result = await dataSource.getCachedJadwalShalat(
        'DKI Jakarta',
        'Kota Jakarta',
        5,
        2026,
      );

      expect(result?.provinsi, 'DKI Jakarta');
      expect(result?.bulan, 5);
      expect(result?.tahun, 2026);
    });

    test('mengembalikan null saat cache expired (> 1 hari)', () async {
      final entry = CacheEntry(
        data: jsonEncode(tJadwalShalatDto.toJson()),
        cachedAt: DateTime.now().subtract(const Duration(days: 2)),
      );
      when(
        () => mockBox.get('shalat_DKI_Jakarta_Kota_Jakarta_5_2026'),
      ).thenReturn(entry.encode());

      final result = await dataSource.getCachedJadwalShalat(
        'DKI Jakarta',
        'Kota Jakarta',
        5,
        2026,
      );

      expect(result, isNull);
    });
  });

  group('last location', () {
    test('saveLastProvinsi dan getLastProvinsi', () async {
      when(
        () => mockBox.put('last_provinsi', 'DKI Jakarta'),
      ).thenAnswer((_) async {});
      when(
        () => mockBox.get('last_provinsi'),
      ).thenReturn('DKI Jakarta');

      await dataSource.saveLastProvinsi('DKI Jakarta');
      final result = await dataSource.getLastProvinsi();

      expect(result, 'DKI Jakarta');
    });

    test('saveLastKabkota dan getLastKabkota', () async {
      when(
        () => mockBox.put('last_kabkota', 'Kota Jakarta'),
      ).thenAnswer((_) async {});
      when(
        () => mockBox.get('last_kabkota'),
      ).thenReturn('Kota Jakarta');

      await dataSource.saveLastKabkota('Kota Jakarta');
      final result = await dataSource.getLastKabkota();

      expect(result, 'Kota Jakarta');
    });

    test('getLastProvinsi mengembalikan null jika belum disimpan', () async {
      when(() => mockBox.get('last_provinsi')).thenReturn(null);

      final result = await dataSource.getLastProvinsi();

      expect(result, isNull);
    });
  });
}
