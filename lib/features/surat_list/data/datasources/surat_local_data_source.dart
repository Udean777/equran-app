import 'dart:convert';

import 'package:equran_app/features/surat_list/data/models/surat_dto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class SuratLocalDataSource {
  Future<List<SuratDto>?> getCachedSuratList();
  Future<void> cacheSuratList(List<SuratDto> surats);
}

@LazySingleton(as: SuratLocalDataSource)
class SuratLocalDataSourceImpl implements SuratLocalDataSource {
  const SuratLocalDataSourceImpl(@Named('suratBox') this._box);

  final Box<dynamic> _box;

  static const _suratListKey = 'surat_list';

  @override
  Future<List<SuratDto>?> getCachedSuratList() async {
    try {
      final raw = _box.get(_suratListKey);
      if (raw == null) return null;
      final list = jsonDecode(raw as String) as List<dynamic>;
      return list
          .map((e) => SuratDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheSuratList(List<SuratDto> surats) async {
    final encoded = jsonEncode(
      surats.map((e) => e.toJson()).toList(),
    );
    await _box.put(_suratListKey, encoded);
  }
}
