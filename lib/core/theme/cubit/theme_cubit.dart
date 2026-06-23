import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'theme_state.dart';
part 'theme_cubit.freezed.dart';

const _themeKey = 'theme_mode';
const _darkValue = 'dark';
const _lightValue = 'light';

/// Cubit untuk manage tema aplikasi (light / dark mode).
///
/// State tersimpan di Hive [Box<String>] dengan key `theme_mode`.
/// Mendukung tiga state: [ThemeLight], [ThemeDark], dan [ThemeError]
/// (jika operasi Hive gagal).
@singleton
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(@Named('settingsBox') this._box) : super(const ThemeState.light());

  final Box<String> _box;

  /// Load saved theme preference dari Hive.
  void load() {
    final saved = _box.get(_themeKey);
    if (saved == _darkValue) {
      emit(const ThemeState.dark());
    } else {
      emit(const ThemeState.light());
    }
  }

  /// Toggle tema: light ↔ dark, simpan ke Hive.
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
      emit(next);
    } on Object catch (e) {
      emit(ThemeState.error('Gagal menyimpan tema: $e'));
    }
  }

  /// Reset tema ke default (light) dan hapus preferensi dari Hive.
  Future<void> reset() async {
    try {
      await _box.delete(_themeKey);
      emit(const ThemeState.light());
    } on Object catch (e) {
      emit(ThemeState.error('Gagal mereset tema: $e'));
    }
  }
}
