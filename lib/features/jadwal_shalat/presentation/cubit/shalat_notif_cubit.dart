import 'dart:async';

import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/services/shalat_notification_scheduler.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/params/jadwal_shalat_params.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/notifications/shalat_schedule_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class ShalatNotifCubit extends Cubit<ShalatNotifPrefs> {
  ShalatNotifCubit(
    this._getPrefs,
    this._savePrefs,
    this._scheduler,
    this._getJadwal,
    this._getLastLocation,
  ) : super(const ShalatNotifPrefs());

  final GetShalatNotifPrefs _getPrefs;
  final SaveShalatNotifPrefs _savePrefs;
  final IShalatNotificationScheduler _scheduler;
  final GetJadwalShalat _getJadwal;
  final GetLastLocationShalat _getLastLocation;

  /// Jadwal 10 hari ke depan — di-set dari JadwalShalatCubit setelah jadwal loaded.
  List<ShalatScheduleEntry> _entries = [];

  /// Load preferensi dari Hive.
  void load() {
    unawaited(
      _getPrefs().then((result) {
        if (isClosed) return;
        result.fold(
          (_) => emit(const ShalatNotifPrefs()),
          emit,
        );
      }),
    );
  }

  /// Init saat app start: load prefs + coba jadwalkan notifikasi
  /// menggunakan lokasi terakhir yang tersimpan.
  /// Dipanggil dari main.dart atau app init — tidak bergantung pada
  /// JadwalShalatCubit agar notifikasi tetap terjadwal walau user
  /// tidak membuka halaman jadwal shalat.
  Future<void> initAndSchedule() async {
    // 1. Load prefs
    final prefsResult = await _getPrefs();
    final prefs = prefsResult.fold((_) => const ShalatNotifPrefs(), (p) => p);
    emit(prefs);

    // Jika semua notif dimatikan, tidak perlu lanjut
    if (!prefs.subuh &&
        !prefs.dzuhur &&
        !prefs.ashar &&
        !prefs.maghrib &&
        !prefs.isya) {
      return;
    }

    // 2. Ambil lokasi terakhir
    final locationResult = await _getLastLocation();
    final location = locationResult.fold((_) => null, (l) => l);
    final provinsi = location?.provinsi;
    final kabkota = location?.kabkota;

    if (provinsi == null || kabkota == null) {
      debugPrint('ShalatNotifCubit.initAndSchedule: lokasi belum tersimpan');
      return;
    }

    // 3. Load jadwal bulan ini
    final now = DateTime.now();
    final jadwalResult = await _getJadwal(
      GetJadwalShalatParams(
        provinsi: provinsi,
        kabkota: kabkota,
        bulan: now.month,
        tahun: now.year,
      ),
    );

    jadwalResult.fold(
      (failure) => debugPrint(
        'ShalatNotifCubit.initAndSchedule: gagal load jadwal — $failure',
      ),
      (jadwal) {
        final futureEntries = jadwal.jadwal
            .where((e) => e.tanggal >= now.day)
            .take(2)
            .map(
              (e) => ShalatScheduleEntry(
                date: DateTime(now.year, now.month, e.tanggal),
                subuh: e.subuh,
                dzuhur: e.dzuhur,
                ashar: e.ashar,
                maghrib: e.maghrib,
                isya: e.isya,
              ),
            )
            .toList();

        if (futureEntries.isEmpty) {
          debugPrint('ShalatNotifCubit.initAndSchedule: entries null');
          return;
        }

        _entries = futureEntries;
        unawaited(_reschedule(prefs));
      },
    );
  }

  /// Set jadwal hari ini dari luar (dipanggil JadwalShalatCubit).
  /// Langsung reschedule dengan prefs saat ini.
  void setEntries(List<ShalatScheduleEntry> entries) {
    _entries = entries;
    unawaited(_reschedule(state));
  }

  /// Toggle notifikasi untuk waktu shalat tertentu.
  Future<void> toggleSubuh() => _update(state.copyWith(subuh: !state.subuh));
  Future<void> toggleDzuhur() => _update(state.copyWith(dzuhur: !state.dzuhur));
  Future<void> toggleAshar() => _update(state.copyWith(ashar: !state.ashar));
  Future<void> toggleMaghrib() =>
      _update(state.copyWith(maghrib: !state.maghrib));
  Future<void> toggleIsya() => _update(state.copyWith(isya: !state.isya));

  /// Update menit sebelum notifikasi.
  Future<void> setMenitSebelum(int menit) =>
      _update(state.copyWith(menitSebelum: menit));

  Future<void> _update(ShalatNotifPrefs prefs) async {
    emit(prefs);
    await _savePrefs(prefs);
    unawaited(_reschedule(prefs));
  }

  bool _isRescheduling = false;

  Future<void> _reschedule(ShalatNotifPrefs prefs) async {
    if (_entries.isEmpty) {
      debugPrint('ShalatNotifCubit: _entries kosong, skip reschedule');
      return;
    }
    if (_isRescheduling) {
      debugPrint('ShalatNotifCubit: sedang reschedule, skip');
      return;
    }

    _isRescheduling = true;
    try {
      await _scheduler.scheduleForNextDays(_entries, prefs);
    } on Object catch (e) {
      debugPrint('ShalatNotifCubit: reschedule error: $e');
    } finally {
      _isRescheduling = false;
    }
  }
}
