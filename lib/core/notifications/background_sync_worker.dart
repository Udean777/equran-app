// ignore_for_file: unreachable_from_main // Used in main.dart

import 'package:equran_app/features/jadwal_shalat/presentation/cubit/shalat_notif_cubit.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await Hive.initFlutter();
      await configureDependencies();

      // Panggil sinkronisasi & schedule ulang (10 hari ke depan)
      final cubit = getIt<ShalatNotifCubit>();
      await cubit.initAndSchedule();

      return Future.value(true);
    } on Object catch (e) {
      debugPrint('BackgroundSyncWorker error: $e');
      return Future.value(false);
    }
  });
}

class BackgroundSyncWorker {
  static const String syncTaskName = 'shalat_schedule_sync';

  static Future<void> init() async {
    await Workmanager().initialize(
      callbackDispatcher,
    );

    // Jadwalkan task harian
    await Workmanager().registerPeriodicTask(
      'sync_task_1',
      syncTaskName,
      frequency: const Duration(days: 1),
      initialDelay: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected, // Butuh internet jika ganti bulan
        requiresBatteryNotLow: true,
      ),
    );
  }
}
