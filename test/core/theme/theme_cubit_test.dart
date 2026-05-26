import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<String> {}

void main() {
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
  });

  group('ThemeCubit', () {
    // ── initial state ────────────────────────────────────────────────────────
    test('initial state adalah light', () {
      when(() => mockBox.get(any<dynamic>())).thenReturn(null);
      final cubit = ThemeCubit(mockBox);
      expect(cubit.state, const ThemeState.light());
    });

    // ── load() ───────────────────────────────────────────────────────────────
    blocTest<ThemeCubit, ThemeState>(
      'load() emit dark jika tersimpan dark di Hive',
      build: () {
        when(() => mockBox.get('theme_mode')).thenReturn('dark');
        return ThemeCubit(mockBox);
      },
      act: (cubit) => cubit.load(),
      expect: () => [const ThemeState.dark()],
    );

    blocTest<ThemeCubit, ThemeState>(
      'load() emit light jika tersimpan light di Hive',
      build: () {
        when(() => mockBox.get('theme_mode')).thenReturn('light');
        return ThemeCubit(mockBox);
      },
      act: (cubit) => cubit.load(),
      expect: () => [const ThemeState.light()],
    );

    blocTest<ThemeCubit, ThemeState>(
      'load() emit sepia jika tersimpan sepia di Hive',
      build: () {
        when(() => mockBox.get('theme_mode')).thenReturn('sepia');
        return ThemeCubit(mockBox);
      },
      act: (cubit) => cubit.load(),
      expect: () => [const ThemeState.sepia()],
    );

    blocTest<ThemeCubit, ThemeState>(
      'load() emit light jika tidak ada data di Hive',
      build: () {
        when(() => mockBox.get('theme_mode')).thenReturn(null);
        return ThemeCubit(mockBox);
      },
      act: (cubit) => cubit.load(),
      expect: () => [const ThemeState.light()],
    );

    // ── cycle() ──────────────────────────────────────────────────────────────
    blocTest<ThemeCubit, ThemeState>(
      'cycle() dari light emit dark dan simpan ke Hive',
      build: () {
        when(() => mockBox.get('theme_mode')).thenReturn(null);
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((_) async {});
        return ThemeCubit(mockBox);
      },
      act: (cubit) async {
        cubit.load();
        await cubit.cycle();
      },
      expect: () => [
        const ThemeState.light(),
        const ThemeState.dark(),
      ],
      verify: (_) {
        verify(() => mockBox.put('theme_mode', 'dark')).called(1);
      },
    );

    blocTest<ThemeCubit, ThemeState>(
      'cycle() dari dark emit sepia dan simpan ke Hive',
      build: () {
        when(() => mockBox.get('theme_mode')).thenReturn('dark');
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((_) async {});
        return ThemeCubit(mockBox);
      },
      act: (cubit) async {
        cubit.load();
        await cubit.cycle();
      },
      expect: () => [
        const ThemeState.dark(),
        const ThemeState.sepia(),
      ],
      verify: (_) {
        verify(() => mockBox.put('theme_mode', 'sepia')).called(1);
      },
    );

    blocTest<ThemeCubit, ThemeState>(
      'cycle() dari sepia emit light dan simpan ke Hive',
      build: () {
        when(() => mockBox.get('theme_mode')).thenReturn('sepia');
        when(
          () => mockBox.put(any<String>(), any<String>()),
        ).thenAnswer((_) async {});
        return ThemeCubit(mockBox);
      },
      act: (cubit) async {
        cubit.load();
        await cubit.cycle();
      },
      expect: () => [
        const ThemeState.sepia(),
        const ThemeState.light(),
      ],
      verify: (_) {
        verify(() => mockBox.put('theme_mode', 'light')).called(1);
      },
    );

    // ── ThemeStateX ──────────────────────────────────────────────────────────
    test('themeMode return ThemeMode.light untuk light state', () {
      const state = ThemeState.light();
      expect(state.themeMode, ThemeMode.light);
    });

    test('themeMode return ThemeMode.dark untuk dark state', () {
      const state = ThemeState.dark();
      expect(state.themeMode, ThemeMode.dark);
    });

    test('themeMode return ThemeMode.light untuk sepia state', () {
      const state = ThemeState.sepia();
      expect(state.themeMode, ThemeMode.light);
    });

    test('isLight return true untuk light state', () {
      const state = ThemeState.light();
      expect(state.isLight, isTrue);
    });

    test('isLight return false untuk dark state', () {
      const state = ThemeState.dark();
      expect(state.isLight, isFalse);
    });

    test('isLight return false untuk sepia state', () {
      const state = ThemeState.sepia();
      expect(state.isLight, isFalse);
    });

    test('isDark return false untuk light state', () {
      const state = ThemeState.light();
      expect(state.isDark, isFalse);
    });

    test('isDark return true untuk dark state', () {
      const state = ThemeState.dark();
      expect(state.isDark, isTrue);
    });

    test('isDark return false untuk sepia state', () {
      const state = ThemeState.sepia();
      expect(state.isDark, isFalse);
    });

    test('isSepia return false untuk light state', () {
      const state = ThemeState.light();
      expect(state.isSepia, isFalse);
    });

    test('isSepia return false untuk dark state', () {
      const state = ThemeState.dark();
      expect(state.isSepia, isFalse);
    });

    test('isSepia return true untuk sepia state', () {
      const state = ThemeState.sepia();
      expect(state.isSepia, isTrue);
    });
  });
}
