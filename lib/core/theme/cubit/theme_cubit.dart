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

@singleton
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(@Named('settingsBox') this._box) : super(const ThemeState.light());

  final Box<dynamic> _box;

  /// Load saved theme preference dari Hive.
  void load() {
    final saved = _box.get(_themeKey) as String?;
    if (saved == _darkValue) {
      emit(const ThemeState.dark());
    } else {
      emit(const ThemeState.light());
    }
  }

  /// Toggle antara light dan dark, simpan ke Hive.
  Future<void> toggle() async {
    final next = state.isDark
        ? const ThemeState.light()
        : const ThemeState.dark();
    await _box.put(_themeKey, next.isDark ? _darkValue : _lightValue);
    emit(next);
  }
}
