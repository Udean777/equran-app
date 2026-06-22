import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/core/notifications/shalat_notif_config.dart';
import 'package:equran_app/core/notifications/shalat_schedule_entry.dart';
import 'package:equran_app/core/utils/time_parsing.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

@lazySingleton
class ShalatNotificationScheduler {
  ShalatNotificationScheduler(this._notificationService);

  final NotificationService _notificationService;

  /// Schedule notifikasi untuk 10 hari ke depan
  /// berdasarkan [entries] dan [config].
  Future<void> scheduleForNextDays(
    List<ShalatScheduleEntry> entries,
    ShalatNotifConfig config,
  ) async {
    // Cancel semua alarm + notifikasi lama
    await cancelAll();

    var dayIndex = 0;
    for (final entry in entries) {
      final waktuList = [
        _WaktuShalat(
          id: NotificationIds.subuh,
          nama: 'Subuh',
          waktu: entry.subuh,
          enabled: config.subuh,
          isSubuh: true,
        ),
        _WaktuShalat(
          id: NotificationIds.dzuhur,
          nama: 'Dzuhur',
          waktu: entry.dzuhur,
          enabled: config.dzuhur,
          isSubuh: false,
        ),
        _WaktuShalat(
          id: NotificationIds.ashar,
          nama: 'Ashar',
          waktu: entry.ashar,
          enabled: config.ashar,
          isSubuh: false,
        ),
        _WaktuShalat(
          id: NotificationIds.maghrib,
          nama: 'Maghrib',
          waktu: entry.maghrib,
          enabled: config.maghrib,
          isSubuh: false,
        ),
        _WaktuShalat(
          id: NotificationIds.isya,
          nama: 'Isya',
          waktu: entry.isya,
          enabled: config.isya,
          isSubuh: false,
        ),
      ];

      for (final waktu in waktuList) {
        if (!waktu.enabled) continue;

        final scheduledTime = parseWaktu(
          date: entry.date,
          waktuStr: waktu.waktu,
          offsetMinutes: -config.menitSebelum,
        );

        if (scheduledTime == null) continue;

        // Jangan schedule untuk waktu yang sudah lewat (mencegah spam notif instan)
        if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
          continue;
        }

        // Hindari bentrok ID dengan ID eksisting atau hari lain.
        final uniqueId = waktu.id + (dayIndex * 1000);

        await _notificationService.scheduleNotification(
          id: uniqueId,
          title: 'Waktu ${waktu.nama}',
          body: 'Sudah masuk waktu shalat ${waktu.nama}',
          scheduledTime: scheduledTime,
          isSubuh: waktu.isSubuh,
        );
      }
      dayIndex++;
    }
  }

  /// Cancel semua notifikasi adzan
  Future<void> cancelAll() async {
    for (final baseId in [
      NotificationIds.subuh,
      NotificationIds.dzuhur,
      NotificationIds.ashar,
      NotificationIds.maghrib,
      NotificationIds.isya,
    ]) {
      for (var day = 0; day < 60; day++) {
        await _notificationService.cancelById(baseId + (day * 1000));
      }
      // Bersihkan ID lama yang mungkin masih terschedule
      await _notificationService.cancelById(baseId);
    }
  }

  /// Cancel notifikasi untuk waktu shalat tertentu secara spesifik
  Future<void> cancelById(int id) async {
    for (var day = 0; day < 60; day++) {
      await _notificationService.cancelById(id + (day * 1000));
    }
    await _notificationService.cancelById(id);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------
}

class _WaktuShalat {
  const _WaktuShalat({
    required this.id,
    required this.nama,
    required this.waktu,
    required this.enabled,
    required this.isSubuh,
  });

  final int id;
  final String nama;
  final String waktu;
  final bool enabled;
  final bool isSubuh;
}
