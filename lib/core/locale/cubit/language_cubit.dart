import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'language_state.dart';
part 'language_cubit.freezed.dart';

const _languageKey = 'locale';

@singleton
class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit(@Named('settingsBox') this._box)
    : super(const LanguageState.id());

  final Box<String> _box;

  void load() {
    final saved = _box.get(_languageKey);
    emit(switch (saved) {
      'en' => const LanguageState.en(),
      'ar' => const LanguageState.ar(),
      _ => const LanguageState.id(),
    });
  }

  Future<void> changeLanguage(LanguageState language) async {
    final code = switch (language) {
      LanguageId() => 'id',
      LanguageEn() => 'en',
      LanguageAr() => 'ar',
    };
    await _box.put(_languageKey, code);
    emit(language);
  }
}
