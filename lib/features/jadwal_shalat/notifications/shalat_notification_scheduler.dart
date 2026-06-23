import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/core/utils/time_parsing.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/services/shalat_notification_scheduler.dart';
import 'package:equran_app/features/jadwal_shalat/notifications/shalat_schedule_entry.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

@LazySingleton(as: IShalatNotificationScheduler)
class ShalatNotificationSchedulerImpl implements IShalatNotificationScheduler {
  ShalatNotificationSchedulerImpl(this._notificationService);

  final NotificationService _notificationService;

  @override
  Future<void> scheduleForNextDays(
    List<ShalatScheduleEntry> entries,
    ShalatNotifPrefs prefs,
  ) async {
    await cancelAll();

    var dayIndex = 0;
    for (final entry in entries) {
      final waktuList = [
        _WaktuShalat(
          id: NotificationIds.subuh,
          nama: 'Subuh',
          waktu: entry.subuh,
          enabled: prefs.subuh,
          isSubuh: true,
        ),
        _WaktuShalat(
          id: NotificationIds.dzuhur,
          nama: 'Dzuhur',
          waktu: entry.dzuhur,
          enabled: prefs.dzuhur,
          isSubuh: false,
        ),
        _WaktuShalat(
          id: NotificationIds.ashar,
          nama: 'Ashar',
          waktu: entry.ashar,
          enabled: prefs.ashar,
          isSubuh: false,
        ),
        _WaktuShalat(
          id: NotificationIds.maghrib,
          nama: 'Maghrib',
          waktu: entry.maghrib,
          enabled: prefs.maghrib,
          isSubuh: false,
        ),
        _WaktuShalat(
          id: NotificationIds.isya,
          nama: 'Isya',
          waktu: entry.isya,
          enabled: prefs.isya,
          isSubuh: false,
        ),
      ];

      for (final waktu in waktuList) {
        if (!waktu.enabled) continue;

        final scheduledTime = parseWaktu(
          date: entry.date,
          waktuStr: waktu.waktu,
          offsetMinutes: -prefs.menitSebelum,
        );

        if (scheduledTime == null) continue;

        if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
          continue;
        }

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

  @override
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
      await _notificationService.cancelById(baseId);
    }
  }

  @override
  Future<void> cancelById(int id) async {
    for (var day = 0; day < 60; day++) {
      await _notificationService.cancelById(id + (day * 1000));
    }
    await _notificationService.cancelById(id);
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
