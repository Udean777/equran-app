import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/location/location_service.dart';
import 'package:equran_app/core/notifications/shalat_notif_config.dart';
import 'package:equran_app/core/notifications/shalat_notification_scheduler.dart';
import 'package:equran_app/core/notifications/shalat_schedule_entry.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_kabkota_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_provinsi_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/jadwal_shalat_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockGetProvinsiShalat extends Mock implements GetProvinsiShalat {}
class MockGetKabkotaShalat extends Mock implements GetKabkotaShalat {}
class MockGetJadwalShalat extends Mock implements GetJadwalShalat {}
class MockGetLastLocationShalat extends Mock implements GetLastLocationShalat {}
class MockSaveLastLocationShalat extends Mock implements SaveLastLocationShalat {}
class MockLocationService extends Mock implements LocationService {}
class MockShalatNotificationScheduler extends Mock implements ShalatNotificationScheduler {}
class MockGetShalatNotifPrefs extends Mock implements GetShalatNotifPrefs {}
class MockSaveShalatNotifPrefs extends Mock implements SaveShalatNotifPrefs {}

class FakeJadwalShalatEntry extends Fake implements JadwalShalatEntry {}
class FakeShalatNotifPrefs extends Fake implements ShalatNotifPrefs {}
class FakeShalatScheduleEntry extends Fake implements ShalatScheduleEntry {}
class FakeShalatNotifConfig extends Fake implements ShalatNotifConfig {}

