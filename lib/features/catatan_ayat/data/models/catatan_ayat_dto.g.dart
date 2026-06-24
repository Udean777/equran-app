// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catatan_ayat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatatanAyatDto _$CatatanAyatDtoFromJson(Map<String, dynamic> json) =>
    _CatatanAyatDto(
      suratNomor: (json['suratNomor'] as num).toInt(),
      ayatNomor: (json['ayatNomor'] as num).toInt(),
      namaLatin: json['namaLatin'] as String,
      teksArab: json['teksArab'] as String,
      isi: json['isi'] as String,
      savedAt: json['savedAt'] as String,
    );

Map<String, dynamic> _$CatatanAyatDtoToJson(_CatatanAyatDto instance) =>
    <String, dynamic>{
      'suratNomor': instance.suratNomor,
      'ayatNomor': instance.ayatNomor,
      'namaLatin': instance.namaLatin,
      'teksArab': instance.teksArab,
      'isi': instance.isi,
      'savedAt': instance.savedAt,
    };
