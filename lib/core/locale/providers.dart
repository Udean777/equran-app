import 'package:equran_app/core/locale/viewmodels/language_state.dart';
import 'package:equran_app/core/locale/viewmodels/language_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/language_state.dart';

final NotifierProvider<LanguageViewModel, LanguageState>
languageViewModelProvider = NotifierProvider<LanguageViewModel, LanguageState>(
  LanguageViewModel.new,
);
