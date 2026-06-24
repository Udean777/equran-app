import 'package:equran_app/core/domain/entities/surat.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tafsir_surat.freezed.dart';

@freezed
abstract class TafsirSurat with _$TafsirSurat {
  const factory TafsirSurat({
    required Surat info,
    required List<TafsirAyat> tafsirList,
  }) = _TafsirSurat;
}

@freezed
abstract class TafsirAyat with _$TafsirAyat {
  const factory TafsirAyat({
    required int nomorAyat,
    required String teks,
  }) = _TafsirAyat;
}
