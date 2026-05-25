import 'package:freezed_annotation/freezed_annotation.dart';

part 'jadwal_shalat_entry.freezed.dart';

@freezed
abstract class JadwalShalatEntry with _$JadwalShalatEntry {
  const factory JadwalShalatEntry({
    required int tanggal,
    required String tanggalLengkap,
    required String hari,
    required String imsak,
    required String subuh,
    required String terbit,
    required String dhuha,
    required String dzuhur,
    required String ashar,
    required String maghrib,
    required String isya,
  }) = _JadwalShalatEntry;
}
