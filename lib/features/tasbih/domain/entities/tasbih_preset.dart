import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasbih_preset.freezed.dart';

@freezed
abstract class TasbihPreset with _$TasbihPreset {
  const factory TasbihPreset({
    required String id,
    required String name,
    required String arabic,
    required int defaultTarget,
  }) = _TasbihPreset;

  /// Preset dzikir bawaan — hardcoded, tidak butuh API.
  static const List<TasbihPreset> defaults = [
    TasbihPreset(
      id: 'subhanallah',
      name: 'Subhanallah',
      arabic: 'سُبْحَانَ اللّٰهِ',
      defaultTarget: 33,
    ),
    TasbihPreset(
      id: 'alhamdulillah',
      name: 'Alhamdulillah',
      arabic: 'اَلْحَمْدُ لِلّٰهِ',
      defaultTarget: 33,
    ),
    TasbihPreset(
      id: 'allahuakbar',
      name: 'Allahu Akbar',
      arabic: 'اَللّٰهُ أَكْبَرُ',
      defaultTarget: 33,
    ),
    TasbihPreset(
      id: 'astaghfirullah',
      name: 'Astaghfirullah',
      arabic: 'أَسْتَغْفِرُ اللّٰهَ',
      defaultTarget: 100,
    ),
    TasbihPreset(
      id: 'lailahaillallah',
      name: 'La ilaha illallah',
      arabic: 'لَا إِلٰهَ إِلَّا اللّٰهُ',
      defaultTarget: 100,
    ),
  ];
}
