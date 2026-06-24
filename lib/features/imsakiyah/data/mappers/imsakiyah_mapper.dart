import 'package:equran_app/features/imsakiyah/data/models/imsak_alarm_prefs_dto.dart';
import 'package:equran_app/features/imsakiyah/data/models/imsakiyah_dto.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
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

extension ImsakAlarmPrefsDtoX on ImsakAlarmPrefsDto {
  ImsakAlarmPrefs toEntity() => ImsakAlarmPrefs(
    imsakEnabled: imsakEnabled,
    sahurEnabled: sahurEnabled,
    menitSebelumImsak: menitSebelumImsak,
  );
}

extension ImsakAlarmPrefsX on ImsakAlarmPrefs {
  ImsakAlarmPrefsDto toDto() => ImsakAlarmPrefsDto(
    imsakEnabled: imsakEnabled,
    sahurEnabled: sahurEnabled,
    menitSebelumImsak: menitSebelumImsak,
  );
}
