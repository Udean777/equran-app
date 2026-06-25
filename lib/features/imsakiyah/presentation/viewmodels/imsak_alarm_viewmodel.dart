import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:equran_app/features/imsakiyah/domain/services/imsak_alarm_scheduler.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/save_imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/presentation/viewmodels/imsak_alarm_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImsakAlarmViewModel extends StateNotifier<ImsakAlarmState> {
  ImsakAlarmViewModel(
    this._getPrefs,
    this._savePrefs,
    this._scheduler,
  ) : super(const ImsakAlarmState.initial());

  final GetImsakAlarmPrefs _getPrefs;
  final SaveImsakAlarmPrefs _savePrefs;
  final ImsakAlarmScheduler _scheduler;

  Future<void> load() async {
    final result = await _getPrefs();
    result.fold(
      (_) => state = const ImsakAlarmState.loaded(prefs: ImsakAlarmPrefs()),
      (prefs) => state = ImsakAlarmState.loaded(prefs: prefs),
    );
  }

  Future<void> toggleImsak({ImsakiyahEntry? entry}) async {
    final current = _currentPrefs;
    if (current == null) return;

    final updated = current.copyWith(imsakEnabled: !current.imsakEnabled);
    await _persist(updated, entry);
  }

  Future<void> toggleSahur({ImsakiyahEntry? entry}) async {
    final current = _currentPrefs;
    if (current == null) return;

    final updated = current.copyWith(sahurEnabled: !current.sahurEnabled);
    await _persist(updated, entry);
  }

  Future<void> setMenitSebelum(int menit, {ImsakiyahEntry? entry}) async {
    final current = _currentPrefs;
    if (current == null) return;

    final updated = current.copyWith(menitSebelumImsak: menit);
    await _persist(updated, entry);
  }

  static ImsakiyahEntry? todayEntry(Imsakiyah jadwal) {
    final today = DateTime.now().day;
    final list = jadwal.imsakiyah;
    for (final entry in list) {
      if (entry.tanggal == today) return entry;
    }
    return null;
  }

  ImsakAlarmPrefs? get _currentPrefs {
    final s = state;
    return s is ImsakAlarmLoaded ? s.prefs : null;
  }

  Future<void> _persist(ImsakAlarmPrefs prefs, ImsakiyahEntry? entry) async {
    await _savePrefs(prefs);
    state = ImsakAlarmState.loaded(prefs: prefs);

    if (entry != null) {
      try {
        await _scheduler.scheduleForToday(entry, prefs);
      } on Object catch (e) {
        debugPrint('ImsakAlarmViewModel: schedule error: $e');
      }
    } else {
      await _scheduler.cancelAll();
    }
  }
}
