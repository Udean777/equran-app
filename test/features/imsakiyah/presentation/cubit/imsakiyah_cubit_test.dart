import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/location/location_service.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_local_data_source.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_kabkota.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_provinsi.dart';
import 'package:equran_app/features/imsakiyah/presentation/cubit/imsakiyah_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockGetProvinsi extends Mock implements GetProvinsi {}

class MockGetKabkota extends Mock implements GetKabkota {}

class MockGetImsakiyah extends Mock implements GetImsakiyah {}

class MockLocalDataSource extends Mock implements ImsakiyahLocalDataSource {}

class MockLocationService extends Mock implements LocationService {}

void main() {
  late MockGetProvinsi mockGetProvinsi;
  late MockGetKabkota mockGetKabkota;
  late MockGetImsakiyah mockGetImsakiyah;
  late MockLocalDataSource mockLocal;
  late MockLocationService mockLocationService;

  setUp(() {
    mockGetProvinsi = MockGetProvinsi();
    mockGetKabkota = MockGetKabkota();
    mockGetImsakiyah = MockGetImsakiyah();
    mockLocal = MockLocalDataSource();
    mockLocationService = MockLocationService();
  });

  ImsakiyahCubit buildCubit() => ImsakiyahCubit(
    mockGetProvinsi,
    mockGetKabkota,
    mockGetImsakiyah,
    mockLocal,
    mockLocationService,
  );

  const tFailure = NetworkFailure();

  // Kabkota DKI Jakarta untuk default fallback test
  const tKabkotaJakarta = ['Kota Jakarta Pusat', 'Kota Jakarta Selatan'];

  group('init — tanpa last location', () {
    blocTest<ImsakiyahCubit, ImsakiyahState>(
      'emits [loadingProvinsi, detectingLocation, loadingJadwal, success] saat GPS null → default Jakarta',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetProvinsi(),
        ).thenAnswer((_) async => right(tProvinsiList));
        when(() => mockLocal.getLastProvinsi()).thenAnswer((_) async => null);
        when(() => mockLocal.getLastKabkota()).thenAnswer((_) async => null);
        when(
          () => mockLocationService.detectCurrentLocation(),
        ).thenAnswer((_) async => null);
        when(
          () => mockGetKabkota('DKI Jakarta'),
        ).thenAnswer((_) async => right(tKabkotaJakarta));
        when(() => mockLocal.saveLastProvinsi(any())).thenAnswer((_) async {});
        when(() => mockLocal.saveLastKabkota(any())).thenAnswer((_) async {});
        when(
          () => mockGetImsakiyah(
            provinsi: 'DKI Jakarta',
            kabkota: 'Kota Jakarta Pusat',
          ),
        ).thenAnswer((_) async => right(tImsakiyah));
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const ImsakiyahState.loadingProvinsi(),
        const ImsakiyahState.detectingLocation(),
        const ImsakiyahState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakarta,
          selectedKabkota: 'Kota Jakarta Pusat',
        ),
        const ImsakiyahState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakarta,
          selectedKabkota: 'Kota Jakarta Pusat',
          jadwal: tImsakiyah,
        ),
      ],
    );

    blocTest<ImsakiyahCubit, ImsakiyahState>(
      'emits [loadingProvinsi, failure] saat getProvinsi gagal',
      build: buildCubit,
      setUp: () {
        when(() => mockGetProvinsi()).thenAnswer((_) async => left(tFailure));
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const ImsakiyahState.loadingProvinsi(),
        const ImsakiyahState.failure(failure: tFailure),
      ],
    );

    blocTest<ImsakiyahCubit, ImsakiyahState>(
      'auto-load jadwal saat GPS cocok provinsi & kabkota',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetProvinsi(),
        ).thenAnswer((_) async => right(tProvinsiList));
        when(() => mockLocal.getLastProvinsi()).thenAnswer((_) async => null);
        when(() => mockLocal.getLastKabkota()).thenAnswer((_) async => null);
        when(() => mockLocationService.detectCurrentLocation()).thenAnswer(
          (_) async => const DetectedLocation(
            provinsi: 'SUMATERA UTARA',
            kabkota: 'KAB. DELI SERDANG',
          ),
        );
        when(
          () => mockGetKabkota('Sumatera Utara'),
        ).thenAnswer((_) async => right(tKabkotaList));
        when(() => mockLocal.saveLastProvinsi(any())).thenAnswer((_) async {});
        when(() => mockLocal.saveLastKabkota(any())).thenAnswer((_) async {});
        when(
          () => mockGetImsakiyah(
            provinsi: 'Sumatera Utara',
            kabkota: 'Kab. Deli Serdang',
          ),
        ).thenAnswer((_) async => right(tImsakiyah));
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const ImsakiyahState.loadingProvinsi(),
        const ImsakiyahState.detectingLocation(),
        const ImsakiyahState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'Sumatera Utara',
          kabkota: tKabkotaList,
          selectedKabkota: 'Kab. Deli Serdang',
        ),
        const ImsakiyahState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'Sumatera Utara',
          kabkota: tKabkotaList,
          selectedKabkota: 'Kab. Deli Serdang',
          jadwal: tImsakiyah,
        ),
      ],
    );
  });

  group('init — dengan last location', () {
    blocTest<ImsakiyahCubit, ImsakiyahState>(
      'auto-load jadwal saat last location valid',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetProvinsi(),
        ).thenAnswer((_) async => right(tProvinsiList));
        when(
          () => mockLocal.getLastProvinsi(),
        ).thenAnswer((_) async => 'Sumatera Utara');
        when(
          () => mockLocal.getLastKabkota(),
        ).thenAnswer((_) async => 'Kab. Deli Serdang');
        when(
          () => mockGetKabkota('Sumatera Utara'),
        ).thenAnswer((_) async => right(tKabkotaList));
        when(
          () => mockGetImsakiyah(
            provinsi: 'Sumatera Utara',
            kabkota: 'Kab. Deli Serdang',
          ),
        ).thenAnswer((_) async => right(tImsakiyah));
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const ImsakiyahState.loadingProvinsi(),
        const ImsakiyahState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'Sumatera Utara',
          kabkota: tKabkotaList,
          selectedKabkota: 'Kab. Deli Serdang',
        ),
        const ImsakiyahState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'Sumatera Utara',
          kabkota: tKabkotaList,
          selectedKabkota: 'Kab. Deli Serdang',
          jadwal: tImsakiyah,
        ),
      ],
    );

    blocTest<ImsakiyahCubit, ImsakiyahState>(
      'fallback ke provinsiLoaded jika kabkota tidak valid',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetProvinsi(),
        ).thenAnswer((_) async => right(tProvinsiList));
        when(
          () => mockLocal.getLastProvinsi(),
        ).thenAnswer((_) async => 'Sumatera Utara');
        when(
          () => mockLocal.getLastKabkota(),
        ).thenAnswer((_) async => 'Kab. Tidak Ada');
        when(
          () => mockGetKabkota('Sumatera Utara'),
        ).thenAnswer((_) async => right(tKabkotaList));
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const ImsakiyahState.loadingProvinsi(),
        const ImsakiyahState.provinsiLoaded(provinsi: tProvinsiList),
      ],
    );
  });

  group('selectProvinsi', () {
    blocTest<ImsakiyahCubit, ImsakiyahState>(
      'emits [loadingKabkota, kabkotaLoaded] saat sukses',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetKabkota('Sumatera Utara'),
        ).thenAnswer((_) async => right(tKabkotaList));
      },
      act: (cubit) => cubit.selectProvinsi('Sumatera Utara'),
      expect: () => [
        const ImsakiyahState.loadingKabkota(
          provinsi: [],
          selectedProvinsi: 'Sumatera Utara',
        ),
        const ImsakiyahState.kabkotaLoaded(
          provinsi: [],
          selectedProvinsi: 'Sumatera Utara',
          kabkota: tKabkotaList,
        ),
      ],
    );

    blocTest<ImsakiyahCubit, ImsakiyahState>(
      'emits [loadingKabkota, failure] saat gagal',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetKabkota(any()),
        ).thenAnswer((_) async => left(tFailure));
      },
      act: (cubit) => cubit.selectProvinsi('Sumatera Utara'),
      expect: () => [
        const ImsakiyahState.loadingKabkota(
          provinsi: [],
          selectedProvinsi: 'Sumatera Utara',
        ),
        const ImsakiyahState.failure(
          failure: tFailure,
          provinsi: [],
          selectedProvinsi: 'Sumatera Utara',
        ),
      ],
    );
  });

  group('selectKabkota', () {
    blocTest<ImsakiyahCubit, ImsakiyahState>(
      'emits [loadingJadwal, success] saat sukses',
      build: buildCubit,
      seed: () => const ImsakiyahState.kabkotaLoaded(
        provinsi: tProvinsiList,
        selectedProvinsi: 'Sumatera Utara',
        kabkota: tKabkotaList,
      ),
      setUp: () {
        when(() => mockLocal.saveLastProvinsi(any())).thenAnswer((_) async {});
        when(() => mockLocal.saveLastKabkota(any())).thenAnswer((_) async {});
        when(
          () => mockGetImsakiyah(
            provinsi: 'Sumatera Utara',
            kabkota: 'Kab. Deli Serdang',
          ),
        ).thenAnswer((_) async => right(tImsakiyah));
      },
      act: (cubit) => cubit.selectKabkota('Kab. Deli Serdang'),
      expect: () => [
        const ImsakiyahState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'Sumatera Utara',
          kabkota: tKabkotaList,
          selectedKabkota: 'Kab. Deli Serdang',
        ),
        const ImsakiyahState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'Sumatera Utara',
          kabkota: tKabkotaList,
          selectedKabkota: 'Kab. Deli Serdang',
          jadwal: tImsakiyah,
        ),
      ],
    );

    blocTest<ImsakiyahCubit, ImsakiyahState>(
      'emits [loadingJadwal, failure] saat gagal',
      build: buildCubit,
      seed: () => const ImsakiyahState.kabkotaLoaded(
        provinsi: tProvinsiList,
        selectedProvinsi: 'Sumatera Utara',
        kabkota: tKabkotaList,
      ),
      setUp: () {
        when(() => mockLocal.saveLastProvinsi(any())).thenAnswer((_) async {});
        when(() => mockLocal.saveLastKabkota(any())).thenAnswer((_) async {});
        when(
          () => mockGetImsakiyah(
            provinsi: any(named: 'provinsi'),
            kabkota: any(named: 'kabkota'),
          ),
        ).thenAnswer((_) async => left(tFailure));
      },
      act: (cubit) => cubit.selectKabkota('Kab. Deli Serdang'),
      expect: () => [
        const ImsakiyahState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'Sumatera Utara',
          kabkota: tKabkotaList,
          selectedKabkota: 'Kab. Deli Serdang',
        ),
        const ImsakiyahState.failure(
          failure: tFailure,
          provinsi: tProvinsiList,
          selectedProvinsi: 'Sumatera Utara',
          kabkota: tKabkotaList,
          selectedKabkota: 'Kab. Deli Serdang',
        ),
      ],
    );
  });

  group('retry', () {
    blocTest<ImsakiyahCubit, ImsakiyahState>(
      'retry dari failure tanpa context → init ulang → default Jakarta',
      build: buildCubit,
      seed: () => const ImsakiyahState.failure(failure: tFailure),
      setUp: () {
        when(
          () => mockGetProvinsi(),
        ).thenAnswer((_) async => right(tProvinsiList));
        when(() => mockLocal.getLastProvinsi()).thenAnswer((_) async => null);
        when(() => mockLocal.getLastKabkota()).thenAnswer((_) async => null);
        when(
          () => mockLocationService.detectCurrentLocation(),
        ).thenAnswer((_) async => null);
        when(
          () => mockGetKabkota('DKI Jakarta'),
        ).thenAnswer((_) async => right(tKabkotaJakarta));
        when(() => mockLocal.saveLastProvinsi(any())).thenAnswer((_) async {});
        when(() => mockLocal.saveLastKabkota(any())).thenAnswer((_) async {});
        when(
          () => mockGetImsakiyah(
            provinsi: 'DKI Jakarta',
            kabkota: 'Kota Jakarta Pusat',
          ),
        ).thenAnswer((_) async => right(tImsakiyah));
      },
      act: (cubit) => cubit.retry(),
      expect: () => [
        const ImsakiyahState.loadingProvinsi(),
        const ImsakiyahState.detectingLocation(),
        const ImsakiyahState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakarta,
          selectedKabkota: 'Kota Jakarta Pusat',
        ),
        const ImsakiyahState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakarta,
          selectedKabkota: 'Kota Jakarta Pusat',
          jadwal: tImsakiyah,
        ),
      ],
    );

    blocTest<ImsakiyahCubit, ImsakiyahState>(
      'retry dari failure dengan provinsi+kabkota → load jadwal ulang',
      build: buildCubit,
      seed: () => const ImsakiyahState.failure(
        failure: tFailure,
        provinsi: tProvinsiList,
        selectedProvinsi: 'Sumatera Utara',
        kabkota: tKabkotaList,
        selectedKabkota: 'Kab. Deli Serdang',
      ),
      setUp: () {
        when(() => mockLocal.saveLastProvinsi(any())).thenAnswer((_) async {});
        when(() => mockLocal.saveLastKabkota(any())).thenAnswer((_) async {});
        when(
          () => mockGetImsakiyah(
            provinsi: 'Sumatera Utara',
            kabkota: 'Kab. Deli Serdang',
          ),
        ).thenAnswer((_) async => right(tImsakiyah));
      },
      act: (cubit) => cubit.retry(),
      expect: () => [
        const ImsakiyahState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'Sumatera Utara',
          kabkota: tKabkotaList,
          selectedKabkota: 'Kab. Deli Serdang',
        ),
        const ImsakiyahState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'Sumatera Utara',
          kabkota: tKabkotaList,
          selectedKabkota: 'Kab. Deli Serdang',
          jadwal: tImsakiyah,
        ),
      ],
    );
  });
}
