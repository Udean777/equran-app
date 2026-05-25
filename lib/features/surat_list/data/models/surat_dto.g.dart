// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SuratListResponseDto _$SuratListResponseDtoFromJson(
  Map<String, dynamic> json,
) => _SuratListResponseDto(
  code: (json['code'] as num).toInt(),
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => SuratDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SuratListResponseDtoToJson(
  _SuratListResponseDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'data': instance.data,
};

_SuratDto _$SuratDtoFromJson(Map<String, dynamic> json) => _SuratDto(
  nomor: (json['nomor'] as num).toInt(),
  nama: json['nama'] as String,
  namaLatin: json['namaLatin'] as String,
  jumlahAyat: (json['jumlahAyat'] as num).toInt(),
  tempatTurun: json['tempatTurun'] as String,
  arti: json['arti'] as String,
);

Map<String, dynamic> _$SuratDtoToJson(_SuratDto instance) => <String, dynamic>{
  'nomor': instance.nomor,
  'nama': instance.nama,
  'namaLatin': instance.namaLatin,
  'jumlahAyat': instance.jumlahAyat,
  'tempatTurun': instance.tempatTurun,
  'arti': instance.arti,
};
