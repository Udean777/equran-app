import 'package:equran_app/features/tafsir/data/mappers/tafsir_mapper.dart';
import 'package:equran_app/features/tafsir/data/models/tafsir_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_data.dart';

void main() {
  group('TafsirDataDtoMapper', () {
    test('toEntity() map semua field dengan benar', () {
      final result = tTafsirDataDto.toEntity();

      expect(result.info.nomor, 1);
      expect(result.info.namaLatin, 'Al-Fatihah');
      expect(result.tafsirList.length, 1);
    });
  });

  group('TafsirAyatDtoMapper', () {
    test('toEntity() map nomorAyat dari field ayat', () {
      final result = tTafsirAyatDto.toEntity();
      expect(result.nomorAyat, 1);
    });

    test('toEntity() strip HTML dari teks tafsir', () {
      final result = tTafsirAyatDto.toEntity();
      expect(result.teks, 'Tafsir ayat pertama Al-Fatihah.');
      expect(result.teks.contains('<p>'), isFalse);
    });

    test('toEntity() strip HTML kompleks', () {
      const dto = TafsirAyatDto(
        ayat: 2,
        teks: '<p><b>Tafsir</b> dengan <i>format</i> HTML.</p>',
      );
      final result = dto.toEntity();
      expect(result.teks, 'Tafsir dengan format HTML.');
    });
  });
}
