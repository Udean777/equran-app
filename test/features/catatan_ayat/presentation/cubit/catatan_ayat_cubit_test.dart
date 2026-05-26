import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/delete_catatan.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/get_all_catatan.dart';
import 'package:equran_app/features/catatan_ayat/domain/usecases/save_catatan.dart';
import 'package:equran_app/features/catatan_ayat/presentation/cubit/catatan_ayat_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCatatan extends Mock implements GetAllCatatan {}

class MockSaveCatatan extends Mock implements SaveCatatan {}

class MockDeleteCatatan extends Mock implements DeleteCatatan {}

void main() {
  late MockGetAllCatatan mockGetAll;
  late MockSaveCatatan mockSave;
  late MockDeleteCatatan mockDelete;

  final tCatatan = CatatanAyat(
    suratNomor: 1,
    ayatNomor: 1,
    namaLatin: 'Al-Fatihah',
    teksArab: 'بِسْمِ اللّٰهِ',
    isi: 'Catatan test',
    savedAt: DateTime(2024, 1, 1),
  );

  setUp(() {
    mockGetAll = MockGetAllCatatan();
    mockSave = MockSaveCatatan();
    mockDelete = MockDeleteCatatan();
  });

  CatatanAyatCubit buildCubit() =>
      CatatanAyatCubit(mockGetAll, mockSave, mockDelete);

  group('CatatanAyatCubit', () {
    test('initial state adalah CatatanAyatInitial', () {
      when(() => mockGetAll()).thenReturn(const Right([]));
      expect(buildCubit().state, const CatatanAyatState.initial());
    });

    // ── load() ───────────────────────────────────────────────────────────────
    blocTest<CatatanAyatCubit, CatatanAyatState>(
      'load() emit [loading, success] saat getAll berhasil',
      build: () {
        when(() => mockGetAll()).thenReturn(Right([tCatatan]));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const CatatanAyatState.loading(),
        CatatanAyatState.success([tCatatan]),
      ],
    );

    blocTest<CatatanAyatCubit, CatatanAyatState>(
      'load() emit [loading, success([])] saat list kosong',
      build: () {
        when(() => mockGetAll()).thenReturn(const Right([]));
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const CatatanAyatState.loading(),
        const CatatanAyatState.success([]),
      ],
    );

    blocTest<CatatanAyatCubit, CatatanAyatState>(
      'load() emit [loading, failure] saat getAll gagal',
      build: () {
        when(() => mockGetAll()).thenReturn(
          const Left(Failure.unknown(message: 'error')),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const CatatanAyatState.loading(),
        const CatatanAyatState.failure('Gagal memuat catatan'),
      ],
    );

    // ── save() ───────────────────────────────────────────────────────────────
    blocTest<CatatanAyatCubit, CatatanAyatState>(
      'save() simpan catatan lalu reload',
      build: () {
        when(
          () => mockSave(tCatatan),
        ).thenAnswer((_) async => const Right(unit));
        when(() => mockGetAll()).thenReturn(Right([tCatatan]));
        return buildCubit();
      },
      act: (cubit) => cubit.save(tCatatan),
      expect: () => [
        const CatatanAyatState.loading(),
        CatatanAyatState.success([tCatatan]),
      ],
      verify: (_) {
        verify(() => mockSave(tCatatan)).called(1);
      },
    );

    blocTest<CatatanAyatCubit, CatatanAyatState>(
      'save() emit failure jika save gagal',
      build: () {
        when(() => mockSave(tCatatan)).thenAnswer(
          (_) async => const Left(Failure.unknown(message: 'error')),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.save(tCatatan),
      expect: () => [
        const CatatanAyatState.failure('Gagal menyimpan catatan'),
      ],
    );

    // ── delete() ─────────────────────────────────────────────────────────────
    blocTest<CatatanAyatCubit, CatatanAyatState>(
      'delete() hapus catatan lalu reload',
      build: () {
        when(
          () => mockDelete(suratNomor: 1, ayatNomor: 1),
        ).thenAnswer((_) async => const Right(unit));
        when(() => mockGetAll()).thenReturn(const Right([]));
        return buildCubit();
      },
      act: (cubit) => cubit.delete(suratNomor: 1, ayatNomor: 1),
      expect: () => [
        const CatatanAyatState.loading(),
        const CatatanAyatState.success([]),
      ],
      verify: (_) {
        verify(() => mockDelete(suratNomor: 1, ayatNomor: 1)).called(1);
      },
    );

    blocTest<CatatanAyatCubit, CatatanAyatState>(
      'delete() emit failure jika delete gagal',
      build: () {
        when(
          () => mockDelete(suratNomor: 1, ayatNomor: 1),
        ).thenAnswer(
          (_) async => const Left(Failure.unknown(message: 'error')),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.delete(suratNomor: 1, ayatNomor: 1),
      expect: () => [
        const CatatanAyatState.failure('Gagal menghapus catatan'),
      ],
    );

    // ── hasCatatan() ─────────────────────────────────────────────────────────
    test('hasCatatan() return true jika catatan ada di state success', () {
      when(() => mockGetAll()).thenReturn(Right([tCatatan]));
      final cubit = buildCubit()..load();
      expect(
        cubit.hasCatatan(suratNomor: 1, ayatNomor: 1),
        isTrue,
      );
    });

    test('hasCatatan() return false jika catatan tidak ada', () {
      when(() => mockGetAll()).thenReturn(Right([tCatatan]));
      final cubit = buildCubit()..load();
      expect(
        cubit.hasCatatan(suratNomor: 2, ayatNomor: 5),
        isFalse,
      );
    });

    test('hasCatatan() return false jika state bukan success', () {
      when(() => mockGetAll()).thenReturn(const Right([]));
      final cubit = buildCubit();
      // state masih initial
      expect(
        cubit.hasCatatan(suratNomor: 1, ayatNomor: 1),
        isFalse,
      );
    });

    // ── getCatatan() ──────────────────────────────────────────────────────────
    test('getCatatan() return catatan yang benar', () {
      when(() => mockGetAll()).thenReturn(Right([tCatatan]));
      final cubit = buildCubit()..load();
      final result = cubit.getCatatan(suratNomor: 1, ayatNomor: 1);
      expect(result, tCatatan);
    });

    test('getCatatan() return null jika tidak ada', () {
      when(() => mockGetAll()).thenReturn(Right([tCatatan]));
      final cubit = buildCubit()..load();
      final result = cubit.getCatatan(suratNomor: 2, ayatNomor: 5);
      expect(result, isNull);
    });
  });
}
