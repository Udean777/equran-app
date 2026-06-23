import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';

abstract interface class ImsakAlarmScheduler {
  Future<void> scheduleForToday(ImsakiyahEntry entry, ImsakAlarmPrefs prefs);
  Future<void> cancelAll();
}
