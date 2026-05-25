// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surat_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SuratDetailResponseDto _$SuratDetailResponseDtoFromJson(
  Map<String, dynamic> json,
) => _SuratDetailResponseDto(
  code: (json['code'] as num).toInt(),
  message: json['message'] as String,
  data: SuratDetailDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SuratDetailResponseDtoToJson(
  _SuratDetailResponseDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'data': instance.data,
};

_SuratDetailDto _$SuratDetailDtoFromJson(Map<String, dynamic> json) =>
    _SuratDetailDto(
      nomor: (json['nomor'] as num).toInt(),
      nama: json['nama'] as String,
      namaLatin: json['namaLatin'] as String,
      jumlahAyat: (json['jumlahAyat'] as num).toInt(),
      tempatTurun: json['tempatTurun'] as String,
      arti: json['arti'] as String,
      deskripsi: json['deskripsi'] as String,
      audioFull:
          (json['audioFull'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      ayat:
          (json['ayat'] as List<dynamic>?)
              ?.map((e) => AyatDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      suratSelanjutnya: const SuratNavOrFalseConverter().fromJson(
        json['suratSelanjutnya'],
      ),
      suratSebelumnya: const SuratNavOrFalseConverter().fromJson(
        json['suratSebelumnya'],
      ),
    );

Map<String, dynamic> _$SuratDetailDtoToJson(_SuratDetailDto instance) =>
    <String, dynamic>{
      'nomor': instance.nomor,
      'nama': instance.nama,
      'namaLatin': instance.namaLatin,
      'jumlahAyat': instance.jumlahAyat,
      'tempatTurun': instance.tempatTurun,
      'arti': instance.arti,
      'deskripsi': instance.deskripsi,
      'audioFull': instance.audioFull,
      'ayat': instance.ayat,
      'suratSelanjutnya': const SuratNavOrFalseConverter().toJson(
        instance.suratSelanjutnya,
      ),
      'suratSebelumnya': const SuratNavOrFalseConverter().toJson(
        instance.suratSebelumnya,
      ),
    };

_AyatDto _$AyatDtoFromJson(Map<String, dynamic> json) => _AyatDto(
  nomorAyat: (json['nomorAyat'] as num).toInt(),
  teksArab: json['teksArab'] as String,
  teksLatin: json['teksLatin'] as String,
  teksIndonesia: json['teksIndonesia'] as String,
  audio:
      (json['audio'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
);

Map<String, dynamic> _$AyatDtoToJson(_AyatDto instance) => <String, dynamic>{
  'nomorAyat': instance.nomorAyat,
  'teksArab': instance.teksArab,
  'teksLatin': instance.teksLatin,
  'teksIndonesia': instance.teksIndonesia,
  'audio': instance.audio,
};

_SuratNavDto _$SuratNavDtoFromJson(Map<String, dynamic> json) => _SuratNavDto(
  nomor: (json['nomor'] as num).toInt(),
  namaLatin: json['namaLatin'] as String,
  jumlahAyat: (json['jumlahAyat'] as num).toInt(),
);

Map<String, dynamic> _$SuratNavDtoToJson(_SuratNavDto instance) =>
    <String, dynamic>{
      'nomor': instance.nomor,
      'namaLatin': instance.namaLatin,
      'jumlahAyat': instance.jumlahAyat,
    };
