import 'dart:convert';

import 'package:equran_app/core/cache/cache_config.dart';

/// Wrapper cache entry dengan timestamp untuk TTL check.
class CacheEntry {
  const CacheEntry({
    required this.data,
    required this.cachedAt,
  });

  factory CacheEntry.fromJson(Map<String, dynamic> json) => CacheEntry(
    data: json['data'] as String,
    cachedAt: DateTime.parse(json['cachedAt'] as String),
  );

  /// JSON string dari data yang di-cache.
  final String data;

  /// Waktu saat data di-cache.
  final DateTime cachedAt;

  /// Return true jika cache sudah melewati TTL.
  bool get isExpired => DateTime.now().difference(cachedAt) > CacheConfig.ttl;

  Map<String, dynamic> toJson() => {
    'data': data,
    'cachedAt': cachedAt.toIso8601String(),
  };

  /// Encode CacheEntry ke string untuk disimpan di Hive.
  String encode() => jsonEncode(toJson());

  /// Decode string dari Hive ke CacheEntry.
  /// Return null jika format tidak valid.
  static CacheEntry? decode(Object? raw) {
    if (raw == null) return null;
    try {
      return CacheEntry.fromJson(
        jsonDecode(raw as String) as Map<String, dynamic>,
      );
    } on Object catch (_) {
      return null;
    }
  }
}
