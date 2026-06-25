import 'dart:async';

import 'package:equran_app/core/location/location_service.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_kabkota.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_last_location_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_provinsi.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/params/imsakiyah_params.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/save_last_location_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/presentation/viewmodels/imsakiyah_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImsakiyahViewModel extends StateNotifier<ImsakiyahState> {
  ImsakiyahViewModel(
    this._getProvinsi,
    this._getKabkota,
    this._getImsakiyah,
    this._getLastLocation,
    this._saveLastLocation,
    this._locationService,
  ) : super(const ImsakiyahState.initial());

  final GetProvinsi _getProvinsi;
  final GetKabkota _getKabkota;
  final GetImsakiyah _getImsakiyah;
  final GetLastLocationImsakiyah _getLastLocation;
  final SaveLastLocationImsakiyah _saveLastLocation;
  final LocationService _locationService;

  static const _defaultProvinsi = 'DKI Jakarta';
  static const _defaultKabkota = 'Kota Jakarta Pusat';

  // ─── Public API ──────────────────────────────────────────────────────────────

  Future<void> init() async {
    state = const ImsakiyahState.loadingProvinsi();

    final result = await _getProvinsi();
    await result.fold(
      (failure) async => state = ImsakiyahState.failure(failure: failure),
      (provinsi) async {
        final lastLocationResult = await _getLastLocation();
        final lastProvinsi = lastLocationResult.fold(
          (_) => null,
          (l) => l.provinsi,
        );
        final lastKabkota = lastLocationResult.fold(
          (_) => null,
          (l) => l.kabkota,
        );

        if (lastProvinsi != null &&
            provinsi.contains(lastProvinsi) &&
            lastKabkota != null) {
          await _autoLoadJadwal(
            provinsiList: provinsi,
            selectedProvinsi: lastProvinsi,
            selectedKabkota: lastKabkota,
          );
          return;
        }

        await _autoDetectLocation(provinsi);
      },
    );
  }

  Future<void> selectProvinsi(String provinsi) async {
    final currentProvinsiList = _extractProvinsiList();
    state = ImsakiyahState.loadingKabkota(
      provinsi: currentProvinsiList,
      selectedProvinsi: provinsi,
    );

    final result = await _getKabkota(GetKabkotaParams(provinsi));
    result.fold(
      (failure) => state = ImsakiyahState.failure(
        failure: failure,
        provinsi: currentProvinsiList,
        selectedProvinsi: provinsi,
      ),
      (kabkota) => state = ImsakiyahState.kabkotaLoaded(
        provinsi: currentProvinsiList,
        selectedProvinsi: provinsi,
        kabkota: kabkota,
      ),
    );
  }

  Future<void> selectKabkota(String kabkota) async {
    final provinsiList = _extractProvinsiList();
    final selectedProvinsi = _extractSelectedProvinsi();
    final kabkotaList = _extractKabkotaList();

    if (selectedProvinsi == null) return;

    unawaited(
      _saveLastLocation(
        SaveLastLocationParams(provinsi: selectedProvinsi, kabkota: kabkota),
      ),
    );

    await _autoLoadJadwal(
      provinsiList: provinsiList,
      selectedProvinsi: selectedProvinsi,
      selectedKabkota: kabkota,
      kabkotaList: kabkotaList,
    );
  }

  Future<void> retry() async {
    final current = state;
    if (current is ImsakiyahFailure) {
      final provinsi = current.selectedProvinsi;
      final kabkota = current.selectedKabkota;

      if (provinsi != null && kabkota != null) {
        await selectKabkota(kabkota);
      } else if (provinsi != null) {
        await selectProvinsi(provinsi);
      } else {
        await init();
      }
    } else {
      await init();
    }
  }

  // ─── GPS Detection (inlined from LocationSelectionMixin) ────────────────────

  Future<void> _autoDetectLocation(List<String> provinsiList) async {
    state = const ImsakiyahState.detectingLocation();

    final detected = await _locationService.detectCurrentLocation();

    if (detected != null) {
      final matchedProvinsi = _fuzzyMatch(detected.provinsi, provinsiList);

      if (matchedProvinsi != null) {
        final kabkota = await _getKabkotaList(matchedProvinsi);
        if (kabkota != null) {
          final matchedKabkota = _fuzzyMatch(detected.kabkota, kabkota);

          if (matchedKabkota != null) {
            unawaited(
              _saveLastLocation(
                SaveLastLocationParams(
                  provinsi: matchedProvinsi,
                  kabkota: matchedKabkota,
                ),
              ),
            );
            await _autoLoadJadwal(
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

    await _loadDefaultJakarta(provinsiList);
  }

  Future<List<String>?> _getKabkotaList(String provinsi) async {
    final result = await _getKabkota(GetKabkotaParams(provinsi));
    return result.fold((_) => null, (list) => list);
  }

  Future<void> _loadDefaultJakarta(List<String> provinsiList) async {
    final kabkota = await _getKabkotaList(_defaultProvinsi);
    if (kabkota == null) {
      state = ImsakiyahState.provinsiLoaded(provinsi: provinsiList);
      return;
    }

    final matched = kabkota.contains(_defaultKabkota)
        ? _defaultKabkota
        : kabkota.first;

    unawaited(
      _saveLastLocation(
        SaveLastLocationParams(provinsi: _defaultProvinsi, kabkota: matched),
      ),
    );

    await _autoLoadJadwal(
      provinsiList: provinsiList,
      selectedProvinsi: _defaultProvinsi,
      selectedKabkota: matched,
      kabkotaList: kabkota,
    );
  }

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

  // ─── Private helpers ─────────────────────────────────────────────────────────

  Future<void> _autoLoadJadwal({
    required List<String> provinsiList,
    required String selectedProvinsi,
    required String selectedKabkota,
    List<String>? kabkotaList,
  }) async {
    final kabkota = kabkotaList ?? await _getKabkotaList(selectedProvinsi);
    if (kabkota == null) {
      state = ImsakiyahState.provinsiLoaded(provinsi: provinsiList);
      return;
    }

    if (!kabkota.contains(selectedKabkota)) {
      state = ImsakiyahState.provinsiLoaded(provinsi: provinsiList);
      return;
    }

    state = ImsakiyahState.loadingJadwal(
      provinsi: provinsiList,
      selectedProvinsi: selectedProvinsi,
      kabkota: kabkota,
      selectedKabkota: selectedKabkota,
    );

    final jadwalResult = await _getImsakiyah(
      GetImsakiyahParams(
        provinsi: selectedProvinsi,
        kabkota: selectedKabkota,
      ),
    );
    jadwalResult.fold(
      (failure) => state = ImsakiyahState.failure(
        failure: failure,
        provinsi: provinsiList,
        selectedProvinsi: selectedProvinsi,
        kabkota: kabkota,
        selectedKabkota: selectedKabkota,
      ),
      (jadwal) => state = ImsakiyahState.success(
        provinsi: provinsiList,
        selectedProvinsi: selectedProvinsi,
        kabkota: kabkota,
        selectedKabkota: selectedKabkota,
        jadwal: jadwal,
      ),
    );
  }

  List<String> _extractProvinsiList() {
    final s = state;
    return switch (s) {
      ImsakiyahProvinsiLoaded() => s.provinsi,
      ImsakiyahLoadingKabkota() => s.provinsi,
      ImsakiyahKabkotaLoaded() => s.provinsi,
      ImsakiyahLoadingJadwal() => s.provinsi,
      ImsakiyahSuccess() => s.provinsi,
      ImsakiyahFailure() => s.provinsi ?? [],
      _ => [],
    };
  }

  String? _extractSelectedProvinsi() {
    final s = state;
    return switch (s) {
      ImsakiyahLoadingKabkota() => s.selectedProvinsi,
      ImsakiyahKabkotaLoaded() => s.selectedProvinsi,
      ImsakiyahLoadingJadwal() => s.selectedProvinsi,
      ImsakiyahSuccess() => s.selectedProvinsi,
      ImsakiyahFailure() => s.selectedProvinsi,
      _ => null,
    };
  }

  List<String> _extractKabkotaList() {
    final s = state;
    return switch (s) {
      ImsakiyahKabkotaLoaded() => s.kabkota,
      ImsakiyahLoadingJadwal() => s.kabkota,
      ImsakiyahSuccess() => s.kabkota,
      ImsakiyahFailure() => s.kabkota ?? [],
      _ => [],
    };
  }
}
