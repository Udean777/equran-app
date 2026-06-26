import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/core/utils/time_parsing.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:equran_app/features/imsakiyah/domain/services/imsak_alarm_scheduler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class ImsakAlarmSchedulerImpl implements ImsakAlarmScheduler {
  ImsakAlarmSchedulerImpl(this._notificationService);

  final NotificationService _notificationService;

  /// Schedule alarm imsak dan/atau sahur untuk hari ini
  /// berdasarkan [entry] dan [prefs].
  @override
  Future<void> scheduleForToday(
    ImsakiyahEntry entry,
    ImsakAlarmPrefs prefs,
  ) async {
    await cancelAll();

    if (prefs.imsakEnabled) {
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

    if (prefs.sahurEnabled) {
      final scheduledTime = parseWaktu(
        date: DateTime.now(),
        waktuStr: entry.imsak,
        offsetMinutes: -prefs.menitSebelumImsak,
        rescheduleNextDayIfPast: true,
      );

      if (scheduledTime != null &&
          !scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
        await _scheduleAlarm(
          id: NotificationIds.sahur,
          title: 'Alarm Sahur',
          body: 'Sahur sekarang! Imsak ${prefs.menitSebelumImsak} menit lagi',
          scheduledTime: scheduledTime,
        );
        debugPrint(
          'ImsakAlarmScheduler: scheduled sahur at $scheduledTime '
          '(${prefs.menitSebelumImsak} menit sebelum imsak)',
        );
      } else {
        debugPrint(
          'ImsakAlarmScheduler: gagal parse waktu sahur (${entry.imsak})',
        );
      }
    }
  }

  @override
  Future<void> cancelAll() async {
    await _notificationService.cancelById(NotificationIds.imsak);
    await _notificationService.cancelById(NotificationIds.sahur);
  }

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
