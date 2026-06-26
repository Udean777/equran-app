import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:flutter/foundation.dart';

class QuranReminderScheduler {
  QuranReminderScheduler(this._notificationService);

  final NotificationService _notificationService;

  /// Schedule atau cancel notifikasi reminder baca Quran harian
  /// berdasarkan preferensi yang diberikan.
  ///
  /// Jika enabled true → schedule harian pada jam:menit yang ditentukan.
  /// Jika false → cancel notifikasi.
  Future<void> apply(QuranReminderPrefs prefs) async {
    if (!prefs.enabled) {
      await _notificationService.cancelById(NotificationIds.quranReminder);
      debugPrint('QuranReminderScheduler: cancelled');
      return;
    }

    await _notificationService.scheduleDaily(
      id: NotificationIds.quranReminder,
      title: 'Waktunya Baca Al-Quran',
      body: 'Luangkan waktu sejenak untuk membaca Al-Quran hari ini.',
      hour: prefs.hour,
      minute: prefs.minute,
    );

    debugPrint(
      'QuranReminderScheduler: scheduled at '
      '${prefs.hour.toString().padLeft(2, '0')}:'
      '${prefs.minute.toString().padLeft(2, '0')}',
    );
  }
}
