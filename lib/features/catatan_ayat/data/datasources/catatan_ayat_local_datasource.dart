import 'dart:convert';

import 'package:equran_app/features/catatan_ayat/domain/entities/catatan_ayat.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class CatatanAyatLocalDatasource {
  Future<List<CatatanAyat>> getAll();
  Future<CatatanAyat?> getByAyat({
    required int suratNomor,
    required int ayatNomor,
  });
  Future<void> save(CatatanAyat catatan);
  Future<void> delete({required int suratNomor, required int ayatNomor});
}

@LazySingleton(as: CatatanAyatLocalDatasource)
class CatatanAyatLocalDatasourceImpl implements CatatanAyatLocalDatasource {
  const CatatanAyatLocalDatasourceImpl(@Named('catatanBox') this._box);

  final Box<String> _box;

  /// Key format: "$suratNomor:$ayatNomor"
  String _key(int suratNomor, int ayatNomor) => '$suratNomor:$ayatNomor';

  @override
  Future<List<CatatanAyat>> getAll() async {
    try {
      // Iterasi berbasis key (lebih efisien dari box.values yang load semua)
      final keys = _box.keys
          .whereType<String>()
          .where((k) => k.contains(':'))
          .toList();

      final results = <CatatanAyat>[];
      for (final key in keys) {
        final raw = _box.get(key);
        if (raw == null) continue;
        try {
          results.add(
            CatatanAyat.fromJson(jsonDecode(raw) as Map<String, dynamic>),
          );
        } on Object catch (_) {
          continue;
        }
      }
      results.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      return results;
    } on Object catch (_) {
      return [];
    }
  }

  @override
  Future<CatatanAyat?> getByAyat({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    try {
      final raw = _box.get(_key(suratNomor, ayatNomor));
      if (raw == null) return null;
      return CatatanAyat.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(CatatanAyat catatan) async {
    await _box.put(
      _key(catatan.suratNomor, catatan.ayatNomor),
      jsonEncode(catatan.toJson()),
    );
  }

  @override
  Future<void> delete({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    await _box.delete(_key(suratNomor, ayatNomor));
  }
}
