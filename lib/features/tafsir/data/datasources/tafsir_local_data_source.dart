import 'dart:convert';

import 'package:equran_app/features/tafsir/data/models/tafsir_dto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class TafsirLocalDataSource {
  Future<TafsirDataDto?> getCachedTafsir(int nomor);
  Future<void> cacheTafsir(int nomor, TafsirDataDto tafsir);
}

@LazySingleton(as: TafsirLocalDataSource)
class TafsirLocalDataSourceImpl implements TafsirLocalDataSource {
  const TafsirLocalDataSourceImpl(@Named('tafsirBox') this._box);

  final Box<dynamic> _box;

  String _key(int nomor) => 'tafsir_$nomor';

  @override
  Future<TafsirDataDto?> getCachedTafsir(int nomor) async {
    try {
      final raw = _box.get(_key(nomor));
      if (raw == null) return null;
      return TafsirDataDto.fromJson(
        jsonDecode(raw as String) as Map<String, dynamic>,
      );
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheTafsir(int nomor, TafsirDataDto tafsir) async {
    await _box.put(_key(nomor), jsonEncode(tafsir.toJson()));
  }
}
