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
