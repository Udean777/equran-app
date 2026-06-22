import 'package:flutter/material.dart';

extension BuildContextThemeExt on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;
}
