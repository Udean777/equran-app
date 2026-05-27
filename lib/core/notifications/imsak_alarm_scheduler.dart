import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/notifications/imsak_alarm_config.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

@lazySingleton
class ImsakAlarmScheduler {
  ImsakAlarmScheduler(this._notificationService);

  final NotificationService _notificationService;

  /// Schedule alarm imsak dan/atau sahur untuk hari ini
  /// berdasarkan [entry] dan [config].
  Future<void> scheduleForToday(
    ImsakiyahEntry entry,
    ImsakAlarmConfig config,
  ) async {
    // Cancel alarm imsak & sahur lama sebelum reschedule
    await cancelAll();

    // Alarm imsak — tepat di waktu imsak
    if (config.imsakEnabled) {
      final scheduledTime = _parseWaktu(
        waktuStr: entry.imsak,
        menitSebelum: 0,
      );

      if (scheduledTime != null) {
        await _scheduleAlarm(
          id: NotificationIds.imsak,
          title: 'Waktu Imsak',
          body: 'Sudah masuk waktu imsak, hentikan makan dan minum',
          scheduledTime: scheduledTime,
        );
        debugPrint(
          'ImsakAlarmScheduler: scheduled imsak at $scheduledTime',
        );
      } else {
        debugPrint(
          'ImsakAlarmScheduler: gagal parse waktu imsak (${entry.imsak})',
        );
      }
    }

    // Alarm sahur — [menitSebelumImsak] menit sebelum imsak
    if (config.sahurEnabled) {
      final scheduledTime = _parseWaktu(
        waktuStr: entry.imsak,
        menitSebelum: config.menitSebelumImsak,
      );

      if (scheduledTime != null) {
        await _scheduleAlarm(
          id: NotificationIds.sahur,
          title: 'Alarm Sahur',
          body: 'Sahur sekarang! Imsak ${config.menitSebelumImsak} menit lagi',
          scheduledTime: scheduledTime,
        );
        debugPrint(
          'ImsakAlarmScheduler: scheduled sahur at $scheduledTime '
          '(${config.menitSebelumImsak} menit sebelum imsak)',
        );
      } else {
        debugPrint(
          'ImsakAlarmScheduler: gagal parse waktu sahur (${entry.imsak})',
        );
      }
    }
  }

  /// Cancel alarm imsak (ID 6) dan sahur (ID 7).
  /// Tidak mengganggu notifikasi shalat (ID 1–5) maupun reminder Quran (ID 10).
  Future<void> cancelAll() async {
    await _notificationService.cancelById(NotificationIds.imsak);
    await _notificationService.cancelById(NotificationIds.sahur);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<void> _scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      kImsakChannelId,
      'Alarm Imsak & Sahur',
      channelDescription: 'Alarm pengingat waktu imsak dan sahur Ramadan',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationService.scheduleNotificationRaw(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      details: details,
    );
  }

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
        'ImsakAlarmScheduler: parse error for "$waktuStr": $e',
      );
      return null;
    }
  }
}
