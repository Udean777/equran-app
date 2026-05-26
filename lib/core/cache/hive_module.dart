import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@module
abstract class HiveModule {
  // LazyBox untuk data besar — hanya dimuat ke memory saat diakses
  @preResolve
  @Named('suratBox')
  Future<LazyBox<String>> suratBox() => Hive.openLazyBox<String>('surat_box');

  @preResolve
  @Named('tafsirBox')
  Future<LazyBox<String>> tafsirBox() => Hive.openLazyBox<String>('tafsir_box');

  @preResolve
  @Named('doaBox')
  Future<LazyBox<String>> doaBox() => Hive.openLazyBox<String>('doa_box');

  // Regular Box untuk data kecil yang sering diakses
  @preResolve
  @Named('settingsBox')
  Future<Box<String>> settingsBox() => Hive.openBox<String>('settings_box');

  @preResolve
  @Named('bookmarkBox')
  Future<Box<String>> bookmarkBox() => Hive.openBox<String>('bookmark_box');

  @preResolve
  @Named('imsakiyahBox')
  Future<Box<String>> imsakiyahBox() => Hive.openBox<String>('imsakiyah_box');

  @preResolve
  @Named('shalatBox')
  Future<Box<String>> shalatBox() => Hive.openBox<String>('shalat_box');

  @preResolve
  @Named('tasbihBox')
  Future<Box<String>> tasbihBox() => Hive.openBox<String>('tasbih_box');

  @preResolve
  @Named('doaBookmarkBox')
  Future<Box<String>> doaBookmarkBox() =>
      Hive.openBox<String>('doa_bookmark_box');

  @preResolve
  @Named('catatanBox')
  Future<Box<String>> catatanBox() => Hive.openBox<String>('catatan_box');

  @preResolve
  @Named('hafalanBox')
  Future<Box<String>> hafalanBox() => Hive.openBox<String>('hafalan_box');

  @preResolve
  @Named('statistikShalatBox')
  Future<Box<String>> statistikShalatBox() =>
      Hive.openBox<String>('statistik_shalat_box');

  @preResolve
  @Named('readingHistoryBox')
  Future<Box<String>> readingHistoryBox() =>
      Hive.openBox<String>('reading_history_box');
}
