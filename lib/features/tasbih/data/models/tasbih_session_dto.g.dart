// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasbih_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TasbihSessionDto _$TasbihSessionDtoFromJson(Map<String, dynamic> json) =>
    _TasbihSessionDto(
      id: json['id'] as String,
      presetId: json['presetId'] as String,
      presetName: json['presetName'] as String,
      count: (json['count'] as num).toInt(),
      target: (json['target'] as num).toInt(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$TasbihSessionDtoToJson(_TasbihSessionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'presetId': instance.presetId,
      'presetName': instance.presetName,
      'count': instance.count,
      'target': instance.target,
      'createdAt': instance.createdAt,
    };
