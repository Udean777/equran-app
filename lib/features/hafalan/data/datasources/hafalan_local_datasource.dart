import 'dart:convert';

import 'package:equran_app/features/hafalan/data/mappers/hafalan_mapper.dart';
import 'package:equran_app/features/hafalan/data/models/hafalan_surat_dto.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class HafalanLocalDatasource {
  Future<List<HafalanSurat>> getAll();
  Future<HafalanSurat?> getBySurat(int suratNomor);
  Future<void> save(HafalanSurat hafalan);
  Future<void> delete(int suratNomor);
}

@LazySingleton(as: HafalanLocalDatasource)
class HafalanLocalDatasourceImpl implements HafalanLocalDatasource {
  const HafalanLocalDatasourceImpl(@Named('hafalanBox') this._box);

  final Box<String> _box;

  /// Key format: "surat_$suratNomor"
  String _key(int suratNomor) => 'surat_$suratNomor';

  @override
  Future<List<HafalanSurat>> getAll() async {
    try {
      // Iterasi key surat_1 s/d surat_114 — lebih efisien dari box.values
      final results = <HafalanSurat>[];
      for (var i = 1; i <= 114; i++) {
        final raw = _box.get(_key(i));
        if (raw == null) continue;
        try {
          final dto = HafalanSuratDto.fromJson(
            jsonDecode(raw) as Map<String, dynamic>,
          );
          results.add(dto.toEntity());
        } on Object catch (_) {
          continue;
        }
      }
      // Sudah terurut karena iterasi 1-114, tidak perlu sort
      return results;
    } on Object catch (_) {
      return [];
    }
  }

  @override
  Future<HafalanSurat?> getBySurat(int suratNomor) async {
    try {
      final raw = _box.get(_key(suratNomor));
      if (raw == null) return null;
      final dto = HafalanSuratDto.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      return dto.toEntity();
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(HafalanSurat hafalan) async {
    final dto = hafalan.toDto();
    await _box.put(_key(hafalan.suratNomor), jsonEncode(dto.toJson()));
  }

  @override
  Future<void> delete(int suratNomor) async {
    await _box.delete(_key(suratNomor));
  }
}
