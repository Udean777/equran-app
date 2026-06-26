import 'dart:async';

import 'package:equran_app/app.dart';
import 'package:equran_app/core/notifications/background_sync_worker.dart';
import 'package:equran_app/core/providers.dart';
import 'package:equran_app/core/utils/hive_initializer.dart';
import 'package:equran_app/features/audio/data/datasources/audio_service_module.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInitializer.init();

  final container = ProviderContainer();

  await container.read(notificationServiceProvider).init();
  await BackgroundSyncWorker.init();
  await AudioServiceModule.init();

  unawaited(
    container.read(shalatNotifSchedulerServiceProvider).initAndSchedule(),
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
  // Izin notifikasi diminta dari onboarding slide 2, bukan di sini.
}
