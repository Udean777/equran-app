import 'package:equran_app/features/imsakiyah/data/models/imsakiyah_dto.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';

extension ImsakiyahEntryDtoX on ImsakiyahEntryDto {
  ImsakiyahEntry toEntity() => ImsakiyahEntry(
    tanggal: tanggal,
    imsak: imsak,
    subuh: subuh,
    terbit: terbit,
    dhuha: dhuha,
    dzuhur: dzuhur,
    ashar: ashar,
    maghrib: maghrib,
    isya: isya,
  );
}

extension ImsakiyahDtoX on ImsakiyahDto {
  Imsakiyah toEntity() => Imsakiyah(
    provinsi: provinsi,
    kabkota: kabkota,
    hijriah: hijriah,
    masehi: masehi,
    imsakiyah: imsakiyah.map((e) => e.toEntity()).toList(),
  );
}
