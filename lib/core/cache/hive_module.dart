import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@module
abstract class HiveModule {
  @preResolve
  @Named('suratBox')
  Future<Box<dynamic>> suratBox() => Hive.openBox<dynamic>('surat_box');

  @preResolve
  @Named('tafsirBox')
  Future<Box<dynamic>> tafsirBox() => Hive.openBox<dynamic>('tafsir_box');
}
