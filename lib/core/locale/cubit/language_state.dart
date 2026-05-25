part of 'language_cubit.dart';

@freezed
sealed class LanguageState with _$LanguageState {
  const factory LanguageState.id() = LanguageId;
  const factory LanguageState.en() = LanguageEn;
  const factory LanguageState.ar() = LanguageAr;
}

extension LanguageStateX on LanguageState {
  Locale get locale => switch (this) {
    LanguageId() => const Locale('id'),
    LanguageEn() => const Locale('en'),
    LanguageAr() => const Locale('ar'),
  };

  String get label => switch (this) {
    LanguageId() => 'Indonesia',
    LanguageEn() => 'English',
    LanguageAr() => 'العربية',
  };

  bool get isRtl => this is LanguageAr;
}
