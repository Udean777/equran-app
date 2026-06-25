import 'package:equran_app/core/locale/viewmodels/language_state.dart';
import 'package:equran_app/core/locale/viewmodels/language_viewmodel.dart';
import 'package:equran_app/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/language_state.dart';

final StateNotifierProvider<LanguageViewModel, LanguageState>
languageViewModelProvider =
    StateNotifierProvider<LanguageViewModel, LanguageState>(
      (ref) => LanguageViewModel(ref.watch(settingsBoxProvider)),
    );
