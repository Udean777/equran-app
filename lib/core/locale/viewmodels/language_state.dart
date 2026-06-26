import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'language_state.freezed.dart';

@freezed
sealed class LanguageState with _$LanguageState {
  const factory LanguageState.id() = LanguageId;
  const factory LanguageState.en() = LanguageEn;
  const factory LanguageState.ar() = LanguageAr;
  const factory LanguageState.error(String message) = LanguageError;
}

extension LanguageStateX on LanguageState {
  Locale get locale => switch (this) {
    LanguageId() => const Locale('id'),
    LanguageEn() => const Locale('en'),
    LanguageAr() => const Locale('ar'),
    LanguageError() => const Locale('id'),
  };

  String get label => switch (this) {
    LanguageId() => 'Indonesia',
    LanguageEn() => 'English',
    LanguageAr() => 'العربية',
    LanguageError() => 'Indonesia',
  };

  bool get isRtl => this is LanguageAr;
}
