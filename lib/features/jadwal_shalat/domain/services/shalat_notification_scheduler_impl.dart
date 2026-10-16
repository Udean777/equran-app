import 'package:alarm/alarm.dart';
import 'package:equran_app/core/constants/notification_ids.dart';
import 'package:equran_app/core/utils/time_parsing.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_schedule_entry.dart';
import 'package:equran_app/features/jadwal_shalat/domain/services/shalat_notification_scheduler.dart';
import 'package:timezone/timezone.dart' as tz;

class ShalatNotificationSchedulerImpl implements IShalatNotificationScheduler {
  ShalatNotificationSchedulerImpl();

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
          nama: entry.date.weekday == DateTime.friday ? 'Jumat' : 'Dzuhur',
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

        final alarmSettings = AlarmSettings(
          id: uniqueId,
          dateTime: scheduledTime,
          assetAudioPath: waktu.isSubuh
              ? 'assets/audio/adzan_subuh.m4a'
              : 'assets/audio/adzan.m4a',
          volumeSettings: VolumeSettings.fade(
            volume: 1,
            fadeDuration: const Duration(seconds: 3),
          ),
          notificationSettings: NotificationSettings(
            title: 'Waktu ${waktu.nama}',
            body: 'Sudah masuk waktu shalat ${waktu.nama}',
          ),
        );
        await Alarm.set(alarmSettings: alarmSettings);
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
        await Alarm.stop(baseId + (day * 1000));
      }
      await Alarm.stop(baseId);
    }
  }

  @override
  Future<void> cancelById(int id) async {
    for (var day = 0; day < 60; day++) {
      await Alarm.stop(id + (day * 1000));
    }
    await Alarm.stop(id);
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
