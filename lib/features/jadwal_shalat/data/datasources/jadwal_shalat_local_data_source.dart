import 'dart:async';
import 'dart:convert';

import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:equran_app/features/jadwal_shalat/data/models/jadwal_shalat_dto.dart';
import 'package:hive_ce/hive.dart';

abstract interface class JadwalShalatLocalDataSource {
  Future<List<String>?> getCachedProvinsi();
  Future<void> cacheProvinsi(List<String> provinsi);

  Future<List<String>?> getCachedKabkota(String provinsi);
  Future<void> cacheKabkota(String provinsi, List<String> kabkota);

  Future<JadwalShalatDto?> getCachedJadwalShalat(
    String provinsi,
    String kabkota,
    int bulan,
    int tahun,
  );
  Future<void> cacheJadwalShalat(JadwalShalatDto dto);
}

class JadwalShalatLocalDataSourceImpl implements JadwalShalatLocalDataSource {
  const JadwalShalatLocalDataSourceImpl(
    this._box,
  );

  final Box<String> _box;

  static const _provinsiKey = 'provinsi_list';

  // Cache TTL: 30 hari untuk provinsi/kabkota, 1 hari untuk jadwal
  static const _longTtl = Duration(days: 30);
  static const _shortTtl = Duration(days: 1);

  String _kabkotaKey(String provinsi) =>
      'kabkota_${provinsi.replaceAll(' ', '_')}';

  String _jadwalKey(String provinsi, String kabkota, int bulan, int tahun) =>
      'shalat_${provinsi.replaceAll(' ', '_')}_${kabkota.replaceAll(' ', '_')}_${bulan}_$tahun';

  @override
  Future<List<String>?> getCachedProvinsi() => _safeCallAsync(() {
    final entry = CacheEntry.decode(_box.get(_provinsiKey));
    if (entry == null) return null;
    if (DateTime.now().difference(entry.cachedAt) > _longTtl) return null;
    return (jsonDecode(entry.data) as List<dynamic>).cast<String>();
  });

  @override
  Future<void> cacheProvinsi(List<String> provinsi) async {
    final entry = CacheEntry(
      data: jsonEncode(provinsi),
      cachedAt: DateTime.now(),
    );
    await _box.put(_provinsiKey, entry.encode());
  }

  @override
  Future<List<String>?> getCachedKabkota(String provinsi) => _safeCallAsync(() {
    final entry = CacheEntry.decode(_box.get(_kabkotaKey(provinsi)));
    if (entry == null) return null;
    if (DateTime.now().difference(entry.cachedAt) > _longTtl) return null;
    return (jsonDecode(entry.data) as List<dynamic>).cast<String>();
  });

  @override
  Future<void> cacheKabkota(String provinsi, List<String> kabkota) async {
    final entry = CacheEntry(
      data: jsonEncode(kabkota),
      cachedAt: DateTime.now(),
    );
    await _box.put(_kabkotaKey(provinsi), entry.encode());
  }

  @override
  Future<JadwalShalatDto?> getCachedJadwalShalat(
    String provinsi,
    String kabkota,
    int bulan,
    int tahun,
  ) => _safeCallAsync(() {
    final entry = CacheEntry.decode(
      _box.get(_jadwalKey(provinsi, kabkota, bulan, tahun)),
    );
    if (entry == null) return null;
    if (DateTime.now().difference(entry.cachedAt) > _shortTtl) return null;
    return JadwalShalatDto.fromJson(
      jsonDecode(entry.data) as Map<String, dynamic>,
    );
  });

  @override
  Future<void> cacheJadwalShalat(JadwalShalatDto dto) async {
    final entry = CacheEntry(
      data: jsonEncode(dto.toJson()),
      cachedAt: DateTime.now(),
    );
    await _box.put(
      _jadwalKey(dto.provinsi, dto.kabkota, dto.bulan, dto.tahun),
      entry.encode(),
    );
  }

  static Future<T?> _safeCallAsync<T>(T? Function() fn) async {
    try {
      return fn();
    } on Object catch (_) {
      return null;
    }
  }
}
