import 'dart:convert';

import 'package:equran_app/features/surat_detail/data/models/surat_detail_dto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class SuratDetailLocalDataSource {
  Future<SuratDetailDto?> getCachedSuratDetail(int nomor);
  Future<void> cacheSuratDetail(int nomor, SuratDetailDto detail);
}

@LazySingleton(as: SuratDetailLocalDataSource)
class SuratDetailLocalDataSourceImpl implements SuratDetailLocalDataSource {
  const SuratDetailLocalDataSourceImpl(@Named('suratBox') this._box);

  final Box<dynamic> _box;

  String _key(int nomor) => 'surat_detail_$nomor';

  @override
  Future<SuratDetailDto?> getCachedSuratDetail(int nomor) async {
    try {
      final raw = _box.get(_key(nomor));
      if (raw == null) return null;
      return SuratDetailDto.fromJson(
        jsonDecode(raw as String) as Map<String, dynamic>,
      );
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheSuratDetail(int nomor, SuratDetailDto detail) async {
    await _box.put(_key(nomor), jsonEncode(detail.toJson()));
  }
}
