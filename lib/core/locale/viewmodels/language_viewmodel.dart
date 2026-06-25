import 'package:equran_app/core/locale/viewmodels/language_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

const _languageKey = 'locale';

class LanguageViewModel extends StateNotifier<LanguageState> {
  LanguageViewModel(this._box) : super(const LanguageState.id());

  final Box<String> _box;

  void load() {
    final saved = _box.get(_languageKey);
    state = switch (saved) {
      'en' => const LanguageState.en(),
      'ar' => const LanguageState.ar(),
      _ => const LanguageState.id(),
    };
  }

  Future<void> changeLanguage(LanguageState language) async {
    try {
      if (language is LanguageError) return;

      final code = switch (language) {
        LanguageId() => 'id',
        LanguageEn() => 'en',
        LanguageAr() => 'ar',
        LanguageError() => 'id',
      };
      await _box.put(_languageKey, code);
      state = language;
    } on Object catch (e) {
      state = LanguageState.error('Gagal mengubah bahasa: $e');
    }
  }

  Future<void> reset() async {
    try {
      await _box.delete(_languageKey);
      state = const LanguageState.id();
    } on Object catch (e) {
      state = LanguageState.error('Gagal mereset bahasa: $e');
    }
  }
}
