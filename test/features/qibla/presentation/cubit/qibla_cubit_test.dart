import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/qibla/domain/entities/qibla_direction.dart';
import 'package:equran_app/features/qibla/domain/usecases/init_qibla.dart';
import 'package:equran_app/features/qibla/domain/usecases/watch_qibla_direction.dart';
import 'package:equran_app/features/qibla/presentation/cubit/qibla_cubit.dart';
import 'package:equran_app/features/qibla/presentation/cubit/qibla_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockInitQibla extends Mock implements InitQibla {}

class MockWatchQiblaDirection extends Mock implements WatchQiblaDirection {}

const tDirection = QiblaDirection(
  bearing: 295,
  deviceHeading: 0,
  qiblaAngle: 295,
  accuracy: 10,
);

const tDirectionUpdated = QiblaDirection(
  bearing: 295,
  deviceHeading: 45,
  qiblaAngle: 250,
  accuracy: 10,
);

void main() {
  late MockInitQibla mockInitQibla;
  late MockWatchQiblaDirection mockWatchQiblaDirection;

  setUp(() {
    mockInitQibla = MockInitQibla();
    mockWatchQiblaDirection = MockWatchQiblaDirection();
  });

  QiblaCubit buildCubit() => QiblaCubit(
    initQibla: mockInitQibla,
    watchQiblaDirection: mockWatchQiblaDirection,
  );

  group('QiblaCubit — initial state', () {
    test('state awal adalah QiblaInitial', () {
      final cubit = buildCubit();
      expect(cubit.state, const QiblaState.initial());
    });
  });

  group('QiblaCubit — start()', () {
    blocTest<QiblaCubit, QiblaState>(
      'start() emit loading lalu loaded saat init dan sensor berhasil',
      build: () {
        when(() => mockInitQibla.call()).thenAnswer((_) async => right(unit));
        when(
          () => mockWatchQiblaDirection.call(),
        ).thenReturn(right(Stream.value(tDirection)));
        return buildCubit();
      },
      act: (cubit) => cubit.start(),
      expect: () => [
        const QiblaState.loading(),
        const QiblaState.loaded(direction: tDirection),
      ],
    );

    blocTest<QiblaCubit, QiblaState>(
      'start() emit loading lalu error saat init gagal (permission denied)',
      build: () {
        when(() => mockInitQibla.call()).thenAnswer(
          (_) async => left(
            const Failure.unknown(message: 'Izin lokasi ditolak.'),
          ),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.start(),
      expect: () => [
        const QiblaState.loading(),
        isA<QiblaError>(),
      ],
    );

    blocTest<QiblaCubit, QiblaState>(
      'start() emit loading lalu error saat GPS mati',
      build: () {
        when(() => mockInitQibla.call()).thenAnswer(
          (_) async => left(
            const Failure.unknown(message: 'Layanan lokasi tidak aktif.'),
          ),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.start(),
      expect: () => [
        const QiblaState.loading(),
        isA<QiblaError>(),
      ],
    );

    blocTest<QiblaCubit, QiblaState>(
      'start() emit loading lalu noSensor saat sensor kompas tidak ada',
      build: () {
        when(() => mockInitQibla.call()).thenAnswer((_) async => right(unit));
        when(() => mockWatchQiblaDirection.call()).thenReturn(
          left(
            const Failure.unknown(
              message: 'Perangkat tidak memiliki sensor kompas.',
            ),
          ),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.start(),
      expect: () => [
        const QiblaState.loading(),
        const QiblaState.noSensor(),
      ],
    );

    blocTest<QiblaCubit, QiblaState>(
      'start() emit multiple loaded saat stream emit beberapa direction',
      build: () {
        when(() => mockInitQibla.call()).thenAnswer((_) async => right(unit));
        when(() => mockWatchQiblaDirection.call()).thenReturn(
          right(Stream.fromIterable([tDirection, tDirectionUpdated])),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.start(),
      expect: () => [
        const QiblaState.loading(),
        const QiblaState.loaded(direction: tDirection),
        const QiblaState.loaded(direction: tDirectionUpdated),
      ],
    );

    blocTest<QiblaCubit, QiblaState>(
      'start() tidak melakukan apapun jika sudah loading',
      build: () {
        when(() => mockInitQibla.call()).thenAnswer((_) async => right(unit));
        when(() => mockWatchQiblaDirection.call()).thenReturn(
          right(StreamController<QiblaDirection>.broadcast().stream),
        );
        return buildCubit();
      },
      act: (cubit) async {
        unawaited(cubit.start());
        await cubit.start(); // panggil kedua kali saat masih loading
      },
      expect: () => [
        const QiblaState.loading(),
        // tidak ada state tambahan
      ],
    );
  });

  group('QiblaCubit — stop()', () {
    blocTest<QiblaCubit, QiblaState>(
      'stop() reset state ke initial',
      build: () {
        final controller = StreamController<QiblaDirection>();
        when(() => mockInitQibla.call()).thenAnswer((_) async => right(unit));
        when(
          () => mockWatchQiblaDirection.call(),
        ).thenReturn(right(controller.stream));
        return buildCubit();
      },
      act: (cubit) async {
        await cubit.start();
        cubit.stop();
      },
      expect: () => [
        const QiblaState.loading(),
        const QiblaState.initial(),
      ],
    );
  });
}
