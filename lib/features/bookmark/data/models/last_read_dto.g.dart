// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_read_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LastReadDto _$LastReadDtoFromJson(Map<String, dynamic> json) => _LastReadDto(
  suratNomor: (json['suratNomor'] as num).toInt(),
  ayatNomor: (json['ayatNomor'] as num).toInt(),
  namaLatin: json['namaLatin'] as String,
  readAt: json['readAt'] as String,
  scrollPercent: (json['scrollPercent'] as num?)?.toDouble() ?? 0.0,
  maxScrollPercent: (json['maxScrollPercent'] as num?)?.toDouble() ?? 0.0,
  totalAyat: (json['totalAyat'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$LastReadDtoToJson(_LastReadDto instance) =>
    <String, dynamic>{
      'suratNomor': instance.suratNomor,
      'ayatNomor': instance.ayatNomor,
      'namaLatin': instance.namaLatin,
      'readAt': instance.readAt,
      'scrollPercent': instance.scrollPercent,
      'maxScrollPercent': instance.maxScrollPercent,
      'totalAyat': instance.totalAyat,
    };
