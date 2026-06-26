import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_schedule_entry.dart';

abstract interface class IShalatNotificationScheduler {
  Future<void> scheduleForNextDays(
    List<ShalatScheduleEntry> entries,
    ShalatNotifPrefs prefs,
  );
  Future<void> cancelAll();
  Future<void> cancelById(int id);
}
