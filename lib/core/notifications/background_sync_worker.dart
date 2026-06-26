// Because this file uses an entry-point for Workmanager, analyzer considers it an executable library.
// ignore_for_file: unreachable_from_main

import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_local_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_remote_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/repositories/jadwal_shalat_repository_impl.dart';
import 'package:equran_app/features/jadwal_shalat/data/repositories/shalat_location_repository_impl.dart';
import 'package:equran_app/features/jadwal_shalat/data/repositories/shalat_notif_prefs_repository_impl.dart';
import 'package:equran_app/features/jadwal_shalat/domain/services/shalat_notif_scheduler_service.dart';
import 'package:equran_app/features/jadwal_shalat/domain/services/shalat_notification_scheduler_impl.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await Hive.initFlutter();
      await Hive.openBox<String>('shalat_box');

      final shalatBox = Hive.box<String>('shalat_box');
      final notifService = NotificationService(
        FlutterLocalNotificationsPlugin(),
      );
      await notifService.init();
      final remoteDS = JadwalShalatRemoteDataSourceImpl(DioClient());
      final localDS = JadwalShalatLocalDataSourceImpl(shalatBox);
      final repo = JadwalShalatRepositoryImpl(remoteDS, localDS);
      final locationRepo = ShalatLocationRepositoryImpl(shalatBox);
      final notifPrefsRepo = ShalatNotifPrefsRepositoryImpl(shalatBox);

      final service = ShalatNotifSchedulerService(
        GetShalatNotifPrefs(notifPrefsRepo),
        ShalatNotificationSchedulerImpl(notifService),
        GetJadwalShalat(repo),
        GetLastLocationShalat(locationRepo),
      );
      await service.initAndSchedule();

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

    await Workmanager().registerPeriodicTask(
      'sync_task_1',
      syncTaskName,
      frequency: const Duration(days: 1),
      initialDelay: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }
}
