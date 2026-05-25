import 'package:freezed_annotation/freezed_annotation.dart';

part 'imsakiyah_entry.freezed.dart';

@freezed
abstract class ImsakiyahEntry with _$ImsakiyahEntry {
  const factory ImsakiyahEntry({
    required int tanggal,
    required String imsak,
    required String subuh,
    required String terbit,
    required String dhuha,
    required String dzuhur,
    required String ashar,
    required String maghrib,
    required String isya,
  }) = _ImsakiyahEntry;
}
