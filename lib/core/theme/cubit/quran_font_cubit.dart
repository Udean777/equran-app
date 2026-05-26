import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'quran_font_state.dart';
part 'quran_font_cubit.freezed.dart';

const _arabicSizeKey = 'arabic_font_size';
const _translationSizeKey = 'translation_font_size';
const _arabicFamilyKey = 'arabic_font_family';

@singleton
class QuranFontCubit extends Cubit<QuranFontState> {
  QuranFontCubit(@Named('settingsBox') this._box)
    : super(const QuranFontState());

  final Box<String> _box;

  /// Load preferensi font dari Hive.
  void load() {
    final arabicSize = double.tryParse(_box.get(_arabicSizeKey) ?? '') ?? 28.0;
    final translationSize =
        double.tryParse(_box.get(_translationSizeKey) ?? '') ?? 14.0;
    final family = _box.get(_arabicFamilyKey) ?? kFontAmiri;

    emit(
      QuranFontState(
        arabicFontSize: arabicSize.clamp(18.0, 40.0),
        translationFontSize: translationSize.clamp(12.0, 22.0),
        arabicFontFamily: family == kFontKFGQPC ? kFontKFGQPC : kFontAmiri,
      ),
    );
  }

  /// Update ukuran font Arab dan simpan ke Hive.
  Future<void> setArabicFontSize(double size) async {
    final clamped = size.clamp(18.0, 40.0);
    emit(state.copyWith(arabicFontSize: clamped));
    await _box.put(_arabicSizeKey, clamped.toString());
  }

  /// Update ukuran font terjemahan dan simpan ke Hive.
  Future<void> setTranslationFontSize(double size) async {
    final clamped = size.clamp(12.0, 22.0);
    emit(state.copyWith(translationFontSize: clamped));
    await _box.put(_translationSizeKey, clamped.toString());
  }

  /// Update jenis font Arab dan simpan ke Hive.
  Future<void> setArabicFontFamily(String family) async {
    final valid = family == kFontKFGQPC ? kFontKFGQPC : kFontAmiri;
    emit(state.copyWith(arabicFontFamily: valid));
    await _box.put(_arabicFamilyKey, valid);
  }
}
