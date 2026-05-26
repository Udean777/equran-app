// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shalat_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShalatLog _$ShalatLogFromJson(Map<String, dynamic> json) => _ShalatLog(
  date: json['date'] as String,
  waktu: $enumDecode(_$WaktuShalatEnumMap, json['waktu']),
  status:
      $enumDecodeNullable(_$ShalatStatusEnumMap, json['status']) ??
      ShalatStatus.belumDicatat,
  catatan: json['catatan'] as String?,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ShalatLogToJson(_ShalatLog instance) =>
    <String, dynamic>{
      'date': instance.date,
      'waktu': _$WaktuShalatEnumMap[instance.waktu]!,
      'status': _$ShalatStatusEnumMap[instance.status]!,
      'catatan': instance.catatan,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$WaktuShalatEnumMap = {
  WaktuShalat.subuh: 'subuh',
  WaktuShalat.dzuhur: 'dzuhur',
  WaktuShalat.ashar: 'ashar',
  WaktuShalat.maghrib: 'maghrib',
  WaktuShalat.isya: 'isya',
};

const _$ShalatStatusEnumMap = {
  ShalatStatus.belumDicatat: 'belumDicatat',
  ShalatStatus.tepatWaktu: 'tepatWaktu',
  ShalatStatus.qadha: 'qadha',
  ShalatStatus.tidakShalat: 'tidakShalat',
};
