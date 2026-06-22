import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/core/utils/time_parsing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

/// Scheduler untuk reminder checklist shalat.
/// Mengirim notifikasi 30 menit setelah waktu shalat sebagai pengingat
/// untuk mencatat status shalat di Statistik Shalat.
@lazySingleton
class ShalatChecklistReminderScheduler {
  ShalatChecklistReminderScheduler(
    this._notificationService,
    this._plugin,
  );

  final NotificationService _notificationService;
  final FlutterLocalNotificationsPlugin _plugin;

  static const _delayMenit = 30;

  static const _waktuList = [
    _WaktuInfo(
      id: NotificationIds.shalatChecklistBase,
      nama: 'Subuh',
      emoji: '🌅',
    ),
    _WaktuInfo(
      id: NotificationIds.shalatChecklistBase + 1,
      nama: 'Dzuhur',
      emoji: '☀️',
    ),
    _WaktuInfo(
      id: NotificationIds.shalatChecklistBase + 2,
      nama: 'Ashar',
      emoji: '🌤️',
    ),
    _WaktuInfo(
      id: NotificationIds.shalatChecklistBase + 3,
      nama: 'Maghrib',
      emoji: '🌇',
    ),
    _WaktuInfo(
      id: NotificationIds.shalatChecklistBase + 4,
      nama: 'Isya',
      emoji: '🌙',
    ),
  ];

  /// Schedule reminder checklist untuk semua waktu shalat hari ini.
  /// [waktuMap] adalah map nama waktu → string jam "HH:mm"
  /// contoh: {'Subuh': '04:32', 'Dzuhur': '12:01', ...}
  Future<void> scheduleForToday(Map<String, String> waktuMap) async {
    // Cancel reminder lama
    await cancelAll();

    // Buat channel Android jika belum ada
    await _createChannel();

    for (var i = 0; i < _waktuList.length; i++) {
      final info = _waktuList[i];
      final waktuStr = waktuMap[info.nama];
      if (waktuStr == null) continue;

      final scheduledTime = parseWaktu(
        date: DateTime.now(),
        waktuStr: waktuStr,
        offsetMinutes: _delayMenit,
      );
      if (scheduledTime == null ||
          scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
        continue;
      }

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationIds.shalatChecklistChannelId,
          'Reminder Checklist Shalat',
          channelDescription: 'Pengingat untuk mencatat status shalat harian',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
          presentBanner: true,
          presentList: true,
        ),
      );

      await _notificationService.scheduleNotificationRaw(
        id: info.id,
        title: '${info.emoji} Sudah shalat ${info.nama}?',
        body: 'Catat status shalat ${info.nama} hari ini di Statistik Shalat.',
        scheduledTime: scheduledTime,
        details: details,
        matchDateTimeComponents: null, // one-shot, tidak repeat harian
      );

      debugPrint(
        'ShalatChecklistReminderScheduler: scheduled ${info.nama} '
        'reminder at $scheduledTime',
      );
    }
  }

  /// Cancel semua reminder checklist shalat.
  Future<void> cancelAll() async {
    for (final info in _waktuList) {
      await _notificationService.cancelById(info.id);
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  Future<void> _createChannel() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationIds.shalatChecklistChannelId,
        'Reminder Checklist Shalat',
        description: 'Pengingat untuk mencatat status shalat harian',
      ),
    );
  }
}

class _WaktuInfo {
  const _WaktuInfo({
    required this.id,
    required this.nama,
    required this.emoji,
  });

  final int id;
  final String nama;
  final String emoji;
}
