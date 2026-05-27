import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

/// Hasil dari deteksi lokasi GPS
class DetectedLocation {
  const DetectedLocation({
    required this.provinsi,
    required this.kabkota,
  });

  /// Nama provinsi (e.g. "JAWA TIMUR")
  final String provinsi;

  /// Nama kab/kota (e.g. "KOTA SURABAYA")
  final String kabkota;
}

abstract interface class LocationService {
  /// Coba deteksi lokasi user via GPS + reverse geocode.
  ///
  /// Return [DetectedLocation] jika berhasil, atau `null` jika:
  /// - user menolak permission
  /// - GPS tidak tersedia / disabled
  /// - reverse geocode gagal menghasilkan data
  Future<DetectedLocation?> detectCurrentLocation();
}

@LazySingleton(as: LocationService)
class LocationServiceImpl implements LocationService {
  @override
  Future<DetectedLocation?> detectCurrentLocation() async {
    try {
      // 1. Cek apakah location service aktif
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      // 2. Cek & minta permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // 3. Dapatkan posisi dengan timeout
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // 4. Reverse geocode dengan timeout
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(
        const Duration(seconds: 8),
        onTimeout: () => [],
      );

      if (placemarks.isEmpty) return null;

      final place = placemarks.first;

      // administrativeArea  = provinsi (Android & iOS)
      // locality            = nama kota/kabupaten (lebih reliable di Android)
      // subAdministrativeArea = kadang kecamatan di Android, fallback saja
      final rawProvinsi =
          place.administrativeArea ?? place.subAdministrativeArea ?? '';

      // Prioritas: locality → subAdministrativeArea
      // locality lebih sering berisi nama kota/kab yang cocok dengan API
      final rawKabkota = (place.locality?.isNotEmpty == true)
          ? place.locality!
          : (place.subAdministrativeArea ?? '');

      if (rawProvinsi.isEmpty || rawKabkota.isEmpty) return null;

      return DetectedLocation(
        provinsi: _normalize(rawProvinsi),
        kabkota: _normalize(rawKabkota),
      );
    } on Object {
      return null;
    }
  }

  /// Normalisasi nama: UPPERCASE + trim agar mudah dicocokkan dengan data API.
  String _normalize(String raw) => raw.trim().toUpperCase();
}
