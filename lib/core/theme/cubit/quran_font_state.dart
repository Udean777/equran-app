part of 'quran_font_cubit.dart';

/// Konstanta nama font Arab yang tersedia.
const String kFontAmiri = 'Amiri';
const String kFontKFGQPC = 'KFGQPC';

/// State preferensi font Al-Quran.
///
/// Menyimpan ukuran font Arab, ukuran font terjemahan,
/// dan jenis font Arab yang dipilih user.
@freezed
sealed class QuranFontState with _$QuranFontState {
  const factory QuranFontState({
    /// Ukuran font teks Arab. Range: 18–40.
    @Default(28.0) double arabicFontSize,

    /// Ukuran font teks terjemahan & latin. Range: 12–22.
    @Default(14.0) double translationFontSize,

    /// Nama font Arab yang aktif. Salah satu dari [kFontAmiri] atau [kFontKFGQPC].
    @Default(kFontAmiri) String arabicFontFamily,
  }) = _QuranFontState;
}
