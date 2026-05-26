import 'dart:convert';

import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveImsakAlarmPrefs {
  const SaveImsakAlarmPrefs(@Named('imsakiyahBox') this._box);

  final Box<String> _box;

  static const _key = 'imsak_alarm_prefs';

  Future<void> call(ImsakAlarmPrefs prefs) async {
    await _box.put(_key, jsonEncode(prefs.toJson()));
  }
}
