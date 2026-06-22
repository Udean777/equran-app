import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;

tz.TZDateTime? parseWaktu({
  required DateTime date,
  required String waktuStr,
  int offsetMinutes = 0,
  bool rescheduleNextDayIfPast = false,
}) {
  try {
    final parts = waktuStr.trim().split(':');
    if (parts.length != 2) return null;

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    var scheduled = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    ).add(Duration(minutes: offsetMinutes));

    final now = tz.TZDateTime.now(tz.local);
    if (scheduled.isBefore(now)) {
      if (rescheduleNextDayIfPast) {
        scheduled = scheduled.add(const Duration(days: 1));
      } else {
        return null;
      }
    }

    return scheduled;
  } on Object catch (e) {
    debugPrint('parseWaktu: parse error for "$waktuStr": $e');
    return null;
  }
}
