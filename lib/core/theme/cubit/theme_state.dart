part of 'theme_cubit.dart';

@freezed
sealed class ThemeState with _$ThemeState {
  const factory ThemeState.light() = ThemeLight;
  const factory ThemeState.dark() = ThemeDark;
  const factory ThemeState.error(String message) = ThemeError;
}

extension ThemeStateX on ThemeState {
  ThemeMode get themeMode => switch (this) {
    ThemeLight() => ThemeMode.light,
    ThemeDark() => ThemeMode.dark,
    ThemeError() => ThemeMode.light,
  };

  bool get isLight => this is ThemeLight;
  bool get isDark => this is ThemeDark;
}
