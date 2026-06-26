import 'dart:async';

import 'package:equran_app/app.dart';
import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/core/notifications/background_sync_worker.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/features/audio/data/datasources/audio_service_module.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_local_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_remote_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/repositories/jadwal_shalat_repository_impl.dart';
import 'package:equran_app/features/jadwal_shalat/data/repositories/shalat_location_repository_impl.dart';
import 'package:equran_app/features/jadwal_shalat/data/repositories/shalat_notif_prefs_repository_impl.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/notifications/shalat_notification_scheduler.dart';
import 'package:equran_app/features/jadwal_shalat/services/shalat_notif_scheduler_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Preopen all Hive boxes for synchronous provider access
  await Future.wait([
    Hive.openBox<String>('settings_box'),
    Hive.openBox<String>('bookmark_box'),
    Hive.openBox<String>('shalat_box'),
    Hive.openBox<String>('imsakiyah_box'),
    Hive.openLazyBox<String>('doa_box'),
    Hive.openBox<String>('catatan_box'),
    Hive.openBox<String>('hafalan_box'),
    Hive.openBox<String>('doa_bookmark_box'),
    Hive.openBox<String>('statistik_shalat_box'),
    Hive.openBox<String>('reading_history_box'),
    Hive.openLazyBox<String>('surat_box'),
    Hive.openLazyBox<String>('tafsir_box'),
    Hive.openBox<String>('tasbih_box'),
  ]);

  final notifService = NotificationService(FlutterLocalNotificationsPlugin());
  await notifService.init();
  await BackgroundSyncWorker.init();
  await AudioServiceModule.init();

  final shalatBox = Hive.box<String>('shalat_box');
  final remoteDS = JadwalShalatRemoteDataSourceImpl(DioClient());
  final localDS = JadwalShalatLocalDataSourceImpl(shalatBox);
  final repo = JadwalShalatRepositoryImpl(remoteDS, localDS);
  final locationRepo = ShalatLocationRepositoryImpl(shalatBox);
  final notifPrefsRepo = ShalatNotifPrefsRepositoryImpl(shalatBox);

  unawaited(
    ShalatNotifSchedulerService(
      GetShalatNotifPrefs(notifPrefsRepo),
      ShalatNotificationSchedulerImpl(notifService),
      GetJadwalShalat(repo),
      GetLastLocationShalat(locationRepo),
    ).initAndSchedule(),
  );

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
  // Izin notifikasi diminta dari onboarding slide 2, bukan di sini.
}
