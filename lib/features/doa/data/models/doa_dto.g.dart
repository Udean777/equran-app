// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doa_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoaListResponseDto _$DoaListResponseDtoFromJson(Map<String, dynamic> json) =>
    _DoaListResponseDto(
      status: json['status'] as String,
      total: (json['total'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => DoaDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DoaListResponseDtoToJson(_DoaListResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total': instance.total,
      'data': instance.data,
    };

_DoaDetailResponseDto _$DoaDetailResponseDtoFromJson(
  Map<String, dynamic> json,
) => _DoaDetailResponseDto(
  status: json['status'] as String,
  data: DoaDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DoaDetailResponseDtoToJson(
  _DoaDetailResponseDto instance,
) => <String, dynamic>{'status': instance.status, 'data': instance.data};

_DoaDto _$DoaDtoFromJson(Map<String, dynamic> json) => _DoaDto(
  id: (json['id'] as num).toInt(),
  grup: json['grup'] as String,
  nama: json['nama'] as String,
  ar: json['ar'] as String,
  tr: json['tr'] as String? ?? '',
  idn: json['idn'] as String? ?? '',
  tentang: json['tentang'] as String? ?? '',
  tag:
      (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$DoaDtoToJson(_DoaDto instance) => <String, dynamic>{
  'id': instance.id,
  'grup': instance.grup,
  'nama': instance.nama,
  'ar': instance.ar,
  'tr': instance.tr,
  'idn': instance.idn,
  'tentang': instance.tentang,
  'tag': instance.tag,
};
