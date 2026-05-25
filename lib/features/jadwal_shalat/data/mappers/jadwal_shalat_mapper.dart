import 'package:equran_app/features/jadwal_shalat/data/models/jadwal_shalat_dto.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';

extension JadwalShalatEntryDtoX on JadwalShalatEntryDto {
  JadwalShalatEntry toEntity() => JadwalShalatEntry(
    tanggal: tanggal,
    tanggalLengkap: tanggalLengkap,
    hari: hari,
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

extension JadwalShalatDtoX on JadwalShalatDto {
  JadwalShalat toEntity() => JadwalShalat(
    provinsi: provinsi,
    kabkota: kabkota,
    bulan: bulan,
    tahun: tahun,
    bulanNama: bulanNama,
    jadwal: jadwal.map((e) => e.toEntity()).toList(),
  );
}
