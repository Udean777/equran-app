// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingHistory _$ReadingHistoryFromJson(Map<String, dynamic> json) =>
    _ReadingHistory(
      date: json['date'] as String,
      ayatRead:
          (json['ayatRead'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const <String>{},
    );

Map<String, dynamic> _$ReadingHistoryToJson(_ReadingHistory instance) =>
    <String, dynamic>{
      'date': instance.date,
      'ayatRead': instance.ayatRead.toList(),
    };

_SuratReadCount _$SuratReadCountFromJson(Map<String, dynamic> json) =>
    _SuratReadCount(
      suratNomor: (json['suratNomor'] as num).toInt(),
      namaLatin: json['namaLatin'] as String,
      jumlahAyatDibaca: (json['jumlahAyatDibaca'] as num).toInt(),
    );

Map<String, dynamic> _$SuratReadCountToJson(_SuratReadCount instance) =>
    <String, dynamic>{
      'suratNomor': instance.suratNomor,
      'namaLatin': instance.namaLatin,
      'jumlahAyatDibaca': instance.jumlahAyatDibaca,
    };
