import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/tafsir/domain/usecases/get_tafsir.dart';
import 'package:equran_app/features/tafsir/presentation/cubit/tafsir_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockGetTafsir extends Mock implements GetTafsir {}

void main() {
  late MockGetTafsir mockGetTafsir;

  setUp(() {
    mockGetTafsir = MockGetTafsir();
    registerFallbackValue(const TafsirParams(nomor: 1));
  });

  group('TafsirCubit', () {
    blocTest<TafsirCubit, TafsirState>(
      'emits [loading, success] saat load() berhasil',
      build: () {
        when(
          () => mockGetTafsir(any()),
        ).thenAnswer((_) async => right(tTafsirSurat));
        return TafsirCubit(mockGetTafsir);
      },
      act: (cubit) => cubit.load(1),
      expect: () => [
        const TafsirState.loading(),
        const TafsirState.success(tafsir: tTafsirSurat),
      ],
    );

    blocTest<TafsirCubit, TafsirState>(
      'emits [loading, failure] saat load() network error',
      build: () {
        when(
          () => mockGetTafsir(any()),
        ).thenAnswer((_) async => left(const Failure.network()));
        return TafsirCubit(mockGetTafsir);
      },
      act: (cubit) => cubit.load(1),
      expect: () => [
        const TafsirState.loading(),
        const TafsirState.failure(failure: Failure.network()),
      ],
    );

    blocTest<TafsirCubit, TafsirState>(
      'load() memanggil usecase dengan params yang benar',
      build: () {
        when(
          () => mockGetTafsir(any()),
        ).thenAnswer((_) async => right(tTafsirSurat));
        return TafsirCubit(mockGetTafsir);
      },
      act: (cubit) => cubit.load(3),
      verify: (_) {
        verify(
          () => mockGetTafsir(const TafsirParams(nomor: 3)),
        ).called(1);
      },
    );

    blocTest<TafsirCubit, TafsirState>(
      'retry() memanggil load() ulang',
      build: () {
        when(
          () => mockGetTafsir(any()),
        ).thenAnswer((_) async => right(tTafsirSurat));
        return TafsirCubit(mockGetTafsir);
      },
      act: (cubit) async {
        await cubit.load(1);
        cubit.retry(1);
      },
      verify: (_) {
        verify(() => mockGetTafsir(any())).called(2);
      },
    );
  });
}
