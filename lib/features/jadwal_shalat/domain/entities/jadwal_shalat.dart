import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'jadwal_shalat.freezed.dart';

@freezed
abstract class JadwalShalat with _$JadwalShalat {
  const factory JadwalShalat({
    required String provinsi,
    required String kabkota,
    required int bulan,
    required int tahun,
    required String bulanNama,
    required List<JadwalShalatEntry> jadwal,
  }) = _JadwalShalat;
}
