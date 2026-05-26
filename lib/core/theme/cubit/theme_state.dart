part of 'theme_cubit.dart';

@freezed
sealed class ThemeState with _$ThemeState {
  const factory ThemeState.light() = ThemeLight;
  const factory ThemeState.dark() = ThemeDark;
  const factory ThemeState.sepia() = ThemeSepia;
}

extension ThemeStateX on ThemeState {
  ThemeMode get themeMode => switch (this) {
    ThemeLight() => ThemeMode.light,
    ThemeDark() => ThemeMode.dark,
    ThemeSepia() => ThemeMode.light, // sepia pakai ThemeMode.light, theme-nya di-swap di app.dart
  };

  bool get isLight => this is ThemeLight;
  bool get isDark => this is ThemeDark;
  bool get isSepia => this is ThemeSepia;
}
