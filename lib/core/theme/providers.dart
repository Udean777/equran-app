import 'package:equran_app/core/providers.dart';
import 'package:equran_app/core/theme/viewmodels/quran_font_state.dart';
import 'package:equran_app/core/theme/viewmodels/quran_font_viewmodel.dart';
import 'package:equran_app/core/theme/viewmodels/theme_state.dart';
import 'package:equran_app/core/theme/viewmodels/theme_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/quran_font_state.dart';
export 'viewmodels/theme_state.dart';

final StateNotifierProvider<ThemeViewModel, ThemeState> themeViewModelProvider =
    StateNotifierProvider<ThemeViewModel, ThemeState>(
      (ref) => ThemeViewModel(ref.watch(settingsBoxProvider)),
    );

final StateNotifierProvider<QuranFontViewModel, QuranFontState>
quranFontViewModelProvider =
    StateNotifierProvider<QuranFontViewModel, QuranFontState>(
      (ref) => QuranFontViewModel(ref.watch(settingsBoxProvider)),
    );
