// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookmarkDto _$BookmarkDtoFromJson(Map<String, dynamic> json) => _BookmarkDto(
  suratNomor: (json['suratNomor'] as num).toInt(),
  ayatNomor: (json['ayatNomor'] as num).toInt(),
  namaLatin: json['namaLatin'] as String,
  teksArab: json['teksArab'] as String,
  teksIndonesia: json['teksIndonesia'] as String,
  savedAt: json['savedAt'] as String,
);

Map<String, dynamic> _$BookmarkDtoToJson(_BookmarkDto instance) =>
    <String, dynamic>{
      'suratNomor': instance.suratNomor,
      'ayatNomor': instance.ayatNomor,
      'namaLatin': instance.namaLatin,
      'teksArab': instance.teksArab,
      'teksIndonesia': instance.teksIndonesia,
      'savedAt': instance.savedAt,
    };

_LastReadDto _$LastReadDtoFromJson(Map<String, dynamic> json) => _LastReadDto(
  suratNomor: (json['suratNomor'] as num).toInt(),
  ayatNomor: (json['ayatNomor'] as num).toInt(),
  namaLatin: json['namaLatin'] as String,
  readAt: json['readAt'] as String,
);

Map<String, dynamic> _$LastReadDtoToJson(_LastReadDto instance) =>
    <String, dynamic>{
      'suratNomor': instance.suratNomor,
      'ayatNomor': instance.ayatNomor,
      'namaLatin': instance.namaLatin,
      'readAt': instance.readAt,
    };
