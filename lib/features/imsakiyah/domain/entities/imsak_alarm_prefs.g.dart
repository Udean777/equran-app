// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imsak_alarm_prefs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImsakAlarmPrefs _$ImsakAlarmPrefsFromJson(Map<String, dynamic> json) =>
    _ImsakAlarmPrefs(
      imsakEnabled: json['imsakEnabled'] as bool? ?? false,
      sahurEnabled: json['sahurEnabled'] as bool? ?? false,
      menitSebelumImsak: (json['menitSebelumImsak'] as num?)?.toInt() ?? 60,
    );

Map<String, dynamic> _$ImsakAlarmPrefsToJson(_ImsakAlarmPrefs instance) =>
    <String, dynamic>{
      'imsakEnabled': instance.imsakEnabled,
      'sahurEnabled': instance.sahurEnabled,
      'menitSebelumImsak': instance.menitSebelumImsak,
    };
