import 'package:equran_app/core/theme/viewmodels/quran_font_state.dart';
import 'package:equran_app/core/theme/viewmodels/quran_font_viewmodel.dart';
import 'package:equran_app/core/theme/viewmodels/theme_state.dart';
import 'package:equran_app/core/theme/viewmodels/theme_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/quran_font_state.dart';
export 'viewmodels/theme_state.dart';

final NotifierProvider<ThemeViewModel, ThemeState> themeViewModelProvider =
    NotifierProvider<ThemeViewModel, ThemeState>(
      ThemeViewModel.new,
    );

final NotifierProvider<QuranFontViewModel, QuranFontState>
quranFontViewModelProvider =
    NotifierProvider<QuranFontViewModel, QuranFontState>(
      QuranFontViewModel.new,
    );
