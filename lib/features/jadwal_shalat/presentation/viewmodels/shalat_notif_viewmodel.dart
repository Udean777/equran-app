import 'dart:async';

import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_schedule_entry.dart';
import 'package:equran_app/features/jadwal_shalat/domain/services/shalat_notif_scheduler_service.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShalatNotifViewModel extends Notifier<ShalatNotifPrefs> {
  @override
  ShalatNotifPrefs build() => const ShalatNotifPrefs();

  GetShalatNotifPrefs get _getPrefs => ref.read(getShalatNotifPrefsProvider);
  SaveShalatNotifPrefs get _savePrefs => ref.read(saveShalatNotifPrefsProvider);
  ShalatNotifSchedulerService get _schedulerService =>
      ref.read(shalatNotifSchedulerServiceProvider);

  List<ShalatScheduleEntry> _entries = [];

  Future<void> load() async {
    final result = await _getPrefs();
    result.fold(
      (_) => state = const ShalatNotifPrefs(),
      (p) => state = p,
    );
  }

  void setEntries(List<ShalatScheduleEntry> entries) {
    _entries = entries;
    unawaited(_schedulerService.scheduleForEntries(entries));
  }

  Future<void> toggleSubuh() => _update(state.copyWith(subuh: !state.subuh));
  Future<void> toggleDzuhur() => _update(state.copyWith(dzuhur: !state.dzuhur));
  Future<void> toggleAshar() => _update(state.copyWith(ashar: !state.ashar));
  Future<void> toggleMaghrib() =>
      _update(state.copyWith(maghrib: !state.maghrib));
  Future<void> toggleIsya() => _update(state.copyWith(isya: !state.isya));

  Future<void> setMenitSebelum(int menit) =>
      _update(state.copyWith(menitSebelum: menit));

  Future<void> _update(ShalatNotifPrefs prefs) async {
    state = prefs;
    await _savePrefs(prefs);
    unawaited(_schedulerService.scheduleForEntries(_entries));
  }
}
