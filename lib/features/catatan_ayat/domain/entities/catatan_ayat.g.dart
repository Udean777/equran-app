// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catatan_ayat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatatanAyat _$CatatanAyatFromJson(Map<String, dynamic> json) => _CatatanAyat(
  suratNomor: (json['suratNomor'] as num).toInt(),
  ayatNomor: (json['ayatNomor'] as num).toInt(),
  namaLatin: json['namaLatin'] as String,
  teksArab: json['teksArab'] as String,
  isi: json['isi'] as String,
  savedAt: DateTime.parse(json['savedAt'] as String),
);

Map<String, dynamic> _$CatatanAyatToJson(_CatatanAyat instance) =>
    <String, dynamic>{
      'suratNomor': instance.suratNomor,
      'ayatNomor': instance.ayatNomor,
      'namaLatin': instance.namaLatin,
      'teksArab': instance.teksArab,
      'isi': instance.isi,
      'savedAt': instance.savedAt.toIso8601String(),
    };
