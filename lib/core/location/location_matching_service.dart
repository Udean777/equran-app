import 'package:equran_app/core/location/location_service.dart';

/// Shared fuzzy matching service for location names.
///
/// Used by both imsakiyah and jadwal_shalat ViewModels
/// to match GPS-detected location names against API-provided lists.
final class LocationMatchingService {
  /// Find best match for [query] in [candidates] using multi-strategy matching.
  String? fuzzyMatch(String query, List<String> candidates) {
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

  /// Attempt auto-detection: GPS -> fuzzy match provinsi -> get kabkota -> fuzzy match kabkota.
  ///
  /// Returns matched (provinsi, kabkota) or null if detection fails.
  Future<({
    String provinsi,
    String kabkota,
  })?> autoDetectLocation({
    required LocationService locationService,
    required List<String> provinsiList,
    required Future<List<String>?> Function(String provinsi) getKabkotaList,
  }) async {
    final detected = await locationService.detectCurrentLocation();
    if (detected == null) return null;

    final matchedProvinsi = fuzzyMatch(detected.provinsi, provinsiList);
    if (matchedProvinsi == null) return null;

    final kabkota = await getKabkotaList(matchedProvinsi);
    if (kabkota == null) return null;

    final matchedKabkota = fuzzyMatch(detected.kabkota, kabkota);
    if (matchedKabkota == null) return null;

    return (provinsi: matchedProvinsi, kabkota: matchedKabkota);
  }
}
