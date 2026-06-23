import 'dart:convert';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/imsakiyah/data/mappers/imsakiyah_mapper.dart';
import 'package:equran_app/features/imsakiyah/data/models/imsak_alarm_prefs_dto.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsak_alarm_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ImsakAlarmRepository)
class ImsakAlarmRepositoryImpl implements ImsakAlarmRepository {
  const ImsakAlarmRepositoryImpl(@Named('imsakiyahBox') this._box);

  final Box<String> _box;

  static const _key = 'imsak_alarm_prefs';

  @override
  Future<Either<Failure, ImsakAlarmPrefs>> getPrefs() async {
    try {
      final raw = _box.get(_key);
      if (raw == null) return right(const ImsakAlarmPrefs());
      final dto = ImsakAlarmPrefsDto.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      return right(dto.toEntity());
    } on Object catch (_) {
      return right(const ImsakAlarmPrefs());
    }
  }

  @override
  Future<Either<Failure, Unit>> savePrefs(ImsakAlarmPrefs prefs) async {
    try {
      await _box.put(_key, jsonEncode(prefs.toDto().toJson()));
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
