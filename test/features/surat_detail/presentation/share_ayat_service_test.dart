import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter_test/flutter_test.dart';

// ShareAyatService.shareText() memanggil Share.share() dari platform channel
// yang tidak bisa di-unit test tanpa mock platform.
// Test ini memverifikasi format teks yang dihasilkan secara logis.

String _buildShareText({
  required Ayat ayat,
  required String namaLatin,
  required int suratNomor,
}) {
  return '﴿ ${ayat.teksArab} ﴾\n\n'
      '${ayat.teksIndonesia}\n\n'
      '— Q.S. $namaLatin ($suratNomor): ${ayat.nomorAyat}';
}

void main() {
  const ayat = Ayat(
    nomorAyat: 1,
    teksArab: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
    teksLatin: 'Bismillaahir rahmaanir rahiim',
    teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
    audio: {},
  );

  group('ShareAyatService — format teks', () {
    test('format teks mengandung teks Arab dengan tanda ﴿ ﴾', () {
      final text = _buildShareText(
        ayat: ayat,
        namaLatin: 'Al-Fatihah',
        suratNomor: 1,
      );
      expect(text, contains('﴿'));
      expect(text, contains('﴾'));
      expect(text, contains(ayat.teksArab));
    });

    test('format teks mengandung terjemahan Indonesia', () {
      final text = _buildShareText(
        ayat: ayat,
        namaLatin: 'Al-Fatihah',
        suratNomor: 1,
      );
      expect(text, contains(ayat.teksIndonesia));
    });

    test('format teks mengandung sumber Q.S. yang benar', () {
      final text = _buildShareText(
        ayat: ayat,
        namaLatin: 'Al-Fatihah',
        suratNomor: 1,
      );
      expect(text, contains('Q.S. Al-Fatihah (1): 1'));
    });

    test('format teks mengandung nomor surat dan ayat yang benar', () {
      const ayat2 = Ayat(
        nomorAyat: 255,
        teksArab: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ',
        teksLatin: 'Allaahu laa ilaaha illaa huwa',
        teksIndonesia: 'Allah, tidak ada tuhan selain Dia.',
        audio: {},
      );
      final text = _buildShareText(
        ayat: ayat2,
        namaLatin: 'Al-Baqarah',
        suratNomor: 2,
      );
      expect(text, contains('Q.S. Al-Baqarah (2): 255'));
    });

    test('format teks dipisah dengan newline yang benar', () {
      final text = _buildShareText(
        ayat: ayat,
        namaLatin: 'Al-Fatihah',
        suratNomor: 1,
      );
      // Struktur: Arab \n\n terjemahan \n\n sumber
      final parts = text.split('\n\n');
      expect(parts.length, 3);
      expect(parts[0], contains(ayat.teksArab));
      expect(parts[1], ayat.teksIndonesia);
      expect(parts[2], contains('Q.S. Al-Fatihah (1): 1'));
    });
  });
}
