// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_history_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingHistoryDto _$ReadingHistoryDtoFromJson(Map<String, dynamic> json) =>
    _ReadingHistoryDto(
      date: json['date'] as String,
      ayatRead:
          (json['ayatRead'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$ReadingHistoryDtoToJson(_ReadingHistoryDto instance) =>
    <String, dynamic>{'date': instance.date, 'ayatRead': instance.ayatRead};
