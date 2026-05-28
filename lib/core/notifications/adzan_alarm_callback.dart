import 'dart:async';
import 'dart:ui';

import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// Top-level callback untuk AndroidAlarmManager.
/// Dipanggil di background isolate saat waktu shalat tiba.
/// Harus top-level function dan di-annotate @pragma('vm:entry-point').
@pragma('vm:entry-point')
Future<void> playAdzanCallback(int id, Map<String, dynamic> params) async {
  // Init Flutter binding di isolate baru
  WidgetsFlutterBinding.ensureInitialized();

  // Pastikan platform channels tersedia di background isolate
  DartPluginRegistrant.ensureInitialized();

  final isSubuh = params['isSubuh'] as bool? ?? false;
  final waktuNama = params['nama'] as String? ?? 'Shalat';

  debugPrint(
    'playAdzanCallback: id=$id, waktu=$waktuNama, isSubuh=$isSubuh',
  );

  try {
    // Init Hive sebelum DI karena DI depend pada Hive boxes (preResolve)
    await Hive.initFlutter();

    // Init DI jika belum (isolate baru tidak punya state dari main isolate)
    await configureDependencies();

    // 1. Tampilkan notifikasi teks sesegera mungkin ketika alarm masuk
    final notifService = getIt<NotificationService>();
    await notifService.showNotification(
      id: id,
      title: isSubuh ? '🌅 Waktu Subuh' : '☀️ Waktu $waktuNama',
      body: 'Sudah masuk waktu shalat $waktuNama',
    );

    // 2. Coba putar audio adzan (jika gagal, notifikasi visual sudah berhasil ditampilkan)
    try {
      final handler = getIt<AudioCompositeHandler>();
      await handler.playAdzan(isSubuh: isSubuh, waktuNama: waktuNama);
    } on Object catch (audioError) {
      debugPrint('playAdzanCallback audio playback error: $audioError');
    }
  } on Object catch (e) {
    debugPrint('playAdzanCallback error: $e');
  }
}
