import 'dart:async';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/quran_reminder/data/services/quran_reminder_scheduler.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/get_quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/save_quran_reminder_prefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'quran_reminder_cubit.freezed.dart';
part 'quran_reminder_state.dart';

@singleton
class QuranReminderCubit extends Cubit<QuranReminderState> {
  QuranReminderCubit(
    this._getPrefs,
    this._savePrefs,
    this._scheduler,
  ) : super(const QuranReminderState.initial());

  final GetQuranReminderPrefs _getPrefs;
  final SaveQuranReminderPrefs _savePrefs;
  final QuranReminderScheduler _scheduler;

  /// Load preferensi dari Hive dan apply scheduler.
  void load() {
    unawaited(
      _getPrefs().then((result) {
        if (isClosed) return;
        result.fold(
          (failure) => emit(QuranReminderState.error(failure)),
          (prefs) {
            emit(QuranReminderState.loaded(prefs));
            unawaited(_scheduler.apply(prefs));
          },
        );
      }),
    );
  }

  /// Toggle aktif/nonaktif reminder.
  Future<void> toggleEnabled() async {
    final prefs = state.mapOrNull(loaded: (s) => s.prefs);
    if (prefs != null) await _update(prefs.copyWith(enabled: !prefs.enabled));
  }

  /// Update jam reminder.
  Future<void> setTime({required int hour, required int minute}) async {
    final prefs = state.mapOrNull(loaded: (s) => s.prefs);
    if (prefs != null) {
      await _update(prefs.copyWith(hour: hour, minute: minute));
    }
  }

  Future<void> _update(QuranReminderPrefs prefs) async {
    emit(QuranReminderState.loaded(prefs));
    await _savePrefs(prefs);
    await _scheduler.apply(prefs);
  }
}
