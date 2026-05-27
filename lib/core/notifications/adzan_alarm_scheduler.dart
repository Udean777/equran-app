import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:equran_app/core/notifications/adzan_alarm_callback.dart';
import 'package:flutter/foundation.dart';

/// Helper untuk schedule dan cancel adzan alarm via AndroidAlarmManager.
/// Dipisah dari adzan_alarm_callback.dart agar top-level callback
/// tidak bercampur dengan helper functions.
///
/// Semua method ini no-op di iOS — AlarmManager adalah Android-only.

/// Schedule adzan alarm pada [scheduledTime].
Future<void> scheduleAdzanAlarm({
  required int id,
  required DateTime scheduledTime,
  required bool isSubuh,
  required String nama,
}) async {
  if (!Platform.isAndroid) return;
  await AndroidAlarmManager.oneShotAt(
    scheduledTime,
    id,
    playAdzanCallback,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
    params: {
      'isSubuh': isSubuh,
      'nama': nama,
    },
  );
  debugPrint('scheduleAdzanAlarm: $nama at $scheduledTime (id=$id)');
}

/// Cancel adzan alarm berdasarkan [id].
Future<void> cancelAdzanAlarm(int id) async {
  if (!Platform.isAndroid) return;
  await AndroidAlarmManager.cancel(id);
  debugPrint('cancelAdzanAlarm: id=$id');
}
