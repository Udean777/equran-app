import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_preset.dart';
import 'package:equran_app/features/tasbih/domain/usecases/clear_tasbih_sessions.dart';
import 'package:equran_app/features/tasbih/domain/usecases/delete_tasbih_session.dart';
import 'package:equran_app/features/tasbih/domain/usecases/get_tasbih_sessions.dart';
import 'package:equran_app/features/tasbih/domain/usecases/save_tasbih_session.dart';
import 'package:equran_app/features/tasbih/presentation/cubit/tasbih_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_tasbih_data.dart';

class MockGetTasbihSessions extends Mock implements GetTasbihSessions {}

class MockSaveTasbihSession extends Mock implements SaveTasbihSession {}

class MockDeleteTasbihSession extends Mock implements DeleteTasbihSession {}

class MockClearTasbihSessions extends Mock implements ClearTasbihSessions {}

/// No-op haptic untuk unit test — tidak butuh platform channel.
Future<void> _noOpHaptic() async {}

void main() {
  late MockGetTasbihSessions mockGetSessions;
  late MockSaveTasbihSession mockSaveSession;
  late MockDeleteTasbihSession mockDeleteSession;
  late MockClearTasbihSessions mockClearSessions;

  setUp(() {
    mockGetSessions = MockGetTasbihSessions();
    mockSaveSession = MockSaveTasbihSession();
    mockDeleteSession = MockDeleteTasbihSession();
    mockClearSessions = MockClearTasbihSessions();

    registerFallbackValue(tSession);
  });

  TasbihCubit buildCubit() => TasbihCubit.withHaptic(
    mockGetSessions,
    mockSaveSession,
    mockDeleteSession,
    mockClearSessions,
    lightImpact: _noOpHaptic,
    heavyImpact: _noOpHaptic,
  );

  final initialPreset = TasbihPreset.defaults.first;

  group('TasbihCubit — initial state', () {
    test('state awal menggunakan preset pertama dengan count 0', () {
      final cubit = buildCubit();
      expect(cubit.state.count, 0);
      expect(cubit.state.isCompleted, false);
      expect(cubit.state.selectedPreset, initialPreset);
      expect(cubit.state.target, initialPreset.defaultTarget);
      expect(cubit.state.hapticEnabled, true);
    });
  });

  group('TasbihCubit — increment', () {
    blocTest<TasbihCubit, TasbihState>(
      'increment() menambah count sebesar 1',
      build: buildCubit,
      act: (cubit) => cubit.increment(),
      expect: () => [
        isA<TasbihState>().having((s) => s.count, 'count', 1),
      ],
    );

    blocTest<TasbihCubit, TasbihState>(
      'increment() tidak menambah count jika sudah completed',
      build: () {
        when(() => mockSaveSession(any())).thenAnswer((_) async => right(unit));
        return buildCubit()..setTarget(1);
      },
      act: (cubit) async {
        await cubit.increment(); // completed = true
        await cubit.increment(); // harus diabaikan
      },
      verify: (cubit) {
        expect(cubit.state.count, 1);
        expect(cubit.state.isCompleted, true);
      },
    );

    blocTest<TasbihCubit, TasbihState>(
      'increment() emit isCompleted=true saat count mencapai target',
      build: () {
        when(() => mockSaveSession(any())).thenAnswer((_) async => right(unit));
        return buildCubit()..setTarget(2);
      },
      act: (cubit) async {
        await cubit.increment();
        await cubit.increment();
      },
      verify: (cubit) {
        expect(cubit.state.count, 2);
        expect(cubit.state.isCompleted, true);
      },
    );

    blocTest<TasbihCubit, TasbihState>(
      'increment() memanggil saveSession saat target tercapai',
      build: () {
        when(() => mockSaveSession(any())).thenAnswer((_) async => right(unit));
        return buildCubit()..setTarget(1);
      },
      act: (cubit) => cubit.increment(),
      verify: (_) {
        verify(() => mockSaveSession(any())).called(1);
      },
    );
  });

  group('TasbihCubit — reset', () {
    blocTest<TasbihCubit, TasbihState>(
      'reset() mengembalikan count ke 0 dan isCompleted ke false',
      build: () {
        when(() => mockSaveSession(any())).thenAnswer((_) async => right(unit));
        return buildCubit()..setTarget(1);
      },
      act: (cubit) async {
        await cubit.increment(); // completed
        cubit.reset();
      },
      verify: (cubit) {
        expect(cubit.state.count, 0);
        expect(cubit.state.isCompleted, false);
      },
    );
  });

  group('TasbihCubit — selectPreset', () {
    blocTest<TasbihCubit, TasbihState>(
      'selectPreset() mengganti preset dan reset counter',
      build: buildCubit,
      act: (cubit) {
        cubit.selectPreset(TasbihPreset.defaults[1]); // Alhamdulillah
      },
      verify: (cubit) {
        expect(cubit.state.selectedPreset, TasbihPreset.defaults[1]);
        expect(cubit.state.count, 0);
        expect(cubit.state.target, TasbihPreset.defaults[1].defaultTarget);
      },
    );
  });

  group('TasbihCubit — setTarget', () {
    blocTest<TasbihCubit, TasbihState>(
      'setTarget() mengubah target dan reset counter',
      build: buildCubit,
      act: (cubit) => cubit.setTarget(200),
      verify: (cubit) {
        expect(cubit.state.target, 200);
        expect(cubit.state.count, 0);
      },
    );

    blocTest<TasbihCubit, TasbihState>(
      'setTarget() diabaikan jika nilai <= 0',
      build: buildCubit,
      act: (cubit) => cubit.setTarget(0),
      verify: (cubit) {
        expect(cubit.state.target, initialPreset.defaultTarget);
      },
    );
  });

  group('TasbihCubit — toggleHaptic', () {
    blocTest<TasbihCubit, TasbihState>(
      'toggleHaptic() membalik nilai hapticEnabled',
      build: buildCubit,
      act: (cubit) => cubit.toggleHaptic(),
      verify: (cubit) {
        expect(cubit.state.hapticEnabled, false);
      },
    );

    blocTest<TasbihCubit, TasbihState>(
      'toggleHaptic() dua kali mengembalikan ke nilai awal',
      build: buildCubit,
      act: (cubit) => cubit
        ..toggleHaptic()
        ..toggleHaptic(),
      verify: (cubit) {
        expect(cubit.state.hapticEnabled, true);
      },
    );
  });

  group('TasbihCubit — loadSessions', () {
    blocTest<TasbihCubit, TasbihState>(
      'loadSessions() mengisi state.sessions dari repository',
      build: () {
        when(
          () => mockGetSessions(),
        ).thenAnswer((_) async => right([tSession, tSession2]));
        return buildCubit();
      },
      act: (cubit) => cubit.loadSessions(),
      verify: (cubit) {
        expect(cubit.state.sessions, [tSession, tSession2]);
        expect(cubit.state.errorMessage, isNull);
      },
    );

    blocTest<TasbihCubit, TasbihState>(
      'loadSessions() set errorMessage jika repository gagal',
      build: () {
        when(() => mockGetSessions()).thenAnswer(
          (_) async => left(const Failure.unknown(message: 'db error')),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.loadSessions(),
      verify: (cubit) {
        expect(cubit.state.errorMessage, isNotNull);
      },
    );
  });

  group('TasbihCubit — deleteSession', () {
    blocTest<TasbihCubit, TasbihState>(
      'deleteSession() memanggil usecase dan reload sessions',
      build: () {
        when(
          () => mockDeleteSession(any()),
        ).thenAnswer((_) async => right(unit));
        when(
          () => mockGetSessions(),
        ).thenAnswer((_) async => right([tSession2]));
        return buildCubit();
      },
      act: (cubit) => cubit.deleteSession(tSession.id),
      verify: (cubit) {
        verify(() => mockDeleteSession(tSession.id)).called(1);
        expect(cubit.state.sessions, [tSession2]);
      },
    );
  });

  group('TasbihCubit — clearAllSessions', () {
    blocTest<TasbihCubit, TasbihState>(
      'clearAllSessions() mengosongkan state.sessions',
      build: () {
        when(() => mockClearSessions()).thenAnswer((_) async => right(unit));
        return buildCubit();
      },
      act: (cubit) => cubit.clearAllSessions(),
      verify: (cubit) {
        expect(cubit.state.sessions, isEmpty);
        expect(cubit.state.errorMessage, isNull);
      },
    );
  });

  group('TasbihState — extension', () {
    test('progress mengembalikan 0.0 saat count = 0', () {
      final cubit = buildCubit();
      expect(cubit.state.progress, 0.0);
    });

    test('progress mengembalikan 1.0 saat count = target', () {
      final cubit = buildCubit();
      final state = cubit.state.copyWith(count: 1, target: 1);
      expect(state.progress, 1.0);
    });

    test('remaining mengembalikan selisih target - count', () {
      final cubit = buildCubit();
      final state = cubit.state.copyWith(count: 10, target: 33);
      expect(state.remaining, 23);
    });

    test('remaining tidak pernah negatif', () {
      final cubit = buildCubit();
      final state = cubit.state.copyWith(count: 50, target: 33);
      expect(state.remaining, 0);
    });
  });
}
