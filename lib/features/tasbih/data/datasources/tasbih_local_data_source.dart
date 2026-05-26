import 'dart:convert';

import 'package:equran_app/features/tasbih/data/models/tasbih_session_dto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:synchronized/synchronized.dart';

abstract interface class TasbihLocalDataSource {
  Future<List<TasbihSessionDto>> getSessions();
  Future<void> saveSession(TasbihSessionDto session);
  Future<void> deleteSession(String id);
  Future<void> clearSessions();
}

@LazySingleton(as: TasbihLocalDataSource)
class TasbihLocalDataSourceImpl implements TasbihLocalDataSource {
  TasbihLocalDataSourceImpl(@Named('tasbihBox') this._box);

  final Box<String> _box;
  final _lock = Lock();

  static const _sessionsKey = 'tasbih_sessions';

  @override
  Future<List<TasbihSessionDto>> getSessions() async {
    try {
      final raw = _box.get(_sessionsKey);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => TasbihSessionDto.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } on Object catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveSession(TasbihSessionDto session) async {
    await _lock.synchronized(() async {
      final current = await _getSessionsRaw();
      current.add(session);
      await _box.put(
        _sessionsKey,
        jsonEncode(current.map((e) => e.toJson()).toList()),
      );
    });
  }

  @override
  Future<void> deleteSession(String id) async {
    await _lock.synchronized(() async {
      final current = await _getSessionsRaw();
      current.removeWhere((s) => s.id == id);
      await _box.put(
        _sessionsKey,
        jsonEncode(current.map((e) => e.toJson()).toList()),
      );
    });
  }

  @override
  Future<void> clearSessions() async {
    await _box.delete(_sessionsKey);
  }

  // Private helper — dipanggil hanya dari dalam lock
  Future<List<TasbihSessionDto>> _getSessionsRaw() async {
    try {
      final raw = _box.get(_sessionsKey);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => TasbihSessionDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object catch (_) {
      return [];
    }
  }
}
