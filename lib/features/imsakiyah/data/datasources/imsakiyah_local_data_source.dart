import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/imsakiyah/data/models/imsakiyah_dto.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

abstract interface class ImsakiyahLocalDataSource {
  Future<List<String>?> getCachedProvinsi();
  Future<void> cacheProvinsi(List<String> provinsi);

  Future<List<String>?> getCachedKabkota(String provinsi);
  Future<void> cacheKabkota(String provinsi, List<String> kabkota);

  Future<ImsakiyahDto?> getCachedImsakiyah(String provinsi, String kabkota);
  Future<void> cacheImsakiyah(ImsakiyahDto dto);

  Future<String?> getLastProvinsi();
  Future<void> saveLastProvinsi(String provinsi);
  Future<String?> getLastKabkota();
  Future<void> saveLastKabkota(String kabkota);
}

@LazySingleton(as: ImsakiyahLocalDataSource)
class ImsakiyahLocalDataSourceImpl implements ImsakiyahLocalDataSource {
  const ImsakiyahLocalDataSourceImpl(
    @Named('imsakiyahBox') this._box,
  );

  final Box<String> _box;

  static const _provinsiKey = 'provinsi_list';
  static const _lastProvinsiKey = 'last_provinsi';
  static const _lastKabkotaKey = 'last_kabkota';

  // Cache TTL: 30 hari untuk provinsi/kabkota, 1 hari untuk jadwal
  static const _longTtl = Duration(days: 30);
  static const _shortTtl = Duration(days: 1);

  String _kabkotaKey(String provinsi) =>
      'kabkota_${provinsi.replaceAll(' ', '_')}';

  String _imsakiyahKey(String provinsi, String kabkota) =>
      'imsakiyah_${provinsi.replaceAll(' ', '_')}_${kabkota.replaceAll(' ', '_')}';

  @override
  Future<List<String>?> getCachedProvinsi() async {
    try {
      final entry = CacheEntry.decode(_box.get(_provinsiKey));
      if (entry == null) return null;
      if (DateTime.now().difference(entry.cachedAt) > _longTtl) return null;
      return (jsonDecode(entry.data) as List<dynamic>).cast<String>();
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheProvinsi(List<String> provinsi) async {
    final entry = CacheEntry(
      data: jsonEncode(provinsi),
      cachedAt: DateTime.now(),
    );
    await _box.put(_provinsiKey, entry.encode());
  }

  @override
  Future<List<String>?> getCachedKabkota(String provinsi) async {
    try {
      final entry = CacheEntry.decode(_box.get(_kabkotaKey(provinsi)));
      if (entry == null) return null;
      if (DateTime.now().difference(entry.cachedAt) > _longTtl) return null;
      return (jsonDecode(entry.data) as List<dynamic>).cast<String>();
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheKabkota(String provinsi, List<String> kabkota) async {
    final entry = CacheEntry(
      data: jsonEncode(kabkota),
      cachedAt: DateTime.now(),
    );
    await _box.put(_kabkotaKey(provinsi), entry.encode());
  }

  @override
  Future<ImsakiyahDto?> getCachedImsakiyah(
    String provinsi,
    String kabkota,
  ) async {
    try {
      final entry = CacheEntry.decode(
        _box.get(_imsakiyahKey(provinsi, kabkota)),
      );
      if (entry == null) return null;
      if (DateTime.now().difference(entry.cachedAt) > _shortTtl) return null;
      return ImsakiyahDto.fromJson(
        jsonDecode(entry.data) as Map<String, dynamic>,
      );
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheImsakiyah(ImsakiyahDto dto) async {
    final entry = CacheEntry(
      data: jsonEncode(dto.toJson()),
      cachedAt: DateTime.now(),
    );
    await _box.put(_imsakiyahKey(dto.provinsi, dto.kabkota), entry.encode());
  }

  @override
  Future<String?> getLastProvinsi() async => _box.get(_lastProvinsiKey);

  @override
  Future<void> saveLastProvinsi(String provinsi) async =>
      _box.put(_lastProvinsiKey, provinsi);

  @override
  Future<String?> getLastKabkota() async => _box.get(_lastKabkotaKey);

  @override
  Future<void> saveLastKabkota(String kabkota) async =>
      _box.put(_lastKabkotaKey, kabkota);
}
