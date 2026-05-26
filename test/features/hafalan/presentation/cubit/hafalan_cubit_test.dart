import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/notifications/hafalan_reminder_scheduler.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/delete_hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/usecases/get_all_hafalan.dart';
import 'package:equran_app/features/hafalan/domain/usecases/get_hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/usecases/save_hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllHafalan extends Mock implements GetAllHafalan {}

class MockSaveHafalanSurat extends Mock implements SaveHafalanSurat {}

class MockDeleteHafalanSurat extends Mock implements DeleteHafalanSurat {}

class MockGetHafalanStats extends Mock implements GetHafalanStats {}

class MockHafalanReminderScheduler extends Mock
    implements HafalanReminderScheduler {}

void main() {
  late MockGetAllHafalan mockGetAll;
  late MockSaveHafalanSurat mockSave;
  late MockDeleteHafalanSurat mockDelete;
  late MockGetHafalanStats mockGetStats;
  late MockHafalanReminderScheduler mockScheduler;

  final tHafalan = HafalanSurat(
    suratNomor: 1,
    namaLatin: 'Al-Fatihah',
    nama: 'الْفَاتِحَةُ',
    jumlahAyat: 7,
    status: HafalanStatus.sedangDihafal,
    ayatHafal: const [1, 2, 3],
    tanggalMulai: DateTime(2024),
  );

  final tStats = HafalanStats.empty();

  setUpAll(() {
    registerFallbackValue(
      const HafalanSurat(
        suratNomor: 0,
        namaLatin: '',
        nama: '',
        jumlahAyat: 0,
      ),
    );
  });

  setUp(() {
    mockGetAll = MockGetAllHafalan();
    mockSave = MockSaveHafalanSurat();
    mockDelete = MockDeleteHafalanSurat();
    mockGetStats = MockGetHafalanStats();
    mockScheduler = MockHafalanReminderScheduler();

    // Default stubs
    when(() => mockGetAll()).thenReturn(Right([tHafalan]));
    when(() => mockGetStats()).thenReturn(Right(tStats));
    when(() => mockSave(any())).thenAnswer((_) async => const Right(unit));
    when(() => mockDelete(any())).thenAnswer((_) async => const Right(unit));
    when(
      () => mockScheduler.scheduleReminder(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockScheduler.cancelReminder(any()),
    ).thenAnswer((_) async {});
  });

  HafalanCubit buildCubit() => HafalanCubit(
    mockGetAll,
    mockSave,
    mockDelete,
    mockGetStats,
    mockScheduler,
  );

  group('HafalanCubit', () {
    test('initial state adalah HafalanInitial', () {
      expect(buildCubit().state, const HafalanState.initial());
    });

    // ── load() ──────────────────────────────────────────────────────────────

    blocTest<HafalanCubit, HafalanState>(
      'load() emit loading lalu success',
      build: buildCubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const HafalanState.loading(),
        isA<HafalanSuccess>()
            .having((s) => s.hafalanList.length, 'hafalanList.length', 1)
            .having((s) => s.filter, 'filter', HafalanFilter.semua),
      ],
    );

    blocTest<HafalanCubit, HafalanState>(
      'load() emit failure jika getAllHafalan gagal',
      build: () {
        when(() => mockGetAll()).thenReturn(
          const Left(Failure.unknown(message: 'error')),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const HafalanState.loading(),
        isA<HafalanFailure>(),
      ],
    );

    // ── toggleAyat() ─────────────────────────────────────────────────────────

    blocTest<HafalanCubit, HafalanState>(
      'toggleAyat() tambah ayat baru ke ayatHafal',
      build: buildCubit,
      seed: () => HafalanState.success(
        hafalanList: [tHafalan],
        stats: tStats,
      ),
      act: (cubit) => cubit.toggleAyat(
        suratNomor: 1,
        ayatNomor: 4,
        suratInfo: tHafalan,
      ),
      verify: (_) {
        final captured = verify(
          () => mockSave(captureAny()),
        ).captured;
        final saved = captured.first as HafalanSurat;
        expect(saved.ayatHafal, containsAll([1, 2, 3, 4]));
      },
    );

    blocTest<HafalanCubit, HafalanState>(
      'toggleAyat() hapus ayat yang sudah ada',
      build: buildCubit,
      seed: () => HafalanState.success(
        hafalanList: [tHafalan],
        stats: tStats,
      ),
      act: (cubit) => cubit.toggleAyat(
        suratNomor: 1,
        ayatNomor: 3,
        suratInfo: tHafalan,
      ),
      verify: (_) {
        final captured = verify(
          () => mockSave(captureAny()),
        ).captured;
        final saved = captured.first as HafalanSurat;
        expect(saved.ayatHafal, isNot(contains(3)));
      },
    );

    blocTest<HafalanCubit, HafalanState>(
      'toggleAyat() set sudahHafal dan jadwal murajaah saat semua ayat selesai',
      build: buildCubit,
      seed: () => HafalanState.success(
        hafalanList: [
          tHafalan.copyWith(ayatHafal: [1, 2, 3, 4, 5, 6]),
        ],
        stats: tStats,
      ),
      act: (cubit) => cubit.toggleAyat(
        suratNomor: 1,
        ayatNomor: 7,
        suratInfo: tHafalan,
      ),
      verify: (_) {
        final captured = verify(
          () => mockSave(captureAny()),
        ).captured;
        final saved = captured.first as HafalanSurat;
        expect(saved.status, HafalanStatus.sudahHafal);
        expect(saved.tanggalMurajaahBerikutnya, isNotNull);
        expect(saved.murajaahLevel, 0);
      },
    );

    // ── setStatus() ──────────────────────────────────────────────────────────

    blocTest<HafalanCubit, HafalanState>(
      'setStatus() update status hafalan',
      build: buildCubit,
      seed: () => HafalanState.success(
        hafalanList: [tHafalan],
        stats: tStats,
      ),
      act: (cubit) => cubit.setStatus(
        suratNomor: 1,
        status: HafalanStatus.sudahHafal,
      ),
      verify: (_) {
        final captured = verify(
          () => mockSave(captureAny()),
        ).captured;
        final saved = captured.first as HafalanSurat;
        expect(saved.status, HafalanStatus.sudahHafal);
        expect(saved.ayatHafal.length, 7); // semua ayat di-fill
      },
    );

    // ── tandaiSudahMurajaah() ─────────────────────────────────────────────────

    blocTest<HafalanCubit, HafalanState>(
      'tandaiSudahMurajaah() naik level dan set tanggal berikutnya',
      build: buildCubit,
      seed: () => HafalanState.success(
        hafalanList: [
          tHafalan.copyWith(
            status: HafalanStatus.sudahHafal,
            murajaahLevel: 0,
            tanggalMurajaahBerikutnya: DateTime(2024),
          ),
        ],
        stats: tStats,
      ),
      act: (cubit) => cubit.tandaiSudahMurajaah(1),
      verify: (_) {
        final captured = verify(
          () => mockSave(captureAny()),
        ).captured;
        final saved = captured.first as HafalanSurat;
        expect(saved.murajaahLevel, 1);
        expect(saved.tanggalMurajaahBerikutnya, isNotNull);
      },
    );

    blocTest<HafalanCubit, HafalanState>(
      'tandaiSudahMurajaah() set null saat level max',
      build: buildCubit,
      seed: () => HafalanState.success(
        hafalanList: [
          tHafalan.copyWith(
            status: HafalanStatus.sudahHafal,
            murajaahLevel: 4,
            tanggalMurajaahBerikutnya: DateTime(2024),
          ),
        ],
        stats: tStats,
      ),
      act: (cubit) => cubit.tandaiSudahMurajaah(1),
      verify: (_) {
        final captured = verify(
          () => mockSave(captureAny()),
        ).captured;
        final saved = captured.first as HafalanSurat;
        expect(saved.murajaahLevel, 5);
        expect(saved.tanggalMurajaahBerikutnya, isNull);
      },
    );

    // ── setFilter() ──────────────────────────────────────────────────────────

    blocTest<HafalanCubit, HafalanState>(
      'setFilter() update filter tanpa reload',
      build: buildCubit,
      seed: () => HafalanState.success(
        hafalanList: [tHafalan],
        stats: tStats,
      ),
      act: (cubit) => cubit.setFilter(HafalanFilter.sudahHafal),
      expect: () => [
        isA<HafalanSuccess>().having(
          (s) => s.filter,
          'filter',
          HafalanFilter.sudahHafal,
        ),
      ],
      verify: (_) => verifyNever(() => mockGetAll()),
    );

    // ── deleteSurat() ─────────────────────────────────────────────────────────

    blocTest<HafalanCubit, HafalanState>(
      'deleteSurat() hapus data dan cancel notifikasi',
      build: buildCubit,
      seed: () => HafalanState.success(
        hafalanList: [tHafalan],
        stats: tStats,
      ),
      act: (cubit) => cubit.deleteSurat(1),
      verify: (_) {
        verify(() => mockScheduler.cancelReminder(1)).called(1);
        verify(() => mockDelete(1)).called(1);
      },
    );

    // ── getSurat() / isAyatHafal() ────────────────────────────────────────────

    test('getSurat() return hafalan jika ada', () {
      final cubit = buildCubit()
        ..emit(
          HafalanState.success(hafalanList: [tHafalan], stats: tStats),
        );

      expect(cubit.getSurat(1), tHafalan);
      expect(cubit.getSurat(99), isNull);
    });

    test('isAyatHafal() return true jika ayat ada di list', () {
      final cubit = buildCubit()
        ..emit(
          HafalanState.success(hafalanList: [tHafalan], stats: tStats),
        );

      expect(cubit.isAyatHafal(suratNomor: 1, ayatNomor: 1), isTrue);
      expect(cubit.isAyatHafal(suratNomor: 1, ayatNomor: 7), isFalse);
    });
  });
}
