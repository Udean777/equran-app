// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imsak_alarm_prefs_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImsakAlarmPrefsDto _$ImsakAlarmPrefsDtoFromJson(Map<String, dynamic> json) =>
    _ImsakAlarmPrefsDto(
      imsakEnabled: json['imsakEnabled'] as bool? ?? false,
      sahurEnabled: json['sahurEnabled'] as bool? ?? false,
      menitSebelumImsak: (json['menitSebelumImsak'] as num?)?.toInt() ?? 60,
    );

Map<String, dynamic> _$ImsakAlarmPrefsDtoToJson(_ImsakAlarmPrefsDto instance) =>
    <String, dynamic>{
      'imsakEnabled': instance.imsakEnabled,
      'sahurEnabled': instance.sahurEnabled,
      'menitSebelumImsak': instance.menitSebelumImsak,
    };
