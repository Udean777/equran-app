import 'dart:convert';

import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:hive_ce/hive.dart';

abstract interface class QuranReminderPrefsDataSource {
  Future<QuranReminderPrefs> getPrefs();
  Future<void> savePrefs(QuranReminderPrefs prefs);
}

class QuranReminderPrefsDataSourceImpl implements QuranReminderPrefsDataSource {
  const QuranReminderPrefsDataSourceImpl(
    this._box,
  );

  final Box<String> _box;

  static const _key = 'quran_reminder_prefs';

  @override
  Future<QuranReminderPrefs> getPrefs() async {
    final raw = _box.get(_key);
    if (raw == null) return const QuranReminderPrefs();
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return QuranReminderPrefs(
      enabled: map['enabled'] as bool? ?? false,
      hour: map['hour'] as int? ?? 20,
      minute: map['minute'] as int? ?? 0,
    );
  }

  @override
  Future<void> savePrefs(QuranReminderPrefs prefs) async {
    final map = {
      'enabled': prefs.enabled,
      'hour': prefs.hour,
      'minute': prefs.minute,
    };
    await _box.put(_key, jsonEncode(map));
  }
}
