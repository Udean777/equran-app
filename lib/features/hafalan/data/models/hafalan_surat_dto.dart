import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hafalan_surat_dto.freezed.dart';
part 'hafalan_surat_dto.g.dart';

@freezed
abstract class HafalanSuratDto with _$HafalanSuratDto {
  const factory HafalanSuratDto({
    required int suratNomor,
    required String namaLatin,
    required String nama,
    required int jumlahAyat,

    /// Status disimpan sebagai string nama enum.
    @Default('belum') String status,

    /// Nomor ayat yang sudah hafal.
    @Default([]) List<int> ayatHafal,

    /// Level spaced repetition (0–5).
    @Default(0) int murajaahLevel,

    /// DateTime disimpan sebagai ISO 8601 string.
    String? tanggalMulai,
    String? tanggalSelesai,
    String? tanggalMurajaahBerikutnya,

    String? catatan,
  }) = _HafalanSuratDto;

  factory HafalanSuratDto.fromJson(Map<String, dynamic> json) =>
      _$HafalanSuratDtoFromJson(json);
}

/// Helper untuk konversi string ↔ HafalanStatus.
extension HafalanStatusStringX on String {
  HafalanStatus toHafalanStatus() {
    switch (this) {
      case 'sedangDihafal':
        return HafalanStatus.sedangDihafal;
      case 'sudahHafal':
        return HafalanStatus.sudahHafal;
      case 'perluMurajaah':
        // perluMurajaah tidak disimpan — fallback ke sudahHafal
        return HafalanStatus.sudahHafal;
      default:
        return HafalanStatus.belum;
    }
  }
}

extension HafalanStatusEnumX on HafalanStatus {
  String toStringValue() {
    switch (this) {
      case HafalanStatus.sedangDihafal:
        return 'sedangDihafal';
      case HafalanStatus.sudahHafal:
        return 'sudahHafal';
      case HafalanStatus.perluMurajaah:
        // perluMurajaah adalah computed — simpan sebagai sudahHafal
        return 'sudahHafal';
      case HafalanStatus.belum:
        return 'belum';
    }
  }
}
