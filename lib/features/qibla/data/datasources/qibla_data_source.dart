import 'dart:math' as math;

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/qibla/domain/entities/qibla_direction.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

/// Koordinat Kabah (hardcoded)
const double _kaabaLat = 21.4225;
const double _kaabaLng = 39.8262;

@lazySingleton
class QiblaDataSource {
  Position? _userPosition;

  /// Request permission lokasi dan ambil koordinat user sekali saja.
  Future<Either<Failure, Unit>> init() async {
    try {
      // Cek apakah location service aktif
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return left(
          const Failure.unknown(message: 'Layanan lokasi tidak aktif.'),
        );
      }

      // Cek dan request permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return left(
            const Failure.unknown(message: 'Izin lokasi ditolak.'),
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return left(
          const Failure.unknown(
            message:
                'Izin lokasi ditolak permanen. Aktifkan di pengaturan perangkat.',
          ),
        );
      }

      // Ambil posisi user
      _userPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  /// Stream [QiblaDirection] real-time dari sensor kompas.
  Either<Failure, Stream<QiblaDirection>> watch() {
    if (_userPosition == null) {
      return left(
        const Failure.unknown(
          message: 'Posisi user belum diinisialisasi. Panggil init() dulu.',
        ),
      );
    }

    final compassEvents = FlutterCompass.events;
    if (compassEvents == null) {
      return left(
        const Failure.unknown(
          message: 'Perangkat tidak memiliki sensor kompas.',
        ),
      );
    }

    final bearing = _calculateBearing(
      _userPosition!.latitude,
      _userPosition!.longitude,
      _kaabaLat,
      _kaabaLng,
    );

    final stream = compassEvents.where((event) => event.heading != null).map((
      event,
    ) {
      final heading = event.heading!;
      final qiblaAngle = (bearing - heading + 360) % 360;
      return QiblaDirection(
        bearing: bearing,
        deviceHeading: heading,
        qiblaAngle: qiblaAngle,
        accuracy: event.accuracy,
      );
    });

    return right(stream);
  }

  /// Kalkulasi bearing dari titik asal ke titik tujuan menggunakan formula Haversine.
  /// Return nilai dalam derajat (0–360).
  double _calculateBearing(
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

  double _toRadians(double degrees) => degrees * math.pi / 180;
  double _toDegrees(double radians) => radians * 180 / math.pi;
}
