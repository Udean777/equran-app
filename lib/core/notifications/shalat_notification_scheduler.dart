import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/core/notifications/shalat_notif_config.dart';
import 'package:equran_app/core/notifications/shalat_schedule_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

@lazySingleton
class ShalatNotificationScheduler {
  ShalatNotificationScheduler(this._notificationService);

  final NotificationService _notificationService;

  /// Schedule notifikasi untuk semua waktu shalat hari ini
  /// berdasarkan [entry] dan [config].
  Future<void> scheduleForToday(
    ShalatScheduleEntry entry,
    ShalatNotifConfig config,
  ) async {
    // Cancel semua notifikasi lama sebelum reschedule
    await _notificationService.cancelAll();

    final waktuList = [
      _WaktuShalat(
        id: kNotifIdSubuh,
        nama: 'Subuh',
        waktu: entry.subuh,
        enabled: config.subuh,
        isSubuh: true,
      ),
      _WaktuShalat(
        id: kNotifIdDzuhur,
        nama: 'Dzuhur',
        waktu: entry.dzuhur,
        enabled: config.dzuhur,
        isSubuh: false,
      ),
      _WaktuShalat(
        id: kNotifIdAshar,
        nama: 'Ashar',
        waktu: entry.ashar,
        enabled: config.ashar,
        isSubuh: false,
      ),
      _WaktuShalat(
        id: kNotifIdMaghrib,
        nama: 'Maghrib',
        waktu: entry.maghrib,
        enabled: config.maghrib,
        isSubuh: false,
      ),
      _WaktuShalat(
        id: kNotifIdIsya,
        nama: 'Isya',
        waktu: entry.isya,
        enabled: config.isya,
        isSubuh: false,
      ),
    ];

    for (final waktu in waktuList) {
      if (!waktu.enabled) continue;

      final scheduledTime = _parseWaktu(
        waktuStr: waktu.waktu,
        menitSebelum: config.menitSebelum,
      );

      if (scheduledTime == null) {
        debugPrint(
          'ShalatNotificationScheduler: gagal parse waktu ${waktu.nama} '
          '(${waktu.waktu})',
        );
        continue;
      }

      await _notificationService.scheduleNotification(
        id: waktu.id,
        title: 'Waktu ${waktu.nama}',
        body: 'Sudah masuk waktu shalat ${waktu.nama}',
        scheduledTime: scheduledTime,
        isSubuh: waktu.isSubuh,
      );

      debugPrint(
        'ShalatNotificationScheduler: scheduled ${waktu.nama} '
        'at $scheduledTime',
      );
    }
  }

  /// Cancel semua notifikasi shalat.
  Future<void> cancelAll() => _notificationService.cancelAll();

  /// Cancel notifikasi untuk waktu shalat tertentu.
  Future<void> cancelById(int id) => _notificationService.cancelById(id);

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Parse string waktu format "HH:mm" (contoh: "04:32") ke [tz.TZDateTime].
  /// Kurangi [menitSebelum] dari waktu yang diparsing.
  /// Return null jika format tidak valid.
  tz.TZDateTime? _parseWaktu({
    required String waktuStr,
    required int menitSebelum,
  }) {
    try {
      final parts = waktuStr.trim().split(':');
      if (parts.length != 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = tz.TZDateTime.now(tz.local);

      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      ).subtract(Duration(minutes: menitSebelum));

      // Jika waktu sudah lewat hari ini, schedule untuk besok
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      return scheduled;
    } on Object catch (e) {
      debugPrint(
        'ShalatNotificationScheduler: parse error for "$waktuStr": $e',
      );
      return null;
    }
  }
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
