// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jadwal_shalat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProvinsiShalatResponseDto _$ProvinsiShalatResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ProvinsiShalatResponseDto(
  code: (json['code'] as num).toInt(),
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ProvinsiShalatResponseDtoToJson(
  _ProvinsiShalatResponseDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'data': instance.data,
};

_KabkotaShalatResponseDto _$KabkotaShalatResponseDtoFromJson(
  Map<String, dynamic> json,
) => _KabkotaShalatResponseDto(
  code: (json['code'] as num).toInt(),
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$KabkotaShalatResponseDtoToJson(
  _KabkotaShalatResponseDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'data': instance.data,
};

_JadwalShalatResponseDto _$JadwalShalatResponseDtoFromJson(
  Map<String, dynamic> json,
) => _JadwalShalatResponseDto(
  code: (json['code'] as num).toInt(),
  message: json['message'] as String,
  data: JadwalShalatDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$JadwalShalatResponseDtoToJson(
  _JadwalShalatResponseDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'data': instance.data,
};

_JadwalShalatDto _$JadwalShalatDtoFromJson(Map<String, dynamic> json) =>
    _JadwalShalatDto(
      provinsi: json['provinsi'] as String,
      kabkota: json['kabkota'] as String,
      bulan: (json['bulan'] as num).toInt(),
      tahun: (json['tahun'] as num).toInt(),
      bulanNama: json['bulan_nama'] as String,
      jadwal: (json['jadwal'] as List<dynamic>)
          .map((e) => JadwalShalatEntryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JadwalShalatDtoToJson(_JadwalShalatDto instance) =>
    <String, dynamic>{
      'provinsi': instance.provinsi,
      'kabkota': instance.kabkota,
      'bulan': instance.bulan,
      'tahun': instance.tahun,
      'bulan_nama': instance.bulanNama,
      'jadwal': instance.jadwal,
    };

_JadwalShalatEntryDto _$JadwalShalatEntryDtoFromJson(
  Map<String, dynamic> json,
) => _JadwalShalatEntryDto(
  tanggal: (json['tanggal'] as num).toInt(),
  tanggalLengkap: json['tanggal_lengkap'] as String,
  hari: json['hari'] as String,
  imsak: json['imsak'] as String,
  subuh: json['subuh'] as String,
  terbit: json['terbit'] as String,
  dhuha: json['dhuha'] as String,
  dzuhur: json['dzuhur'] as String,
  ashar: json['ashar'] as String,
  maghrib: json['maghrib'] as String,
  isya: json['isya'] as String,
);

Map<String, dynamic> _$JadwalShalatEntryDtoToJson(
  _JadwalShalatEntryDto instance,
) => <String, dynamic>{
  'tanggal': instance.tanggal,
  'tanggal_lengkap': instance.tanggalLengkap,
  'hari': instance.hari,
  'imsak': instance.imsak,
  'subuh': instance.subuh,
  'terbit': instance.terbit,
  'dhuha': instance.dhuha,
  'dzuhur': instance.dzuhur,
  'ashar': instance.ashar,
  'maghrib': instance.maghrib,
  'isya': instance.isya,
};
