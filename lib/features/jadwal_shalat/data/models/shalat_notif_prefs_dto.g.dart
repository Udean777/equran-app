// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shalat_notif_prefs_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShalatNotifPrefsDto _$ShalatNotifPrefsDtoFromJson(Map<String, dynamic> json) =>
    _ShalatNotifPrefsDto(
      subuh: json['subuh'] as bool? ?? true,
      dzuhur: json['dzuhur'] as bool? ?? true,
      ashar: json['ashar'] as bool? ?? true,
      maghrib: json['maghrib'] as bool? ?? true,
      isya: json['isya'] as bool? ?? true,
      menitSebelum: (json['menitSebelum'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ShalatNotifPrefsDtoToJson(
  _ShalatNotifPrefsDto instance,
) => <String, dynamic>{
  'subuh': instance.subuh,
  'dzuhur': instance.dzuhur,
  'ashar': instance.ashar,
  'maghrib': instance.maghrib,
  'isya': instance.isya,
  'menitSebelum': instance.menitSebelum,
};
