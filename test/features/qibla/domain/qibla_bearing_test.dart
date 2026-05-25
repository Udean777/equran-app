import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

/// Kalkulasi bearing dari titik asal ke titik tujuan (Haversine).
/// Duplikasi dari QiblaDataSource._calculateBearing agar testable tanpa sensor.
double calculateBearing(
  double fromLat,
  double fromLng,
  double toLat,
  double toLng,
) {
  final fromLatRad = fromLat * math.pi / 180;
  final toLatRad = toLat * math.pi / 180;
  final deltaLng = (toLng - fromLng) * math.pi / 180;

  final y = math.sin(deltaLng) * math.cos(toLatRad);
  final x =
      math.cos(fromLatRad) * math.sin(toLatRad) -
      math.sin(fromLatRad) * math.cos(toLatRad) * math.cos(deltaLng);

  final bearing = math.atan2(y, x);
  return (bearing * 180 / math.pi + 360) % 360;
}

void main() {
  group('Qibla Bearing — kalkulasi Haversine', () {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;

    test('bearing dari Jakarta ke Mekah sekitar 295° (barat laut)', () {
      // Jakarta: -6.2088, 106.8456
      final bearing = calculateBearing(-6.2088, 106.8456, kaabaLat, kaabaLng);
      // Toleransi ±2 derajat
      expect(bearing, closeTo(295.0, 2.0));
    });

    test('bearing dari Surabaya ke Mekah sekitar 294°', () {
      // Surabaya: -7.2575, 112.7521
      final bearing = calculateBearing(-7.2575, 112.7521, kaabaLat, kaabaLng);
      expect(bearing, closeTo(294.0, 2.0));
    });

    test('bearing dari Makassar ke Mekah sekitar 292°', () {
      // Makassar: -5.1477, 119.4327
      final bearing = calculateBearing(-5.1477, 119.4327, kaabaLat, kaabaLng);
      expect(bearing, closeTo(292.0, 2.0));
    });

    test('bearing dari Mekah ke Mekah adalah 0° (titik sama)', () {
      final bearing = calculateBearing(kaabaLat, kaabaLng, kaabaLat, kaabaLng);
      // Titik sama → bearing tidak relevan, tapi tidak boleh NaN
      expect(bearing.isNaN, false);
    });

    test('bearing selalu dalam range 0–360', () {
      final testCases = [
        (-6.2088, 106.8456), // Jakarta
        (3.5952, 98.6722), // Medan
        (-8.6500, 115.2167), // Bali
        (1.4748, 124.8421), // Manado
        (-2.9761, 104.7754), // Palembang
      ];

      for (final (lat, lng) in testCases) {
        final bearing = calculateBearing(lat, lng, kaabaLat, kaabaLng);
        expect(bearing, greaterThanOrEqualTo(0.0));
        expect(bearing, lessThan(360.0));
      }
    });

    test('qiblaAngle = (bearing - heading + 360) % 360 selalu dalam 0–360', () {
      final bearing = calculateBearing(-6.2088, 106.8456, kaabaLat, kaabaLng);

      // Simulasi berbagai heading device
      for (var heading = 0.0; heading < 360.0; heading += 45.0) {
        final qiblaAngle = (bearing - heading + 360) % 360;
        expect(qiblaAngle, greaterThanOrEqualTo(0.0));
        expect(qiblaAngle, lessThan(360.0));
      }
    });
  });
}
