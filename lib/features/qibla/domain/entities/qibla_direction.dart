import 'package:freezed_annotation/freezed_annotation.dart';

part 'qibla_direction.freezed.dart';

@freezed
abstract class QiblaDirection with _$QiblaDirection {
  const factory QiblaDirection({
    /// Bearing dari posisi user ke Kabah dalam derajat (0–360).
    required double bearing,

    /// Heading device dari sensor kompas dalam derajat (0–360).
    required double deviceHeading,

    /// Sudut jarum kompas relatif ke device: (bearing - deviceHeading + 360) % 360.
    required double qiblaAngle,

    /// Akurasi sensor kompas (null jika tidak tersedia).
    double? accuracy,
  }) = _QiblaDirection;
}
