import 'dart:async';
import 'dart:ui';

import 'package:equran_app/features/audio/data/datasources/audio_background_handler.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/widgets.dart';

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
    // Init DI jika belum (isolate baru tidak punya state dari main isolate)
    await configureDependencies();

    final handler = getIt<AudioCompositeHandler>();
    await handler.playAdzan(isSubuh: isSubuh, waktuNama: waktuNama);
  } on Object catch (e) {
    debugPrint('playAdzanCallback error: $e');
  }
}
