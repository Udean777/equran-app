import 'package:equran_app/core/cache/cache_config.dart';
import 'package:equran_app/core/cache/cache_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CacheEntry', () {
    test('isExpired return false untuk cache baru', () {
      final entry = CacheEntry(
        data: '{"test": 1}',
        cachedAt: DateTime.now(),
      );
      expect(entry.isExpired, isFalse);
    });

    test('isExpired return true untuk cache lebih dari TTL', () {
      final entry = CacheEntry(
        data: '{"test": 1}',
        cachedAt: DateTime.now().subtract(
          CacheConfig.ttl + const Duration(seconds: 1),
        ),
      );
      expect(entry.isExpired, isTrue);
    });

    test('isExpired return false tepat di batas TTL', () {
      final entry = CacheEntry(
        data: '{"test": 1}',
        cachedAt: DateTime.now().subtract(
          CacheConfig.ttl - const Duration(seconds: 1),
        ),
      );
      expect(entry.isExpired, isFalse);
    });

    test('encode() dan decode() round-trip berhasil', () {
      final original = CacheEntry(
        data: '{"nomor": 1}',
        cachedAt: DateTime(2025, 1, 1, 12),
      );
      final encoded = original.encode();
      final decoded = CacheEntry.decode(encoded);

      expect(decoded, isNotNull);
      expect(decoded!.data, original.data);
      expect(decoded.cachedAt, original.cachedAt);
    });

    test('decode() return null untuk input null', () {
      expect(CacheEntry.decode(null), isNull);
    });

    test('decode() return null untuk JSON tidak valid', () {
      expect(CacheEntry.decode('invalid_json'), isNull);
    });

    test('decode() return null untuk JSON tanpa field yang dibutuhkan', () {
      expect(CacheEntry.decode('{"foo": "bar"}'), isNull);
    });

    test('toJson() dan fromJson() round-trip berhasil', () {
      final original = CacheEntry(
        data: '{"test": true}',
        cachedAt: DateTime(2025, 6, 15, 10, 30),
      );
      final json = original.toJson();
      final restored = CacheEntry.fromJson(json);

      expect(restored.data, original.data);
      expect(restored.cachedAt, original.cachedAt);
    });
  });

  group('CacheConfig', () {
    test('TTL adalah 7 hari', () {
      expect(CacheConfig.ttl, const Duration(days: 7));
    });
  });
}
