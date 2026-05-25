import 'package:equran_app/features/surat_list/data/mappers/surat_mapper.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_data.dart';

void main() {
  group('SuratDtoMapper', () {
    test('toEntity() map semua field dengan benar', () {
      final result = tSuratDto.toEntity();

      expect(result.nomor, 1);
      expect(result.nama, 'الفاتحة');
      expect(result.namaLatin, 'Al-Fatihah');
      expect(result.jumlahAyat, 7);
      expect(result.tempatTurun, TempatTurun.mekah);
      expect(result.arti, 'Pembukaan');
    });

    test('toEntity() map tempatTurun Madinah dengan benar', () {
      final result = tSuratDto2.toEntity();
      expect(result.tempatTurun, TempatTurun.madinah);
    });

    test('toEntity() fallback ke mekah untuk tempatTurun tidak dikenal', () {
      final dto = tSuratDto.copyWith(tempatTurun: 'unknown');
      final result = dto.toEntity();
      expect(result.tempatTurun, TempatTurun.mekah);
    });

    test('toEntity() case-insensitive untuk tempatTurun', () {
      final dto = tSuratDto.copyWith(tempatTurun: 'MEKAH');
      final result = dto.toEntity();
      expect(result.tempatTurun, TempatTurun.mekah);
    });
  });
}
