import 'package:freezed_annotation/freezed_annotation.dart';

part 'surat.freezed.dart';

enum TempatTurun { mekah, madinah }

@freezed
abstract class Surat with _$Surat {
  const factory Surat({
    required int nomor,
    required String nama,
    required String namaLatin,
    required int jumlahAyat,
    required TempatTurun tempatTurun,
    required String arti,
  }) = _Surat;
}