void main() {
  late MockGetProvinsiShalat mockGetProvinsi;
  late MockGetKabkotaShalat mockGetKabkota;
  late MockGetJadwalShalat mockGetJadwalShalat;
  late MockGetLastLocationShalat mockGetLastLocation;
  late MockSaveLastLocationShalat mockSaveLastLocation;
  late MockLocationService mockLocationService;
  late MockShalatNotificationScheduler mockScheduler;
  late MockGetShalatNotifPrefs mockGetNotifPrefs;
  late MockSaveShalatNotifPrefs mockSaveNotifPrefs;

  setUpAll(() {
    registerFallbackValue(FakeJadwalShalatEntry());
    registerFallbackValue(FakeShalatNotifPrefs());
    registerFallbackValue(FakeShalatScheduleEntry());
    registerFallbackValue(FakeShalatNotifConfig());
  });

  setUp(() {
    mockGetProvinsi = MockGetProvinsiShalat();
    mockGetKabkota = MockGetKabkotaShalat();
    mockGetJadwalShalat = MockGetJadwalShalat();
    mockGetLastLocation = MockGetLastLocationShalat();
    mockSaveLastLocation = MockSaveLastLocationShalat();
    mockLocationService = MockLocationService();
    mockScheduler = MockShalatNotificationScheduler();
    mockGetNotifPrefs = MockGetShalatNotifPrefs();
    mockSaveNotifPrefs = MockSaveShalatNotifPrefs();

    // Default stubs untuk notification mocks
    when(() => mockGetNotifPrefs())
        .thenAnswer((_) async => right(const ShalatNotifPrefs()));
    when(
      () => mockScheduler.scheduleForToday(any(), any()),
    ).thenAnswer((_) async {});
    // Default stub save location — fire-and-forget, tidak perlu verify
    when(
      () => mockSaveLastLocation(
        provinsi: any(named: 'provinsi'),
        kabkota: any(named: 'kabkota'),
      ),
    ).thenAnswer((_) async => right(unit));
  });

  JadwalShalatCubit buildCubit() => JadwalShalatCubit(
    mockGetProvinsi,
    mockGetKabkota,
    mockGetJadwalShalat,
    mockGetLastLocation,
    mockSaveLastLocation,
    mockLocationService,
    mockScheduler,
    mockGetNotifPrefs,
    mockSaveNotifPrefs,
  );

  const tFailure = NetworkFailure();

  // Bulan & tahun sekarang (UTC+7): Mei 2026
  const tBulan = 5;
  const tTahun = 2026;

  group('init — tanpa last location', () {
    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'emits [loadingProvinsi, detectingLocation, loadingJadwal, success] saat GPS null → default Jakarta',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetProvinsi(),
        ).thenAnswer((_) async => right(tProvinsiList));
        when(() => mockGetLastLocation()).thenAnswer((_) async => right((provinsi: null, kabkota: null)));
        
        when(
          () => mockLocationService.detectCurrentLocation(),
        ).thenAnswer((_) async => null);
        when(
          () => mockGetKabkota('DKI Jakarta'),
        ).thenAnswer((_) async => right(tKabkotaJakartaList));
        
        
        when(
          () => mockGetJadwalShalat(
            provinsi: 'DKI Jakarta',
            kabkota: 'Kota Jakarta',
            bulan: tBulan,
            tahun: tTahun,
          ),
        ).thenAnswer((_) async => right(tJadwalShalat));
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const JadwalShalatState.loadingProvinsi(),
        const JadwalShalatState.detectingLocation(),
        const JadwalShalatState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          bulan: tBulan,
          tahun: tTahun,
        ),
        const JadwalShalatState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          jadwal: tJadwalShalat,
          bulan: tBulan,
          tahun: tTahun,
        ),
      ],
    );

    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'emits [loadingProvinsi, failure] saat getProvinsi gagal',
      build: buildCubit,
      setUp: () {
        when(() => mockGetProvinsi()).thenAnswer((_) async => left(tFailure));
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const JadwalShalatState.loadingProvinsi(),
        const JadwalShalatState.failure(failure: tFailure),
      ],
    );

    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'auto-load jadwal saat GPS cocok provinsi & kabkota',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetProvinsi(),
        ).thenAnswer((_) async => right(tProvinsiList));
        when(() => mockGetLastLocation()).thenAnswer((_) async => right((provinsi: null, kabkota: null)));
        
        when(() => mockLocationService.detectCurrentLocation()).thenAnswer(
          (_) async => const DetectedLocation(
            provinsi: 'DKI JAKARTA',
            kabkota: 'KOTA JAKARTA',
          ),
        );
        when(
          () => mockGetKabkota('DKI Jakarta'),
        ).thenAnswer((_) async => right(tKabkotaJakartaList));
        
        
        when(
          () => mockGetJadwalShalat(
            provinsi: 'DKI Jakarta',
            kabkota: 'Kota Jakarta',
            bulan: tBulan,
            tahun: tTahun,
          ),
        ).thenAnswer((_) async => right(tJadwalShalat));
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const JadwalShalatState.loadingProvinsi(),
        const JadwalShalatState.detectingLocation(),
        const JadwalShalatState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          bulan: tBulan,
          tahun: tTahun,
        ),
        const JadwalShalatState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          jadwal: tJadwalShalat,
          bulan: tBulan,
          tahun: tTahun,
        ),
      ],
    );
  });

  group('init — dengan last location', () {
    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'auto-load jadwal saat last location valid',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetProvinsi(),
        ).thenAnswer((_) async => right(tProvinsiList));
        when(
          () => mockGetLastLocation(),
        ).thenAnswer((_) async => right((provinsi: 'DKI Jakarta', kabkota: 'Kota Jakarta')));
        when(
          () => mockGetKabkota('DKI Jakarta'),
        ).thenAnswer((_) async => right(tKabkotaJakartaList));
        when(
          () => mockGetJadwalShalat(
            provinsi: 'DKI Jakarta',
            kabkota: 'Kota Jakarta',
            bulan: tBulan,
            tahun: tTahun,
          ),
        ).thenAnswer((_) async => right(tJadwalShalat));
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const JadwalShalatState.loadingProvinsi(),
        const JadwalShalatState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          bulan: tBulan,
          tahun: tTahun,
        ),
        const JadwalShalatState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          jadwal: tJadwalShalat,
          bulan: tBulan,
          tahun: tTahun,
        ),
      ],
    );

    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'fallback ke provinsiLoaded jika kabkota tidak valid',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetProvinsi(),
        ).thenAnswer((_) async => right(tProvinsiList));
        when(
          () => mockGetLastLocation(),
        ).thenAnswer((_) async => right((provinsi: 'DKI Jakarta', kabkota: 'Kota Tidak Ada')));
        when(
          () => mockGetKabkota('DKI Jakarta'),
        ).thenAnswer((_) async => right(tKabkotaJakartaList));
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const JadwalShalatState.loadingProvinsi(),
        const JadwalShalatState.provinsiLoaded(provinsi: tProvinsiList),
      ],
    );
  });

  group('selectProvinsi', () {
    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'emits [loadingKabkota, kabkotaLoaded] saat sukses',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetKabkota('DKI Jakarta'),
        ).thenAnswer((_) async => right(tKabkotaJakartaList));
      },
      act: (cubit) => cubit.selectProvinsi('DKI Jakarta'),
      expect: () => [
        const JadwalShalatState.loadingKabkota(
          provinsi: [],
          selectedProvinsi: 'DKI Jakarta',
        ),
        const JadwalShalatState.kabkotaLoaded(
          provinsi: [],
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
        ),
      ],
    );

    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'emits [loadingKabkota, failure] saat gagal',
      build: buildCubit,
      setUp: () {
        when(
          () => mockGetKabkota(any()),
        ).thenAnswer((_) async => left(tFailure));
      },
      act: (cubit) => cubit.selectProvinsi('DKI Jakarta'),
      expect: () => [
        const JadwalShalatState.loadingKabkota(
          provinsi: [],
          selectedProvinsi: 'DKI Jakarta',
        ),
        const JadwalShalatState.failure(
          failure: tFailure,
          provinsi: [],
          selectedProvinsi: 'DKI Jakarta',
        ),
      ],
    );
  });

  group('selectKabkota', () {
    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'emits [loadingJadwal, success] saat sukses',
      build: buildCubit,
      seed: () => const JadwalShalatState.kabkotaLoaded(
        provinsi: tProvinsiList,
        selectedProvinsi: 'DKI Jakarta',
        kabkota: tKabkotaJakartaList,
      ),
      setUp: () {
        
        
        when(
          () => mockGetJadwalShalat(
            provinsi: 'DKI Jakarta',
            kabkota: 'Kota Jakarta',
            bulan: tBulan,
            tahun: tTahun,
          ),
        ).thenAnswer((_) async => right(tJadwalShalat));
      },
      act: (cubit) => cubit.selectKabkota('Kota Jakarta'),
      expect: () => [
        const JadwalShalatState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          bulan: tBulan,
          tahun: tTahun,
        ),
        const JadwalShalatState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          jadwal: tJadwalShalat,
          bulan: tBulan,
          tahun: tTahun,
        ),
      ],
    );

    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'emits [loadingJadwal, failure] saat gagal',
      build: buildCubit,
      seed: () => const JadwalShalatState.kabkotaLoaded(
        provinsi: tProvinsiList,
        selectedProvinsi: 'DKI Jakarta',
        kabkota: tKabkotaJakartaList,
      ),
      setUp: () {
        
        
        when(
          () => mockGetJadwalShalat(
            provinsi: any(named: 'provinsi'),
            kabkota: any(named: 'kabkota'),
            bulan: any(named: 'bulan'),
            tahun: any(named: 'tahun'),
          ),
        ).thenAnswer((_) async => left(tFailure));
      },
      act: (cubit) => cubit.selectKabkota('Kota Jakarta'),
      expect: () => [
        const JadwalShalatState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          bulan: tBulan,
          tahun: tTahun,
        ),
        const JadwalShalatState.failure(
          failure: tFailure,
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          bulan: tBulan,
          tahun: tTahun,
        ),
      ],
    );
  });

  group('changeBulan', () {
    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'emits [loadingJadwal, success] saat ganti bulan berhasil',
      build: buildCubit,
      seed: () => const JadwalShalatState.success(
        provinsi: tProvinsiList,
        selectedProvinsi: 'DKI Jakarta',
        kabkota: tKabkotaJakartaList,
        selectedKabkota: 'Kota Jakarta',
        jadwal: tJadwalShalat,
        bulan: tBulan,
        tahun: tTahun,
      ),
      setUp: () {
        when(
          () => mockGetJadwalShalat(
            provinsi: 'DKI Jakarta',
            kabkota: 'Kota Jakarta',
            bulan: 6,
            tahun: 2026,
          ),
        ).thenAnswer((_) async => right(tJadwalShalat));
      },
      act: (cubit) => cubit.changeBulan(6, 2026),
      expect: () => [
        const JadwalShalatState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          bulan: 6,
          tahun: 2026,
        ),
        const JadwalShalatState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          jadwal: tJadwalShalat,
          bulan: 6,
          tahun: 2026,
        ),
      ],
    );

    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'tidak emit apapun jika state bukan success',
      build: buildCubit,
      act: (cubit) => cubit.changeBulan(6, 2026),
      expect: () => <JadwalShalatState>[],
    );
  });

  group('retry', () {
    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'retry dari failure tanpa context → init ulang → default Jakarta',
      build: buildCubit,
      seed: () => const JadwalShalatState.failure(failure: tFailure),
      setUp: () {
        when(
          () => mockGetProvinsi(),
        ).thenAnswer((_) async => right(tProvinsiList));
        when(() => mockGetLastLocation()).thenAnswer((_) async => right((provinsi: null, kabkota: null)));
        
        when(
          () => mockLocationService.detectCurrentLocation(),
        ).thenAnswer((_) async => null);
        when(
          () => mockGetKabkota('DKI Jakarta'),
        ).thenAnswer((_) async => right(tKabkotaJakartaList));
        
        
        when(
          () => mockGetJadwalShalat(
            provinsi: 'DKI Jakarta',
            kabkota: 'Kota Jakarta',
            bulan: tBulan,
            tahun: tTahun,
          ),
        ).thenAnswer((_) async => right(tJadwalShalat));
      },
      act: (cubit) => cubit.retry(),
      expect: () => [
        const JadwalShalatState.loadingProvinsi(),
        const JadwalShalatState.detectingLocation(),
        const JadwalShalatState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          bulan: tBulan,
          tahun: tTahun,
        ),
        const JadwalShalatState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          jadwal: tJadwalShalat,
          bulan: tBulan,
          tahun: tTahun,
        ),
      ],
    );

    blocTest<JadwalShalatCubit, JadwalShalatState>(
      'retry dari failure dengan context → load jadwal ulang',
      build: buildCubit,
      seed: () => const JadwalShalatState.failure(
        failure: tFailure,
        provinsi: tProvinsiList,
        selectedProvinsi: 'DKI Jakarta',
        kabkota: tKabkotaJakartaList,
        selectedKabkota: 'Kota Jakarta',
        bulan: tBulan,
        tahun: tTahun,
      ),
      setUp: () {
        when(
          () => mockGetJadwalShalat(
            provinsi: 'DKI Jakarta',
            kabkota: 'Kota Jakarta',
            bulan: tBulan,
            tahun: tTahun,
          ),
        ).thenAnswer((_) async => right(tJadwalShalat));
      },
      act: (cubit) => cubit.retry(),
      expect: () => [
        const JadwalShalatState.loadingJadwal(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          bulan: tBulan,
          tahun: tTahun,
        ),
        const JadwalShalatState.success(
          provinsi: tProvinsiList,
          selectedProvinsi: 'DKI Jakarta',
          kabkota: tKabkotaJakartaList,
          selectedKabkota: 'Kota Jakarta',
          jadwal: tJadwalShalat,
          bulan: tBulan,
          tahun: tTahun,
        ),
      ],
    );
  });
}
