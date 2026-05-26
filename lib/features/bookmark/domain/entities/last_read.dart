import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_read.freezed.dart';

@freezed
abstract class LastRead with _$LastRead {
  const factory LastRead({
    required int suratNomor,
    required int ayatNomor,
    required String namaLatin,
    required DateTime readAt,
    /// Progress membaca: 0.0 (awal) – 1.0 (selesai).
    /// Dihitung otomatis: ayatNomor / totalAyat.
    @Default(0.0) double scrollPercent,
    /// Total ayat dalam surat — digunakan untuk hitung scrollPercent.
    @Default(0) int totalAyat,
  }) = _LastRead;
}
