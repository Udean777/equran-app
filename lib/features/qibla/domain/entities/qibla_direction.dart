import 'dart:math' as math;

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

  /// Kalkulasi bearing dari titik asal ke titik tujuan.
  /// Return nilai dalam derajat (0–360).
  static double calculateBearing(
    double fromLat,
    double fromLng,
    double toLat,
    double toLng,
  ) {
    final fromLatRad = _toRadians(fromLat);
    final toLatRad = _toRadians(toLat);
    final deltaLng = _toRadians(toLng - fromLng);

    final y = math.sin(deltaLng) * math.cos(toLatRad);
    final x =
        math.cos(fromLatRad) * math.sin(toLatRad) -
        math.sin(fromLatRad) * math.cos(toLatRad) * math.cos(deltaLng);

    final bearing = math.atan2(y, x);
    return (_toDegrees(bearing) + 360) % 360;
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;
  static double _toDegrees(double radians) => radians * 180 / math.pi;
}
