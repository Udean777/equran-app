import 'dart:async';

import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_schedule_entry.dart';
import 'package:equran_app/features/jadwal_shalat/domain/services/shalat_notification_scheduler.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/params/jadwal_shalat_params.dart';
import 'package:flutter/foundation.dart';

/// Standalone service untuk scheduling notifikasi shalat.
/// Tidak bergantung pada ViewModel/Riverpod sehingga bisa dipanggil dari:
/// - main.dart (saat app start)
/// - background_sync_worker.dart (background task)
/// - ViewModel (saat user membuka JadwalShalatPage)
class ShalatNotifSchedulerService {
  ShalatNotifSchedulerService(
    this._getPrefs,
    this._scheduler,
    this._getJadwal,
    this._getLastLocation,
  );

  final GetShalatNotifPrefs _getPrefs;
  final IShalatNotificationScheduler _scheduler;
  final GetJadwalShalat _getJadwal;
  final GetLastLocationShalat _getLastLocation;

  bool _isRescheduling = false;

  /// Init saat app start: load prefs + coba jadwalkan notifikasi
  /// menggunakan lokasi terakhir yang tersimpan.
  /// Dipanggil dari main.dart atau background_sync_worker.dart.
  Future<void> initAndSchedule() async {
    final prefsResult = await _getPrefs();
    final prefs = prefsResult.fold((_) => const ShalatNotifPrefs(), (p) => p);

    if (!prefs.subuh &&
        !prefs.dzuhur &&
        !prefs.ashar &&
        !prefs.maghrib &&
        !prefs.isya) {
      debugPrint('ShalatNotifSchedulerService: semua notif dimatikan');
      return;
    }

    final locationResult = await _getLastLocation();
    final location = locationResult.fold((_) => null, (l) => l);
    final provinsi = location?.provinsi;
    final kabkota = location?.kabkota;

    if (provinsi == null || kabkota == null) {
      debugPrint(
        'ShalatNotifSchedulerService.initAndSchedule: lokasi belum tersimpan',
      );
      return;
    }

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
        'ShalatNotifSchedulerService.initAndSchedule: gagal load jadwal — $failure',
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
          debugPrint(
            'ShalatNotifSchedulerService.initAndSchedule: entries kosong',
          );
          return;
        }

        unawaited(_reschedule(futureEntries, prefs));
      },
    );
  }

  /// Schedule notifikasi untuk entries yang diberikan.
  /// Dipanggil dari JadwalShalatViewModel setelah jadwal loaded.
  Future<void> scheduleForEntries(List<ShalatScheduleEntry> entries) async {
    if (entries.isEmpty) {
      debugPrint('ShalatNotifSchedulerService: entries kosong, skip');
      return;
    }

    final prefsResult = await _getPrefs();
    final prefs = prefsResult.fold((_) => const ShalatNotifPrefs(), (p) => p);

    await _reschedule(entries, prefs);
  }

  Future<void> _reschedule(
    List<ShalatScheduleEntry> entries,
    ShalatNotifPrefs prefs,
  ) async {
    if (_isRescheduling) {
      debugPrint('ShalatNotifSchedulerService: sedang reschedule, skip');
      return;
    }

    _isRescheduling = true;
    try {
      await _scheduler.scheduleForNextDays(entries, prefs);
    } on Object catch (e) {
      debugPrint('ShalatNotifSchedulerService: reschedule error: $e');
    } finally {
      _isRescheduling = false;
    }
  }
}
