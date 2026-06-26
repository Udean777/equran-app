import 'dart:convert';

import 'package:equran_app/features/catatan_ayat/data/models/catatan_ayat_dto.dart';
import 'package:hive_ce/hive.dart';

abstract interface class CatatanAyatLocalDataSource {
  Future<List<CatatanAyatDto>> getAll();
  Future<CatatanAyatDto?> getByAyat({
    required int suratNomor,
    required int ayatNomor,
  });
  Future<void> save(CatatanAyatDto catatan);
  Future<void> delete({required int suratNomor, required int ayatNomor});
}

class CatatanAyatLocalDataSourceImpl implements CatatanAyatLocalDataSource {
  const CatatanAyatLocalDataSourceImpl(this._box);

  final Box<String> _box;

  String _key(int suratNomor, int ayatNomor) => '$suratNomor:$ayatNomor';

  @override
  Future<List<CatatanAyatDto>> getAll() async {
    final keys = _box.keys
        .whereType<String>()
        .where((k) => k.contains(':'))
        .toList();

    final results = <CatatanAyatDto>[];
    for (final key in keys) {
      final raw = _box.get(key);
      if (raw == null) continue;
      try {
        results.add(
          CatatanAyatDto.fromJson(
            jsonDecode(raw) as Map<String, dynamic>,
          ),
        );
      } on Object catch (_) {
        continue;
      }
    }
    results.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return results;
  }

  @override
  Future<CatatanAyatDto?> getByAyat({
    required int suratNomor,
    required int ayatNomor,
  }) async {
    final raw = _box.get(_key(suratNomor, ayatNomor));
    if (raw == null) return null;
    return CatatanAyatDto.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> save(CatatanAyatDto catatan) async {
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
