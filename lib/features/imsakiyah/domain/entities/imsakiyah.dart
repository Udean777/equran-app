import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'imsakiyah.freezed.dart';

@freezed
abstract class Imsakiyah with _$Imsakiyah {
  const factory Imsakiyah({
    required String provinsi,
    required String kabkota,
    required String hijriah,
    required String masehi,
    required List<ImsakiyahEntry> imsakiyah,
  }) = _Imsakiyah;
  const Imsakiyah._();

  ImsakiyahEntry? entryByTanggal(int tanggal) {
    for (final e in imsakiyah) {
      if (e.tanggal == tanggal) return e;
    }
    return null;
  }
}
