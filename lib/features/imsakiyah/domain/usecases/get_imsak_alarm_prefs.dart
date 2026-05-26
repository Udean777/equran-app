import 'dart:convert';

import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetImsakAlarmPrefs {
  const GetImsakAlarmPrefs(@Named('imsakiyahBox') this._box);

  final Box<String> _box;

  static const _key = 'imsak_alarm_prefs';

  Future<ImsakAlarmPrefs> call() async {
    try {
      final raw = _box.get(_key);
      if (raw == null) return const ImsakAlarmPrefs();
      return ImsakAlarmPrefs.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } on Object catch (_) {
      return const ImsakAlarmPrefs();
    }
  }
}
