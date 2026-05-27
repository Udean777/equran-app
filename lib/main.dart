import 'dart:async';

import 'package:equran_app/app.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/shalat_notif_cubit.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await configureDependencies();
  await getIt<NotificationService>().init();
  // Jadwalkan notifikasi shalat saat app start menggunakan lokasi terakhir.
  // Fire-and-forget — tidak block UI.
  unawaited(getIt<ShalatNotifCubit>().initAndSchedule());
  runApp(const App());

  // Minta izin notifikasi secara aman setelah frame pertama dirender.
  // Ini krusial bagi iOS agar dialog izin dapat muncul (tidak terblokir OS).
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(getIt<NotificationService>().requestPermission());
  });
}
