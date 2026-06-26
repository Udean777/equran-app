import 'package:equran_app/core/providers.dart';
import 'package:equran_app/core/theme/viewmodels/quran_font_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

const _arabicSizeKey = 'arabic_font_size';
const _translationSizeKey = 'translation_font_size';
const _arabicFamilyKey = 'arabic_font_family';

class QuranFontViewModel extends Notifier<QuranFontState> {
  Box<String> get _box => ref.read(settingsBoxProvider);

  @override
  QuranFontState build() => const QuranFontState();

  void load() {
    final arabicSize = double.tryParse(_box.get(_arabicSizeKey) ?? '') ?? 28.0;
    final translationSize =
        double.tryParse(_box.get(_translationSizeKey) ?? '') ?? 14.0;
    final family = _box.get(_arabicFamilyKey) ?? kFontAmiri;

    state = QuranFontState(
      arabicFontSize: arabicSize.clamp(18.0, 40.0),
      translationFontSize: translationSize.clamp(12.0, 22.0),
      arabicFontFamily: family == kFontKFGQPC ? kFontKFGQPC : kFontAmiri,
    );
  }

  Future<void> setArabicFontSize(double size) async {
    try {
      final clamped = size.clamp(18.0, 40.0);
      state = state.copyWith(arabicFontSize: clamped, errorMessage: null);
      await _box.put(_arabicSizeKey, clamped.toString());
    } on Object catch (e) {
      state = state.copyWith(errorMessage: 'Gagal menyimpan ukuran font: $e');
    }
  }

  Future<void> setTranslationFontSize(double size) async {
    try {
      final clamped = size.clamp(12.0, 22.0);
      state = state.copyWith(translationFontSize: clamped, errorMessage: null);
      await _box.put(_translationSizeKey, clamped.toString());
    } on Object catch (e) {
      state = state.copyWith(
        errorMessage: 'Gagal menyimpan ukuran font terjemahan: $e',
      );
    }
  }

  Future<void> setArabicFontFamily(String family) async {
    try {
      final valid = family == kFontKFGQPC ? kFontKFGQPC : kFontAmiri;
      state = state.copyWith(arabicFontFamily: valid, errorMessage: null);
      await _box.put(_arabicFamilyKey, valid);
    } on Object catch (e) {
      state = state.copyWith(errorMessage: 'Gagal menyimpan font Arab: $e');
    }
  }

  Future<void> reset() async {
    try {
      await _box.deleteAll([
        _arabicSizeKey,
        _translationSizeKey,
        _arabicFamilyKey,
      ]);
      state = const QuranFontState();
    } on Object catch (e) {
      state = state.copyWith(errorMessage: 'Gagal mereset pengaturan font: $e');
    }
  }
}
