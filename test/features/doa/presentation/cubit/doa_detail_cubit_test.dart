import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_detail.dart';
import 'package:equran_app/features/doa/presentation/cubit/doa_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockGetDoaDetail extends Mock implements GetDoaDetail {}

void main() {
  late MockGetDoaDetail mockGetDoaDetail;

  setUp(() {
    mockGetDoaDetail = MockGetDoaDetail();
  });

  group('DoaDetailCubit', () {
    // ── load ──────────────────────────────────────────────────────────────────

    blocTest<DoaDetailCubit, DoaDetailState>(
      'emits [loading, success] saat load() berhasil',
      build: () {
        when(() => mockGetDoaDetail(1)).thenAnswer((_) async => right(tDoa1));
        return DoaDetailCubit(mockGetDoaDetail);
      },
      act: (cubit) => cubit.load(1),
      expect: () => [
        const DoaDetailState.loading(),
        const DoaDetailState.success(doa: tDoa1),
      ],
    );

    blocTest<DoaDetailCubit, DoaDetailState>(
      'emits [loading, failure] saat load() network error',
      build: () {
        when(
          () => mockGetDoaDetail(1),
        ).thenAnswer((_) async => left(const Failure.network()));
        return DoaDetailCubit(mockGetDoaDetail);
      },
      act: (cubit) => cubit.load(1),
      expect: () => [
        const DoaDetailState.loading(),
        const DoaDetailState.failure(failure: Failure.network()),
      ],
    );

    blocTest<DoaDetailCubit, DoaDetailState>(
      'emits [loading, failure] saat load() server error',
      build: () {
        when(() => mockGetDoaDetail(1)).thenAnswer(
          (_) async => left(const Failure.server(statusCode: 404)),
        );
        return DoaDetailCubit(mockGetDoaDetail);
      },
      act: (cubit) => cubit.load(1),
      expect: () => [
        const DoaDetailState.loading(),
        const DoaDetailState.failure(
          failure: Failure.server(statusCode: 404),
        ),
      ],
    );

    // ── retry ─────────────────────────────────────────────────────────────────

    blocTest<DoaDetailCubit, DoaDetailState>(
      'retry() memanggil load() ulang dengan id yang sama',
      build: () {
        when(() => mockGetDoaDetail(1)).thenAnswer((_) async => right(tDoa1));
        return DoaDetailCubit(mockGetDoaDetail);
      },
      act: (cubit) async {
        await cubit.load(1);
        cubit.retry();
      },
      verify: (_) {
        verify(() => mockGetDoaDetail(1)).called(2);
      },
    );

    blocTest<DoaDetailCubit, DoaDetailState>(
      'retry() tidak melakukan apa-apa jika belum pernah load()',
      build: () => DoaDetailCubit(mockGetDoaDetail),
      act: (cubit) => cubit.retry(),
      expect: () => <DoaDetailState>[],
    );

    // ── edge case id 42 ───────────────────────────────────────────────────────

    blocTest<DoaDetailCubit, DoaDetailState>(
      'load() handle doa dengan tr dan idn kosong (id 42)',
      build: () {
        when(() => mockGetDoaDetail(42)).thenAnswer((_) async => right(tDoa42));
        return DoaDetailCubit(mockGetDoaDetail);
      },
      act: (cubit) => cubit.load(42),
      expect: () => [
        const DoaDetailState.loading(),
        const DoaDetailState.success(doa: tDoa42),
      ],
      verify: (cubit) {
        final state = cubit.state as DoaDetailSuccess;
        expect(state.doa.tr, '');
        expect(state.doa.idn, '');
      },
    );
  });
}
