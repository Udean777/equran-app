import 'package:freezed_annotation/freezed_annotation.dart';

part 'catatan_ayat.freezed.dart';
part 'catatan_ayat.g.dart';

@freezed
abstract class CatatanAyat with _$CatatanAyat {
  const factory CatatanAyat({
    required int suratNomor,
    required int ayatNomor,
    required String namaLatin,
    required String teksArab,
    required String isi,
    required DateTime savedAt,
  }) = _CatatanAyat;

  factory CatatanAyat.fromJson(Map<String, dynamic> json) =>
      _$CatatanAyatFromJson(json);
}
