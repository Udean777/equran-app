import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/qibla/domain/entities/qibla_direction.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';

/// Koordinat Kabah (hardcoded)
const double _kaabaLat = 21.4225;
const double _kaabaLng = 39.8262;

class QiblaDataSource {
  Position? _userPosition;

  /// Request permission lokasi dan ambil koordinat user sekali saja.
  Future<Either<Failure, Unit>> init() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return left(
          const Failure.unknown(message: 'Layanan lokasi tidak aktif.'),
        );
      }

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

    final bearing = QiblaDirection.calculateBearing(
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
}
