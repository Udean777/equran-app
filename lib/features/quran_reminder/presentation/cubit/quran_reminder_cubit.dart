import 'dart:async';

import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/get_quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/save_quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/notifications/quran_reminder_scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class QuranReminderCubit extends Cubit<QuranReminderPrefs> {
  QuranReminderCubit(
    this._getPrefs,
    this._savePrefs,
    this._scheduler,
  ) : super(const QuranReminderPrefs());

  final GetQuranReminderPrefs _getPrefs;
  final SaveQuranReminderPrefs _savePrefs;
  final QuranReminderScheduler _scheduler;

  /// Load preferensi dari Hive dan apply scheduler.
  void load() {
    unawaited(
      _getPrefs().then((result) {
        if (isClosed) return;
        result.fold(
          (_) => emit(const QuranReminderPrefs()),
          (prefs) {
            emit(prefs);
            unawaited(_scheduler.apply(prefs));
          },
        );
      }),
    );
  }

  /// Toggle aktif/nonaktif reminder.
  Future<void> toggleEnabled() =>
      _update(state.copyWith(enabled: !state.enabled));

  /// Update jam reminder.
  Future<void> setTime({required int hour, required int minute}) =>
      _update(state.copyWith(hour: hour, minute: minute));

  Future<void> _update(QuranReminderPrefs prefs) async {
    emit(prefs);
    await _savePrefs(prefs);
    await _scheduler.apply(prefs);
  }
}
