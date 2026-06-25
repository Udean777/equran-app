import 'dart:async';

import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/notifications/shalat_schedule_entry.dart';
import 'package:equran_app/features/jadwal_shalat/services/shalat_notif_scheduler_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ViewModel untuk manage state notifikasi shalat (UI).
/// Delegate scheduling logic ke ShalatNotifSchedulerService.
class ShalatNotifViewModel extends StateNotifier<ShalatNotifPrefs> {
  ShalatNotifViewModel(
    this._getPrefs,
    this._savePrefs,
    this._schedulerService,
  ) : super(const ShalatNotifPrefs());

  final GetShalatNotifPrefs _getPrefs;
  final SaveShalatNotifPrefs _savePrefs;
  final ShalatNotifSchedulerService _schedulerService;

  List<ShalatScheduleEntry> _entries = [];

  void load() {
    unawaited(
      _getPrefs().then((result) {
        if (mounted) {
          result.fold(
            (_) => state = const ShalatNotifPrefs(),
            (p) => state = p,
          );
        }
      }),
    );
  }

  /// Set jadwal dari JadwalShalatViewModel.
  /// Langsung reschedule notifikasi.
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
