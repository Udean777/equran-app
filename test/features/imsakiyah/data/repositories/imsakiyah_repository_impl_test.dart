import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_local_data_source.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_remote_data_source.dart';
import 'package:equran_app/features/imsakiyah/data/models/imsakiyah_dto.dart';
import 'package:equran_app/features/imsakiyah/data/repositories/imsakiyah_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockRemote extends Mock implements ImsakiyahRemoteDataSource {}

class MockLocal extends Mock implements ImsakiyahLocalDataSource {}

class FakeImsakiyahDto extends Fake implements ImsakiyahDto {}

void main() {
  late MockRemote mockRemote;
  late MockLocal mockLocal;
  late ImsakiyahRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeImsakiyahDto());
  });

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    repository = ImsakiyahRepositoryImpl(mockRemote, mockLocal);
  });

  group('getProvinsi', () {
    test('mengembalikan cached data jika ada', () async {
      when(
        () => mockLocal.getCachedProvinsi(),
      ).thenAnswer((_) async => tProvinsiList);

      final result = await repository.getProvinsi();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should be right'),
        (v) => expect(v, tProvinsiList),
      );
      verifyNever(() => mockRemote.fetchProvinsi());
    });

    test('fetch dari remote jika cache kosong', () async {
      when(() => mockLocal.getCachedProvinsi()).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchProvinsi(),
      ).thenAnswer((_) async => tProvinsiResponseDto);
      when(() => mockLocal.cacheProvinsi(any())).thenAnswer((_) async {});

      final result = await repository.getProvinsi();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should be right'),
        (v) => expect(v, tProvinsiList),
      );
      verify(() => mockRemote.fetchProvinsi()).called(1);
      verify(() => mockLocal.cacheProvinsi(tProvinsiList)).called(1);
    });

    test('mengembalikan Failure saat network error', () async {
      when(() => mockLocal.getCachedProvinsi()).thenAnswer((_) async => null);
      when(() => mockRemote.fetchProvinsi()).thenThrow(Exception('network'));

      final result = await repository.getProvinsi();

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<Failure>()),
        (_) => fail('should be left'),
      );
    });
  });

  group('getKabkota', () {
    test('mengembalikan cached data jika ada', () async {
      when(
        () => mockLocal.getCachedKabkota('Sumatera Utara'),
      ).thenAnswer((_) async => tKabkotaList);

      final result = await repository.getKabkota('Sumatera Utara');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should be right'),
        (v) => expect(v, tKabkotaList),
      );
      verifyNever(() => mockRemote.fetchKabkota(any()));
    });

    test('fetch dari remote jika cache kosong', () async {
      when(
        () => mockLocal.getCachedKabkota('Sumatera Utara'),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchKabkota('Sumatera Utara'),
      ).thenAnswer((_) async => tKabkotaResponseDto);
      when(() => mockLocal.cacheKabkota(any(), any())).thenAnswer((_) async {});

      final result = await repository.getKabkota('Sumatera Utara');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should be right'),
        (v) => expect(v, tKabkotaList),
      );
      verify(() => mockRemote.fetchKabkota('Sumatera Utara')).called(1);
    });
  });

  group('getImsakiyah', () {
    test('mengembalikan cached data jika ada', () async {
      when(
        () => mockLocal.getCachedImsakiyah(
          'Sumatera Utara',
          'Kab. Deli Serdang',
        ),
      ).thenAnswer((_) async => tImsakiyahDto);

      final result = await repository.getImsakiyah(
        provinsi: 'Sumatera Utara',
        kabkota: 'Kab. Deli Serdang',
      );

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should be right'),
        (jadwal) {
          expect(jadwal.provinsi, 'Sumatera Utara');
          expect(jadwal.kabkota, 'Kab. Deli Serdang');
          expect(jadwal.imsakiyah.length, 2);
        },
      );
      verifyNever(
        () => mockRemote.fetchImsakiyah(
          provinsi: any(named: 'provinsi'),
          kabkota: any(named: 'kabkota'),
        ),
      );
    });

    test('fetch dari remote jika cache kosong', () async {
      when(
        () => mockLocal.getCachedImsakiyah(any(), any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchImsakiyah(
          provinsi: 'Sumatera Utara',
          kabkota: 'Kab. Deli Serdang',
        ),
      ).thenAnswer((_) async => tImsakiyahResponseDto);
      when(() => mockLocal.cacheImsakiyah(any())).thenAnswer((_) async {});

      final result = await repository.getImsakiyah(
        provinsi: 'Sumatera Utara',
        kabkota: 'Kab. Deli Serdang',
      );

      expect(result.isRight(), true);
      verify(
        () => mockRemote.fetchImsakiyah(
          provinsi: 'Sumatera Utara',
          kabkota: 'Kab. Deli Serdang',
        ),
      ).called(1);
    });

    test('mengembalikan Failure saat network error', () async {
      when(
        () => mockLocal.getCachedImsakiyah(any(), any()),
      ).thenAnswer((_) async => null);
      when(
        () => mockRemote.fetchImsakiyah(
          provinsi: any(named: 'provinsi'),
          kabkota: any(named: 'kabkota'),
        ),
      ).thenThrow(Exception('network'));

      final result = await repository.getImsakiyah(
        provinsi: 'Sumatera Utara',
        kabkota: 'Kab. Deli Serdang',
      );

      expect(result.isLeft(), true);
    });
  });
}
