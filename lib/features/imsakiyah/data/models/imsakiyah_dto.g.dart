// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imsakiyah_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProvinsiResponseDto _$ProvinsiResponseDtoFromJson(Map<String, dynamic> json) =>
    _ProvinsiResponseDto(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ProvinsiResponseDtoToJson(
  _ProvinsiResponseDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'data': instance.data,
};

_KabkotaResponseDto _$KabkotaResponseDtoFromJson(Map<String, dynamic> json) =>
    _KabkotaResponseDto(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$KabkotaResponseDtoToJson(_KabkotaResponseDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

_ImsakiyahResponseDto _$ImsakiyahResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ImsakiyahResponseDto(
  code: (json['code'] as num).toInt(),
  message: json['message'] as String,
  data: ImsakiyahDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ImsakiyahResponseDtoToJson(
  _ImsakiyahResponseDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'data': instance.data,
};

_ImsakiyahDto _$ImsakiyahDtoFromJson(Map<String, dynamic> json) =>
    _ImsakiyahDto(
      provinsi: json['provinsi'] as String,
      kabkota: json['kabkota'] as String,
      hijriah: json['hijriah'] as String,
      masehi: json['masehi'] as String,
      imsakiyah: (json['imsakiyah'] as List<dynamic>)
          .map((e) => ImsakiyahEntryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ImsakiyahDtoToJson(_ImsakiyahDto instance) =>
    <String, dynamic>{
      'provinsi': instance.provinsi,
      'kabkota': instance.kabkota,
      'hijriah': instance.hijriah,
      'masehi': instance.masehi,
      'imsakiyah': instance.imsakiyah,
    };

_ImsakiyahEntryDto _$ImsakiyahEntryDtoFromJson(Map<String, dynamic> json) =>
    _ImsakiyahEntryDto(
      tanggal: (json['tanggal'] as num).toInt(),
      imsak: json['imsak'] as String,
      subuh: json['subuh'] as String,
      terbit: json['terbit'] as String,
      dhuha: json['dhuha'] as String,
      dzuhur: json['dzuhur'] as String,
      ashar: json['ashar'] as String,
      maghrib: json['maghrib'] as String,
      isya: json['isya'] as String,
    );

Map<String, dynamic> _$ImsakiyahEntryDtoToJson(_ImsakiyahEntryDto instance) =>
    <String, dynamic>{
      'tanggal': instance.tanggal,
      'imsak': instance.imsak,
      'subuh': instance.subuh,
      'terbit': instance.terbit,
      'dhuha': instance.dhuha,
      'dzuhur': instance.dzuhur,
      'ashar': instance.ashar,
      'maghrib': instance.maghrib,
      'isya': instance.isya,
    };
