// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hafalan_surat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HafalanSuratDto _$HafalanSuratDtoFromJson(Map<String, dynamic> json) =>
    _HafalanSuratDto(
      suratNomor: (json['suratNomor'] as num).toInt(),
      namaLatin: json['namaLatin'] as String,
      nama: json['nama'] as String,
      jumlahAyat: (json['jumlahAyat'] as num).toInt(),
      status: json['status'] as String? ?? 'belum',
      ayatHafal:
          (json['ayatHafal'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      murajaahLevel: (json['murajaahLevel'] as num?)?.toInt() ?? 0,
      tanggalMulai: json['tanggalMulai'] as String?,
      tanggalSelesai: json['tanggalSelesai'] as String?,
      tanggalMurajaahBerikutnya: json['tanggalMurajaahBerikutnya'] as String?,
      catatan: json['catatan'] as String?,
    );

Map<String, dynamic> _$HafalanSuratDtoToJson(_HafalanSuratDto instance) =>
    <String, dynamic>{
      'suratNomor': instance.suratNomor,
      'namaLatin': instance.namaLatin,
      'nama': instance.nama,
      'jumlahAyat': instance.jumlahAyat,
      'status': instance.status,
      'ayatHafal': instance.ayatHafal,
      'murajaahLevel': instance.murajaahLevel,
      'tanggalMulai': instance.tanggalMulai,
      'tanggalSelesai': instance.tanggalSelesai,
      'tanggalMurajaahBerikutnya': instance.tanggalMurajaahBerikutnya,
      'catatan': instance.catatan,
    };
