import 'package:freezed_annotation/freezed_annotation.dart';

part 'quran_font_state.freezed.dart';

/// Konstanta nama font Arab yang tersedia.
const String kFontAmiri = 'Amiri';
const String kFontKFGQPC = 'KFGQPC';

@freezed
sealed class QuranFontState with _$QuranFontState {
  const factory QuranFontState({
    @Default(28.0) double arabicFontSize,
    @Default(14.0) double translationFontSize,
    @Default(kFontAmiri) String arabicFontFamily,
    String? errorMessage,
  }) = _QuranFontState;
}
