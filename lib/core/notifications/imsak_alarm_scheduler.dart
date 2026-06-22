import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/notifications/imsak_alarm_config.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/core/utils/time_parsing.dart';
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
      final scheduledTime = parseWaktu(
        date: DateTime.now(),
        waktuStr: entry.imsak,
      );

      if (scheduledTime != null &&
          !scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
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
      final scheduledTime = parseWaktu(
        date: DateTime.now(),
        waktuStr: entry.imsak,
        offsetMinutes: -config.menitSebelumImsak,
        rescheduleNextDayIfPast: true,
      );

      if (scheduledTime != null &&
          !scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
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
      presentBanner: true,
      presentList: true,
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
}
