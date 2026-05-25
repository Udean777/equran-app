import 'package:equran_app/features/surat_detail/data/mappers/surat_detail_mapper.dart';
import 'package:equran_app/features/surat_detail/data/models/surat_detail_dto.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_data.dart';

void main() {
  group('SuratDetailDtoMapper', () {
    test('toEntity() map semua field dengan benar', () {
      final result = tSuratDetailDto.toEntity();

      expect(result.info.nomor, 1);
      expect(result.info.namaLatin, 'Al-Fatihah');
      expect(result.info.tempatTurun, TempatTurun.mekah);
      expect(result.ayatList.length, 1);
      expect(result.suratSelanjutnya?.nomor, 2);
      expect(result.suratSebelumnya, isNull);
    });

    test('toEntity() strip HTML dari deskripsi', () {
      final result = tSuratDetailDto.toEntity();
      expect(result.deskripsi, 'Surat Al-Fatihah adalah surat pertama.');
      expect(result.deskripsi.contains('<p>'), isFalse);
    });

    test('toEntity() suratSebelumnya null ketika false dari API', () {
      // Simulasi edge case: suratSebelumnya = false dari API
      const converter = SuratNavOrFalseConverter();
      final result = converter.fromJson(false);
      expect(result, isNull);
    });

    test('toEntity() suratSebelumnya null ketika null dari API', () {
      const converter = SuratNavOrFalseConverter();
      final result = converter.fromJson(null);
      expect(result, isNull);
    });

    test('toEntity() suratSebelumnya parse object dengan benar', () {
      const converter = SuratNavOrFalseConverter();
      final result = converter.fromJson({
        'nomor': 1,
        'namaLatin': 'Al-Fatihah',
        'jumlahAyat': 7,
      });
      expect(result?.nomor, 1);
      expect(result?.namaLatin, 'Al-Fatihah');
    });
  });

  group('AyatDtoMapper', () {
    test('toEntity() map semua field dengan benar', () {
      final result = tAyatDto.toEntity();

      expect(result.nomorAyat, 1);
      expect(result.teksArab, 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ');
      expect(result.teksLatin, 'bismillāhir-raḥmānir-raḥīm');
      expect(result.audio.isNotEmpty, isTrue);
    });
  });
}
