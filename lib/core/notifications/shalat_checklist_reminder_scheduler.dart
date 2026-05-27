import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

/// Channel ID untuk reminder checklist shalat.
const String kShalatChecklistChannelId = 'shalat_checklist_channel';

/// Notification ID base untuk reminder checklist shalat.
/// ID range: 140–144 (5 waktu shalat).
const int kNotifIdShalatChecklistBase = 140;

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
      id: kNotifIdShalatChecklistBase,
      nama: 'Subuh',
      emoji: '🌅',
    ),
    _WaktuInfo(
      id: kNotifIdShalatChecklistBase + 1,
      nama: 'Dzuhur',
      emoji: '☀️',
    ),
    _WaktuInfo(
      id: kNotifIdShalatChecklistBase + 2,
      nama: 'Ashar',
      emoji: '🌤️',
    ),
    _WaktuInfo(
      id: kNotifIdShalatChecklistBase + 3,
      nama: 'Maghrib',
      emoji: '🌇',
    ),
    _WaktuInfo(
      id: kNotifIdShalatChecklistBase + 4,
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

      final scheduledTime = _parseWaktu(waktuStr, delayMenit: _delayMenit);
      if (scheduledTime == null) continue;

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          kShalatChecklistChannelId,
          'Reminder Checklist Shalat',
          channelDescription: 'Pengingat untuk mencatat status shalat harian',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
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

  /// Parse "HH:mm" + tambah [delayMenit] → TZDateTime.
  /// Return null jika format tidak valid atau waktu sudah lewat.
  tz.TZDateTime? _parseWaktu(String waktuStr, {required int delayMenit}) {
    try {
      final parts = waktuStr.trim().split(':');
      if (parts.length != 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = tz.TZDateTime.now(tz.local);
      final scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      ).add(Duration(minutes: delayMenit));

      // Skip jika waktu sudah lewat hari ini
      if (scheduled.isBefore(now)) return null;

      return scheduled;
    } on Object catch (e) {
      debugPrint(
        'ShalatChecklistReminderScheduler: parse error "$waktuStr": $e',
      );
      return null;
    }
  }

  Future<void> _createChannel() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        kShalatChecklistChannelId,
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
