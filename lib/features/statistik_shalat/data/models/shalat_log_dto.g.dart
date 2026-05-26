// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shalat_log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShalatLogDto _$ShalatLogDtoFromJson(Map<String, dynamic> json) =>
    _ShalatLogDto(
      date: json['date'] as String,
      waktu: json['waktu'] as String,
      status: json['status'] as String? ?? 'belumDicatat',
      catatan: json['catatan'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ShalatLogDtoToJson(_ShalatLogDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'waktu': instance.waktu,
      'status': instance.status,
      'catatan': instance.catatan,
      'updatedAt': instance.updatedAt,
    };

_ShalatDayDto _$ShalatDayDtoFromJson(Map<String, dynamic> json) =>
    _ShalatDayDto(
      date: json['date'] as String,
      logs:
          (json['logs'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, ShalatLogDto.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$ShalatDayDtoToJson(_ShalatDayDto instance) =>
    <String, dynamic>{'date': instance.date, 'logs': instance.logs};
