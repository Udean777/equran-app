import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LastRead entity', () {
    test('default scrollPercent adalah 0.0', () {
      final lastRead = LastRead(
        suratNomor: 1,
        ayatNomor: 1,
        namaLatin: 'Al-Fatihah',
        readAt: DateTime(2025, 1, 1),
      );
      expect(lastRead.scrollPercent, 0.0);
    });

    test('default totalAyat adalah 0', () {
      final lastRead = LastRead(
        suratNomor: 1,
        ayatNomor: 1,
        namaLatin: 'Al-Fatihah',
        readAt: DateTime(2025, 1, 1),
      );
      expect(lastRead.totalAyat, 0);
    });

    test('scrollPercent tersimpan dengan benar', () {
      final lastRead = LastRead(
        suratNomor: 1,
        ayatNomor: 3,
        namaLatin: 'Al-Fatihah',
        readAt: DateTime(2025, 1, 1),
        scrollPercent: 3 / 7,
        totalAyat: 7,
      );
      expect(lastRead.scrollPercent, closeTo(0.4285, 0.001));
      expect(lastRead.totalAyat, 7);
    });

    test('copyWith update scrollPercent', () {
      final lastRead = LastRead(
        suratNomor: 1,
        ayatNomor: 1,
        namaLatin: 'Al-Fatihah',
        readAt: DateTime(2025, 1, 1),
      );
      final updated = lastRead.copyWith(scrollPercent: 0.5, totalAyat: 7);
      expect(updated.scrollPercent, 0.5);
      expect(updated.totalAyat, 7);
      // field lain tidak berubah
      expect(updated.suratNomor, 1);
      expect(updated.ayatNomor, 1);
    });

    test('scrollPercent 1.0 berarti surat selesai dibaca', () {
      final lastRead = LastRead(
        suratNomor: 1,
        ayatNomor: 7,
        namaLatin: 'Al-Fatihah',
        readAt: DateTime(2025, 1, 1),
        scrollPercent: 7 / 7,
        totalAyat: 7,
      );
      expect(lastRead.scrollPercent, 1.0);
    });

    test('equality — dua LastRead dengan nilai sama adalah equal', () {
      final a = LastRead(
        suratNomor: 1,
        ayatNomor: 3,
        namaLatin: 'Al-Fatihah',
        readAt: DateTime(2025, 1, 1),
        scrollPercent: 0.5,
        totalAyat: 7,
      );
      final b = LastRead(
        suratNomor: 1,
        ayatNomor: 3,
        namaLatin: 'Al-Fatihah',
        readAt: DateTime(2025, 1, 1),
        scrollPercent: 0.5,
        totalAyat: 7,
      );
      expect(a, equals(b));
    });
  });

  group('scrollPercent calculation', () {
    test('ayat 1 dari 7 = ~0.143', () {
      final percent = (1 / 7).clamp(0.0, 1.0);
      expect(percent, closeTo(0.143, 0.001));
    });

    test('ayat 7 dari 7 = 1.0', () {
      final percent = (7 / 7).clamp(0.0, 1.0);
      expect(percent, 1.0);
    });

    test('clamp tidak melebihi 1.0', () {
      final percent = (10 / 7).clamp(0.0, 1.0);
      expect(percent, 1.0);
    });

    test('clamp tidak kurang dari 0.0', () {
      final percent = (-1 / 7).clamp(0.0, 1.0);
      expect(percent, 0.0);
    });
  });
}
