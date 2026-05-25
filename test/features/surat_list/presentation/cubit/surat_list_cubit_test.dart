import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/surat_list/domain/usecases/get_surat_list.dart';
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockGetSuratList extends Mock implements GetSuratList {}

void main() {
  late MockGetSuratList mockGetSuratList;

  setUp(() {
    mockGetSuratList = MockGetSuratList();
  });

  group('SuratListCubit', () {
    blocTest<SuratListCubit, SuratListState>(
      'emits [loading, success] saat load() berhasil',
      build: () {
        when(
          () => mockGetSuratList(),
        ).thenAnswer((_) async => right(tSuratList));
        return SuratListCubit(mockGetSuratList);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const SuratListState.loading(),
        SuratListState.success(surats: tSuratList),
      ],
    );

    blocTest<SuratListCubit, SuratListState>(
      'emits [loading, failure] saat load() network error',
      build: () {
        when(
          () => mockGetSuratList(),
        ).thenAnswer((_) async => left(const Failure.network()));
        return SuratListCubit(mockGetSuratList);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const SuratListState.loading(),
        const SuratListState.failure(failure: Failure.network()),
      ],
    );

    blocTest<SuratListCubit, SuratListState>(
      'emits [loading, failure] saat load() server error',
      build: () {
        when(() => mockGetSuratList()).thenAnswer(
          (_) async => left(const Failure.server(statusCode: 500)),
        );
        return SuratListCubit(mockGetSuratList);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const SuratListState.loading(),
        const SuratListState.failure(
          failure: Failure.server(statusCode: 500),
        ),
      ],
    );

    blocTest<SuratListCubit, SuratListState>(
      'onQueryChanged() update query di success state',
      build: () {
        when(
          () => mockGetSuratList(),
        ).thenAnswer((_) async => right(tSuratList));
        return SuratListCubit(mockGetSuratList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.onQueryChanged('fatihah');
      },
      expect: () => [
        const SuratListState.loading(),
        SuratListState.success(surats: tSuratList),
        SuratListState.success(surats: tSuratList, query: 'fatihah'),
      ],
    );

    blocTest<SuratListCubit, SuratListState>(
      'onQueryChanged() tidak emit jika state bukan success',
      build: () => SuratListCubit(mockGetSuratList),
      act: (cubit) => cubit.onQueryChanged('test'),
      expect: () => <SuratListState>[],
    );

    blocTest<SuratListCubit, SuratListState>(
      'filtered getter return semua surat jika query kosong',
      build: () {
        when(
          () => mockGetSuratList(),
        ).thenAnswer((_) async => right(tSuratList));
        return SuratListCubit(mockGetSuratList);
      },
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        final state = cubit.state as SuratListSuccess;
        expect(state.filtered.length, 2);
      },
    );

    blocTest<SuratListCubit, SuratListState>(
      'filtered getter filter berdasarkan namaLatin',
      build: () {
        when(
          () => mockGetSuratList(),
        ).thenAnswer((_) async => right(tSuratList));
        return SuratListCubit(mockGetSuratList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.onQueryChanged('fatihah');
      },
      verify: (cubit) {
        final state = cubit.state as SuratListSuccess;
        expect(state.filtered.length, 1);
        expect(state.filtered.first.namaLatin, 'Al-Fatihah');
      },
    );

    blocTest<SuratListCubit, SuratListState>(
      'retry() memanggil load() ulang',
      build: () {
        when(
          () => mockGetSuratList(),
        ).thenAnswer((_) async => right(tSuratList));
        return SuratListCubit(mockGetSuratList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.retry();
      },
      verify: (_) {
        verify(() => mockGetSuratList()).called(2);
      },
    );
  });
}
