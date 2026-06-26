import 'package:equran_app/core/providers.dart';
import 'package:equran_app/core/theme/viewmodels/theme_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

const _themeKey = 'theme_mode';
const _darkValue = 'dark';
const _lightValue = 'light';

class ThemeViewModel extends Notifier<ThemeState> {
  Box<String> get _box => ref.read(settingsBoxProvider);

  @override
  ThemeState build() => const ThemeState.light();

  void load() {
    final saved = _box.get(_themeKey);
    if (saved == _darkValue) {
      state = const ThemeState.dark();
    } else {
      state = const ThemeState.light();
    }
  }

  Future<void> cycle() async {
    try {
      final next = switch (state) {
        ThemeLight() => const ThemeState.dark(),
        ThemeDark() => const ThemeState.light(),
        ThemeError() => const ThemeState.light(),
      };
      final value = switch (next) {
        ThemeLight() => _lightValue,
        ThemeDark() => _darkValue,
        ThemeError() => _lightValue,
      };
      await _box.put(_themeKey, value);
      state = next;
    } on Object catch (e) {
      state = ThemeState.error('Gagal menyimpan tema: $e');
    }
  }

  Future<void> reset() async {
    try {
      await _box.delete(_themeKey);
      state = const ThemeState.light();
    } on Object catch (e) {
      state = ThemeState.error('Gagal mereset tema: $e');
    }
  }
}
