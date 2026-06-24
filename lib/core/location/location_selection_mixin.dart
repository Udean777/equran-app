import 'dart:async';

import 'package:equran_app/core/location/location_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mixin untuk cubit yang membutuhkan GPS detection + location selection.
///
/// Digunakan oleh JadwalShalatCubit dan ImsakiyahCubit untuk menghilangkan
/// duplikasi logika GPS detection, fallback Jakarta, dan fuzzy match lokasi.
///
/// Cubit yang menggunakan mixin ini wajib mengimplementasikan:
/// - [locationService] — injected via constructor
/// - [getKabkotaList] — fetch kabkota dari API
/// - [saveLocation] — simpan lokasi terpilih
/// - [onLocationDetected] — callback setelah lokasi berhasil di-detect/dipilih
/// - [onDetectingLocation] — emit state detecting location
/// - [onLocationDetectFailed] — fallback saat GPS gagal
mixin LocationSelectionMixin<T> on Cubit<T> {
  static const defaultProvinsi = 'DKI Jakarta';
  static const defaultKabkota = 'Kota Jakarta Pusat';

  LocationService get locationService;

  /// Fetch kabkota list untuk provinsi tertentu.
  /// Return null jika gagal.
  Future<List<String>?> getKabkotaList(String provinsi);

  /// Simpan lokasi terpilih ke storage.
  Future<void> saveLocation({
    required String provinsi,
    required String kabkota,
  });

  /// Dipanggil saat lokasi berhasil di-detect atau dipilih.
  /// Cubit harus emit state yang sesuai.
  Future<void> onLocationDetected({
    required List<String> provinsiList,
    required String selectedProvinsi,
    required String selectedKabkota,
    List<String>? kabkotaList,
  });

  /// Emit state detecting location.
  void onDetectingLocation();

  /// Dipanggil saat GPS gagal — fallback ke Jakarta atau emit provinsiLoaded.
  Future<void> onLocationDetectFailed(List<String> provinsiList);

  /// Auto-detect lokasi dari GPS, fallback ke Jakarta jika gagal.
  /// Dipanggil setelah provinsi list berhasil di-load dan tidak ada riwayat lokasi.
  Future<void> autoDetectLocation(List<String> provinsiList) async {
    onDetectingLocation();

    final detected = await locationService.detectCurrentLocation();

    if (detected != null) {
      final matchedProvinsi = _fuzzyMatch(detected.provinsi, provinsiList);

      if (matchedProvinsi != null) {
        final kabkota = await getKabkotaList(matchedProvinsi);
        if (kabkota != null) {
          final matchedKabkota = _fuzzyMatch(detected.kabkota, kabkota);

          if (matchedKabkota != null) {
            unawaited(
              saveLocation(
                provinsi: matchedProvinsi,
                kabkota: matchedKabkota,
              ),
            );
            await onLocationDetected(
              provinsiList: provinsiList,
              selectedProvinsi: matchedProvinsi,
              selectedKabkota: matchedKabkota,
              kabkotaList: kabkota,
            );
            return;
          }
        }
      }
    }

    // GPS gagal / tidak cocok → fallback
    await onLocationDetectFailed(provinsiList);
  }

  /// Fuzzy match [query] terhadap list [candidates].
  String? _fuzzyMatch(String query, List<String> candidates) {
    final q = query.toUpperCase().trim();

    final exact = candidates.where((c) => c.toUpperCase() == q);
    if (exact.isNotEmpty) return exact.first;

    final containsQ = candidates.where((c) => c.toUpperCase().contains(q));
    if (containsQ.isNotEmpty) return containsQ.first;

    final stripped = candidates.where((c) {
      final upper = c.toUpperCase();
      final clean = upper
          .replaceFirst(RegExp(r'^KAB\.\s*'), '')
          .replaceFirst(RegExp(r'^KABUPATEN\s+'), '')
          .replaceFirst(RegExp(r'^KOTA\s+'), '')
          .trim();
      return clean == q || clean.contains(q) || q.contains(clean);
    });
    if (stripped.isNotEmpty) return stripped.first;

    final qTokens = q.split(RegExp(r'\s+'));
    bool allTokensIn(String c) {
      final upper = c.toUpperCase();
      return qTokens.every(upper.contains);
    }

    return candidates.where(allTokensIn).firstOrNull;
  }

  /// Load jadwal dengan lokasi default Jakarta Pusat.
  Future<void> loadDefaultJakarta(List<String> provinsiList) async {
    final kabkota = await getKabkotaList(defaultProvinsi);
    if (kabkota == null) {
      await onLocationDetectFailed(provinsiList);
      return;
    }

    final matched = kabkota.contains(defaultKabkota)
        ? defaultKabkota
        : kabkota.first;

    unawaited(
      saveLocation(
        provinsi: defaultProvinsi,
        kabkota: matched,
      ),
    );

    await onLocationDetected(
      provinsiList: provinsiList,
      selectedProvinsi: defaultProvinsi,
      selectedKabkota: matched,
      kabkotaList: kabkota,
    );
  }
}
