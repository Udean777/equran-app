import 'dart:convert';

import 'package:equran_app/core/constants/quran_constants.dart';
import 'package:equran_app/features/hafalan/data/models/hafalan_surat_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

abstract interface class HafalanLocalDatasource {
  Future<List<HafalanSuratDto>> getAll();
  Future<HafalanSuratDto?> getBySurat(int suratNomor);
  Future<void> save(HafalanSuratDto hafalan);
  Future<void> delete(int suratNomor);
}

class HafalanLocalDatasourceImpl implements HafalanLocalDatasource {
  const HafalanLocalDatasourceImpl(this._box);

  final Box<String> _box;

  /// Key format: "surat_$suratNomor"
  String _key(int suratNomor) => 'surat_$suratNomor';

  @override
  Future<List<HafalanSuratDto>> getAll() async {
    try {
      // Iterasi key surat_1 s/d surat_114 — lebih efisien dari box.values
      final results = <HafalanSuratDto>[];
      for (var i = 1; i <= QuranConstants.totalSurat; i++) {
        final raw = _box.get(_key(i));
        if (raw == null) continue;
        try {
          final decoded = jsonDecode(raw);
          if (decoded is! Map<String, dynamic>) {
            debugPrint('HafalanLocalDatasource: skip surat $i — type error');
            continue;
          }
          results.add(HafalanSuratDto.fromJson(decoded));
        } on Object catch (e, st) {
          debugPrint('HafalanLocalDatasource: skip surat $i — $e\n$st');
          continue;
        }
      }
      // Sudah terurut karena iterasi 1-114, tidak perlu sort
      return results;
    } on Object catch (e, st) {
      debugPrint('HafalanLocalDatasource.getAll error: $e\n$st');
      throw Exception(e.toString());
    }
  }

  @override
  Future<HafalanSuratDto?> getBySurat(int suratNomor) async {
    try {
      final raw = _box.get(_key(suratNomor));
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        debugPrint(
          'HafalanLocalDatasource.getBySurat type error: expected Map',
        );
        return null;
      }
      return HafalanSuratDto.fromJson(decoded);
    } on FormatException catch (e, st) {
      debugPrint('HafalanLocalDatasource.getBySurat format error: $e\n$st');
      return null;
    } on Object catch (e, st) {
      debugPrint('HafalanLocalDatasource.getBySurat error: $e\n$st');
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> save(HafalanSuratDto hafalan) async {
    await _box.put(_key(hafalan.suratNomor), jsonEncode(hafalan.toJson()));
  }

  @override
  Future<void> delete(int suratNomor) async {
    await _box.delete(_key(suratNomor));
  }
}
