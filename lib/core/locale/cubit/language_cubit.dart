import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'language_state.dart';
part 'language_cubit.freezed.dart';

const _languageKey = 'locale';

/// Cubit untuk manage bahasa aplikasi (Bahasa Indonesia, English, Arabic).
///
/// State tersimpan di Hive [Box<String>] dengan key `locale`.
/// Mendukung empat state: [LanguageId], [LanguageEn], [LanguageAr],
/// dan [LanguageError] (jika operasi Hive gagal).
@singleton
class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit(@Named('settingsBox') this._box)
    : super(const LanguageState.id());

  final Box<String> _box;

  void load() {
    final saved = _box.get(_languageKey);
    emit(switch (saved) {
      'en' => const LanguageState.en(),
      'ar' => const LanguageState.ar(),
      _ => const LanguageState.id(),
    });
  }

  /// Mengubah bahasa aktif dan menyimpan ke Hive.
  ///
  /// Jika [language] adalah [LanguageError], operasi dibatalkan.
  /// Jika Hive gagal, emit [LanguageError] dengan pesan error.
  Future<void> changeLanguage(LanguageState language) async {
    try {
      if (language is LanguageError) return;

      final code = switch (language) {
        LanguageId() => 'id',
        LanguageEn() => 'en',
        LanguageAr() => 'ar',
        LanguageError() => 'id',
      };
      await _box.put(_languageKey, code);
      emit(language);
    } on Object catch (e) {
      emit(LanguageState.error('Gagal mengubah bahasa: $e'));
    }
  }

  /// Reset bahasa ke default (Indonesia) dan hapus preferensi dari Hive.
  Future<void> reset() async {
    try {
      await _box.delete(_languageKey);
      emit(const LanguageState.id());
    } on Object catch (e) {
      emit(LanguageState.error('Gagal mereset bahasa: $e'));
    }
  }
}
