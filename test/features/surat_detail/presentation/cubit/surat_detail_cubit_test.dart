import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/surat_detail/domain/usecases/get_surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/cubit/surat_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockGetSuratDetail extends Mock implements GetSuratDetail {}

void main() {
  late MockGetSuratDetail mockGetSuratDetail;

  setUp(() {
    mockGetSuratDetail = MockGetSuratDetail();
    registerFallbackValue(const SuratDetailParams(nomor: 1));
  });

  group('SuratDetailCubit', () {
    blocTest<SuratDetailCubit, SuratDetailState>(
      'emits [loading, success] saat load() berhasil',
      build: () {
        when(() => mockGetSuratDetail(any()))
            .thenAnswer((_) async => right(tSuratDetail));
        return SuratDetailCubit(mockGetSuratDetail);
      },
      act: (cubit) => cubit.load(1),
      expect: () => [
        const SuratDetailState.loading(),
        const SuratDetailState.success(detail: tSuratDetail),
      ],
    );

    blocTest<SuratDetailCubit, SuratDetailState>(
      'emits [loading, failure] saat load() network error',
      build: () {
        when(() => mockGetSuratDetail(any()))
            .thenAnswer((_) async => left(const Failure.network()));
        return SuratDetailCubit(mockGetSuratDetail);
      },
      act: (cubit) => cubit.load(1),
      expect: () => [
        const SuratDetailState.loading(),
        const SuratDetailState.failure(failure: Failure.network()),
      ],
    );

    blocTest<SuratDetailCubit, SuratDetailState>(
      'load() memanggil usecase dengan params yang benar',
      build: () {
        when(() => mockGetSuratDetail(any()))
            .thenAnswer((_) async => right(tSuratDetail));
        return SuratDetailCubit(mockGetSuratDetail);
      },
      act: (cubit) => cubit.load(5),
      verify: (_) {
        verify(
          () => mockGetSuratDetail(const SuratDetailParams(nomor: 5)),
        ).called(1);
      },
    );

    blocTest<SuratDetailCubit, SuratDetailState>(
      'retry() memanggil load() ulang',
      build: () {
        when(() => mockGetSuratDetail(any()))
            .thenAnswer((_) async => right(tSuratDetail));
        return SuratDetailCubit(mockGetSuratDetail);
      },
      act: (cubit) async {
        await cubit.load(1);
        cubit.retry(1);
      },
      verify: (_) {
        verify(() => mockGetSuratDetail(any())).called(2);
      },
    );
  });
}
