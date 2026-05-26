import 'package:equran_app/core/notifications/imsak_alarm_config.dart';
import 'package:equran_app/core/notifications/imsak_alarm_scheduler.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/save_imsak_alarm_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'imsak_alarm_cubit.freezed.dart';
part 'imsak_alarm_state.dart';

@injectable
class ImsakAlarmCubit extends Cubit<ImsakAlarmState> {
  ImsakAlarmCubit(
    this._getPrefs,
    this._savePrefs,
    this._scheduler,
  ) : super(const ImsakAlarmState.initial());

  final GetImsakAlarmPrefs _getPrefs;
  final SaveImsakAlarmPrefs _savePrefs;
  final ImsakAlarmScheduler _scheduler;

  /// Load preferensi alarm dari Hive.
  Future<void> load() async {
    final prefs = await _getPrefs();
    emit(ImsakAlarmState.loaded(prefs: prefs));
  }

  /// Toggle alarm imsak on/off, lalu reschedule jika [entry] tersedia.
  Future<void> toggleImsak({ImsakiyahEntry? entry}) async {
    final current = _currentPrefs;
    if (current == null) return;

    final updated = current.copyWith(imsakEnabled: !current.imsakEnabled);
    await _persist(updated, entry);
  }

  /// Toggle alarm sahur on/off, lalu reschedule jika [entry] tersedia.
  Future<void> toggleSahur({ImsakiyahEntry? entry}) async {
    final current = _currentPrefs;
    if (current == null) return;

    final updated = current.copyWith(sahurEnabled: !current.sahurEnabled);
    await _persist(updated, entry);
  }

  /// Set menit sebelum imsak untuk alarm sahur, lalu reschedule.
  Future<void> setMenitSebelum(int menit, {ImsakiyahEntry? entry}) async {
    final current = _currentPrefs;
    if (current == null) return;

    final updated = current.copyWith(menitSebelumImsak: menit);
    await _persist(updated, entry);
  }

  /// Ambil entry hari ini dari [jadwal] berdasarkan tanggal sekarang.
  static ImsakiyahEntry? todayEntry(Imsakiyah jadwal) {
    final today = DateTime.now().day;
    final list = jadwal.imsakiyah;
    for (final entry in list) {
      if (entry.tanggal == today) return entry;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  ImsakAlarmPrefs? get _currentPrefs {
    final s = state;
    return s is ImsakAlarmLoaded ? s.prefs : null;
  }

  Future<void> _persist(ImsakAlarmPrefs prefs, ImsakiyahEntry? entry) async {
    await _savePrefs(prefs);
    emit(ImsakAlarmState.loaded(prefs: prefs));

    if (entry != null) {
      final config = ImsakAlarmConfig(
        imsakEnabled: prefs.imsakEnabled,
        sahurEnabled: prefs.sahurEnabled,
        menitSebelumImsak: prefs.menitSebelumImsak,
      );
      try {
        await _scheduler.scheduleForToday(entry, config);
      } on Object catch (e) {
        debugPrint('ImsakAlarmCubit: schedule error: $e');
      }
    } else {
      // Tidak ada entry → cancel semua alarm imsak/sahur
      await _scheduler.cancelAll();
    }
  }
}
