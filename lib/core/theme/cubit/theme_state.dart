part of 'theme_cubit.dart';

@freezed
sealed class ThemeState with _$ThemeState {
  const factory ThemeState.light() = ThemeLight;
  const factory ThemeState.dark() = ThemeDark;
}

extension ThemeStateX on ThemeState {
  ThemeMode get themeMode => switch (this) {
    ThemeLight() => ThemeMode.light,
    ThemeDark() => ThemeMode.dark,
  };

  bool get isDark => this is ThemeDark;
}
