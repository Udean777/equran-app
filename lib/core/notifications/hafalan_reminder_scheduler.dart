import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/constants/quran_constants.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

@lazySingleton
class HafalanReminderScheduler {
  HafalanReminderScheduler(this._notificationService);

  final NotificationService _notificationService;

  /// Jam default notifikasi muraja'ah (08:00).
  static const int _defaultHour = 8;

  /// Schedule notifikasi muraja'ah untuk [hafalan].
  /// Dijadwalkan pada tanggalMurajaahBerikutnya jam 08:00.
  /// Tidak melakukan apa-apa jika tanggalMurajaahBerikutnya null
  /// atau hafalan sudah level max.
  Future<void> scheduleReminder(HafalanSurat hafalan) async {
    if (hafalan.tanggalMurajaahBerikutnya == null) return;
    if (hafalan.isMurajaahSelesai) {
      await cancelReminder(hafalan.suratNomor);
      return;
    }

    final id = _notifId(hafalan.suratNomor);
    final scheduledTime = _toTZDateTime(hafalan.tanggalMurajaahBerikutnya!);

    // Jika waktu sudah lewat, tidak perlu schedule
    if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      debugPrint(
        'HafalanReminderScheduler: skip schedule for surat '
        '${hafalan.suratNomor} — waktu sudah lewat',
      );
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      kHafalanChannelId,
      'Pengingat Hafalan',
      channelDescription: 'Pengingat jadwal murajaah hafalan Al-Quran',
      importance: Importance.high,
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
      title: '📿 Murajaah ${hafalan.namaLatin}',
      body: 'Sudah waktunya murajaah. Jangan sampai lupa!',
      scheduledTime: scheduledTime,
      details: details,
      matchDateTimeComponents: null, // one-shot, tidak repeat harian
    );

    debugPrint(
      'HafalanReminderScheduler: scheduled murajaah '
      '${hafalan.namaLatin} (ID $id) at $scheduledTime',
    );
  }

  /// Cancel notifikasi muraja'ah untuk surat tertentu.
  Future<void> cancelReminder(int suratNomor) async {
    final id = _notifId(suratNomor);
    await _notificationService.cancelById(id);
    debugPrint(
      'HafalanReminderScheduler: cancelled reminder for surat $suratNomor (ID $id)',
    );
  }

  /// Cancel semua notifikasi muraja'ah (ID 20–133).
  Future<void> cancelAll() async {
    for (
      var suratNomor = 1;
      suratNomor <= QuranConstants.totalSurat;
      suratNomor++
    ) {
      await _notificationService.cancelById(_notifId(suratNomor));
    }
    debugPrint('HafalanReminderScheduler: cancelled all hafalan reminders');
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Hitung notification ID dari nomor surat.
  /// Range: 20 (surat 1) – 133 (surat 114).
  int _notifId(int suratNomor) =>
      NotificationIds.hafalanReminderBase + suratNomor;

  /// Konversi DateTime ke tz.TZDateTime pada jam 08:00.
  tz.TZDateTime _toTZDateTime(DateTime date) {
    return tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      _defaultHour,
    );
  }
}
