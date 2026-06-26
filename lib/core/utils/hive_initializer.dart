import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveInitializer {
  static Future<void> init() async {
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
  }
}
