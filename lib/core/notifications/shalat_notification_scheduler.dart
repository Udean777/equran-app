import 'dart:io';

import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/notifications/adzan_alarm_scheduler.dart';
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
  /// Android: pakai AndroidAlarmManager untuk audio playback via background isolate.
  /// iOS: pakai flutter_local_notifications dengan sound .caf.
  Future<void> scheduleForToday(
    ShalatScheduleEntry entry,
    ShalatNotifConfig config,
  ) async {
    // Cancel semua alarm + notifikasi lama
    await cancelAll();

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

      // Android: schedule via AlarmManager → audio playback di background isolate
      // iOS: schedule via flutter_local_notifications dengan .caf sound
      await _scheduleForPlatform(
        id: waktu.id,
        nama: waktu.nama,
        isSubuh: waktu.isSubuh,
        scheduledTime: scheduledTime,
      );

      debugPrint(
        'ShalatNotificationScheduler: scheduled ${waktu.nama} '
        'at $scheduledTime',
      );
    }
  }

  /// Cancel semua alarm adzan (Android AlarmManager + iOS notif).
  Future<void> cancelAll() async {
    for (final id in [
      NotificationIds.subuh,
      NotificationIds.dzuhur,
      NotificationIds.ashar,
      NotificationIds.maghrib,
      NotificationIds.isya,
    ]) {
      // Cancel AlarmManager (Android)
      await cancelAdzanAlarm(id);
      // Cancel flutter_local_notifications (iOS fallback)
      await _notificationService.cancelById(id);
    }
  }

  /// Cancel notifikasi untuk waktu shalat tertentu.
  Future<void> cancelById(int id) async {
    await cancelAdzanAlarm(id);
    await _notificationService.cancelById(id);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<void> _scheduleForPlatform({
    required int id,
    required String nama,
    required bool isSubuh,
    required tz.TZDateTime scheduledTime,
  }) async {
    if (Platform.isAndroid) {
      // Android: AlarmManager → playAdzanCallback → AudioCompositeHandler.playAdzan & NotificationService.showNotification
      await scheduleAdzanAlarm(
        id: id,
        scheduledTime: scheduledTime.toLocal(),
        isSubuh: isSubuh,
        nama: nama,
      );
    } else {
      // iOS: flutter_local_notifications dengan .caf sound (max ~30 detik)
      await _notificationService.scheduleNotification(
        id: id,
        title: 'Waktu $nama',
        body: 'Sudah masuk waktu shalat $nama',
        scheduledTime: scheduledTime,
        isSubuh: isSubuh,
      );
    }
  }

  /// Parse string waktu format "HH:mm" ke [tz.TZDateTime].
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
