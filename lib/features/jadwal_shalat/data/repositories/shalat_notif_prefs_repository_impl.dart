import 'dart:convert';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/data/mappers/jadwal_shalat_mapper.dart';
import 'package:equran_app/features/jadwal_shalat/data/models/shalat_notif_prefs_dto.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/shalat_notif_prefs_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';

class ShalatNotifPrefsRepositoryImpl implements ShalatNotifPrefsRepository {
  const ShalatNotifPrefsRepositoryImpl(
    this._box,
  );

  final Box<String> _box;
  static const _key = 'shalat_notif_prefs';

  @override
  Future<Either<Failure, ShalatNotifPrefs>> getPrefs() async {
    try {
      final raw = _box.get(_key);
      if (raw == null) return right(const ShalatNotifPrefs());
      final dto = ShalatNotifPrefsDto.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      return right(dto.toEntity());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> savePrefs(ShalatNotifPrefs prefs) async {
    try {
      await _box.put(_key, jsonEncode(prefs.toDto().toJson()));
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
