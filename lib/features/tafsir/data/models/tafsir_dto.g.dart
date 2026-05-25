// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tafsir_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TafsirResponseDto _$TafsirResponseDtoFromJson(Map<String, dynamic> json) =>
    _TafsirResponseDto(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: TafsirDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TafsirResponseDtoToJson(_TafsirResponseDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

_TafsirDataDto _$TafsirDataDtoFromJson(Map<String, dynamic> json) =>
    _TafsirDataDto(
      nomor: (json['nomor'] as num).toInt(),
      nama: json['nama'] as String,
      namaLatin: json['namaLatin'] as String,
      jumlahAyat: (json['jumlahAyat'] as num).toInt(),
      tempatTurun: json['tempatTurun'] as String,
      arti: json['arti'] as String,
      tafsir: (json['tafsir'] as List<dynamic>)
          .map((e) => TafsirAyatDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TafsirDataDtoToJson(_TafsirDataDto instance) =>
    <String, dynamic>{
      'nomor': instance.nomor,
      'nama': instance.nama,
      'namaLatin': instance.namaLatin,
      'jumlahAyat': instance.jumlahAyat,
      'tempatTurun': instance.tempatTurun,
      'arti': instance.arti,
      'tafsir': instance.tafsir,
    };

_TafsirAyatDto _$TafsirAyatDtoFromJson(Map<String, dynamic> json) =>
    _TafsirAyatDto(
      ayat: (json['ayat'] as num).toInt(),
      teks: json['teks'] as String,
    );

Map<String, dynamic> _$TafsirAyatDtoToJson(_TafsirAyatDto instance) =>
    <String, dynamic>{'ayat': instance.ayat, 'teks': instance.teks};
