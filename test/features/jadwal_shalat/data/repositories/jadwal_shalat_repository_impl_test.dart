import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_local_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_remote_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/models/jadwal_shalat_dto.dart';
import 'package:equran_app/features/jadwal_shalat/data/repositories/jadwal_shalat_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockRemote extends Mock implements JadwalShalatRemoteDataSource {}

class MockLocal extends Mock implements JadwalShalatLocalDataSource {}

class FakeJadwalShalatDto extends Fake implements JadwalShalatDto {}

void main() {
  late MockRemote mockRemote;
  late MockLocal mockLocal;
  late JadwalShalatRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeJadwalShalatDto());
  });

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    repository = JadwalShalatRepositoryImpl(mockRemote, mockLocal);
  });

  group('getProvinsi', () {
    test('mengembalikan cache jika tersedia', () async {
      when(
        () => mockLocal.getCachedProvinsi(),
      ).thenAnswer((_) async => tProvinsiList);

      final result = await repository.getProvinsi();

      expect(result.isRight(), true);
      result.fold((_) {}, (v) => expect(v, tProvinsiList));
      verifyNever(() => mockRemote.fetchProvinsi());
    });

    test('fetch dari remote jika cache kosong', () async {
      when(
        () => mockLocal.getCachedProvinsi(),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchProvinsi(),
      ).thenAnswer((_) async => tProvinsiShalatResponseDto);
      when(
        () => mockLocal.cacheProvinsi(any()),
      ).thenAnswer((_) async {});

      final result = await repository.getProvinsi();

      expect(result.isRight(), true);
      result.fold((_) {}, (v) => expect(v, tProvinsiList));
      verify(() => mockRemote.fetchProvinsi()).called(1);
    });

    test('mengembalikan Failure saat network error', () async {
      when(
        () => mockLocal.getCachedProvinsi(),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchProvinsi(),
      ).thenThrow(Exception('network error'));

      final result = await repository.getProvinsi();

      expect(result.isLeft(), true);
    });
  });

  group('getKabkota', () {
    test('mengembalikan cache jika tersedia', () async {
      when(
        () => mockLocal.getCachedKabkota('DKI Jakarta'),
      ).thenAnswer((_) async => tKabkotaJakartaList);

      final result = await repository.getKabkota('DKI Jakarta');

      expect(result.isRight(), true);
      result.fold((_) {}, (v) => expect(v, tKabkotaJakartaList));
      verifyNever(() => mockRemote.fetchKabkota(any()));
    });

    test('fetch dari remote jika cache kosong', () async {
      when(
        () => mockLocal.getCachedKabkota('DKI Jakarta'),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchKabkota('DKI Jakarta'),
      ).thenAnswer((_) async => tKabkotaShalatResponseDto);
      when(
        () => mockLocal.cacheKabkota(any(), any()),
      ).thenAnswer((_) async {});

      final result = await repository.getKabkota('DKI Jakarta');

      expect(result.isRight(), true);
      result.fold((_) {}, (v) => expect(v, tKabkotaJakartaList));
    });

    test('mengembalikan Failure saat network error', () async {
      when(
        () => mockLocal.getCachedKabkota(any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchKabkota(any()),
      ).thenThrow(Exception('network error'));

      final result = await repository.getKabkota('DKI Jakarta');

      expect(result.isLeft(), true);
    });
  });

  group('getJadwalShalat', () {
    test('mengembalikan cache jika tersedia', () async {
      when(
        () => mockLocal.getCachedJadwalShalat(
          'DKI Jakarta',
          'Kota Jakarta',
          5,
          2026,
        ),
      ).thenAnswer((_) async => tJadwalShalatDto);

      final result = await repository.getJadwalShalat(
        provinsi: 'DKI Jakarta',
        kabkota: 'Kota Jakarta',
        bulan: 5,
        tahun: 2026,
      );

      expect(result.isRight(), true);
      verifyNever(
        () => mockRemote.fetchJadwalShalat(
          provinsi: any(named: 'provinsi'),
          kabkota: any(named: 'kabkota'),
          bulan: any(named: 'bulan'),
          tahun: any(named: 'tahun'),
        ),
      );
    });

    test('fetch dari remote jika cache kosong', () async {
      when(
        () => mockLocal.getCachedJadwalShalat(any(), any(), any(), any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchJadwalShalat(
          provinsi: 'DKI Jakarta',
          kabkota: 'Kota Jakarta',
          bulan: 5,
          tahun: 2026,
        ),
      ).thenAnswer((_) async => tJadwalShalatResponseDto);
      when(
        () => mockLocal.cacheJadwalShalat(any()),
      ).thenAnswer((_) async {});

      final result = await repository.getJadwalShalat(
        provinsi: 'DKI Jakarta',
        kabkota: 'Kota Jakarta',
        bulan: 5,
        tahun: 2026,
      );

      expect(result.isRight(), true);
    });

    test('mengembalikan Failure saat network error', () async {
      when(
        () => mockLocal.getCachedJadwalShalat(any(), any(), any(), any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchJadwalShalat(
          provinsi: any(named: 'provinsi'),
          kabkota: any(named: 'kabkota'),
          bulan: any(named: 'bulan'),
          tahun: any(named: 'tahun'),
        ),
      ).thenThrow(Exception('network error'));

      final result = await repository.getJadwalShalat(
        provinsi: 'DKI Jakarta',
        kabkota: 'Kota Jakarta',
        bulan: 5,
        tahun: 2026,
      );

      expect(result.isLeft(), true);
    });
  });
}
