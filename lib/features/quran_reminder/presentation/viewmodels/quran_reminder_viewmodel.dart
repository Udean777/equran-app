import 'dart:async';

import 'package:equran_app/features/quran_reminder/data/services/quran_reminder_scheduler.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/get_quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/domain/usecases/save_quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuranReminderViewModel extends Notifier<QuranReminderState> {
  @override
  QuranReminderState build() => const QuranReminderState.initial();

  GetQuranReminderPrefs get _getPrefs => ref.read(getQuranReminderPrefsProvider);
  SaveQuranReminderPrefs get _savePrefs => ref.read(saveQuranReminderPrefsProvider);
  QuranReminderScheduler get _scheduler => ref.read(quranReminderSchedulerProvider);

  void load() {
    unawaited(
      _getPrefs().then((result) {
        result.fold(
          (failure) => state = QuranReminderState.error(failure),
          (prefs) {
            state = QuranReminderState.loaded(prefs);
            unawaited(_scheduler.apply(prefs));
          },
        );
      }),
    );
  }

  Future<void> toggleEnabled() async {
    final prefs = state.mapOrNull(loaded: (s) => s.prefs);
    if (prefs != null) await _update(prefs.copyWith(enabled: !prefs.enabled));
  }

  Future<void> setTime({required int hour, required int minute}) async {
    final prefs = state.mapOrNull(loaded: (s) => s.prefs);
    if (prefs != null) {
      await _update(prefs.copyWith(hour: hour, minute: minute));
    }
  }

  Future<void> _update(QuranReminderPrefs prefs) async {
    state = QuranReminderState.loaded(prefs);
    await _savePrefs(prefs);
    await _scheduler.apply(prefs);
  }
}
