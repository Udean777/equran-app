import 'dart:convert';

import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class ShalatNotifPrefsDataSource {
  Future<ShalatNotifPrefs> getPrefs();
  Future<void> savePrefs(ShalatNotifPrefs prefs);
}

@LazySingleton(as: ShalatNotifPrefsDataSource)
class ShalatNotifPrefsDataSourceImpl implements ShalatNotifPrefsDataSource {
  const ShalatNotifPrefsDataSourceImpl(
    @Named('settingsBox') this._box,
  );

  final Box<dynamic> _box;

  static const _key = 'shalat_notif_prefs';

  @override
  Future<ShalatNotifPrefs> getPrefs() async {
    try {
      final raw = _box.get(_key) as String?;
      if (raw == null) return const ShalatNotifPrefs();
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return ShalatNotifPrefs(
        subuh: map['subuh'] as bool? ?? true,
        dzuhur: map['dzuhur'] as bool? ?? true,
        ashar: map['ashar'] as bool? ?? true,
        maghrib: map['maghrib'] as bool? ?? true,
        isya: map['isya'] as bool? ?? true,
        menitSebelum: map['menitSebelum'] as int? ?? 0,
      );
    } on Object catch (_) {
      return const ShalatNotifPrefs();
    }
  }

  @override
  Future<void> savePrefs(ShalatNotifPrefs prefs) async {
    final map = {
      'subuh': prefs.subuh,
      'dzuhur': prefs.dzuhur,
      'ashar': prefs.ashar,
      'maghrib': prefs.maghrib,
      'isya': prefs.isya,
      'menitSebelum': prefs.menitSebelum,
    };
    await _box.put(_key, jsonEncode(map));
  }
}
