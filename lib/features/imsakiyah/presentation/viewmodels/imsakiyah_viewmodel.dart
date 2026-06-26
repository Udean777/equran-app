import 'dart:async';

import 'package:equran_app/core/location/location_matching_service.dart';
import 'package:equran_app/core/location/location_service.dart';
import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_kabkota.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_last_location_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_provinsi.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/params/imsakiyah_params.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/save_last_location_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImsakiyahViewModel extends AutoDisposeNotifier<ImsakiyahState> {
  @override
  ImsakiyahState build() => const ImsakiyahState.initial();

  GetProvinsi get _getProvinsi => ref.read(getProvinsiProvider);
  GetKabkota get _getKabkota => ref.read(getKabkotaProvider);
  GetImsakiyah get _getImsakiyah => ref.read(getImsakiyahProvider);
  GetLastLocationImsakiyah get _getLastLocation => ref.read(getLastLocationImsakiyahProvider);
  SaveLastLocationImsakiyah get _saveLastLocation =>
      ref.read(saveLastLocationImsakiyahProvider);
  LocationService get _locationService => ref.read(locationServiceProvider);
  LocationMatchingService get _matchingService =>
      ref.read(locationMatchingServiceProvider);

  static const _defaultProvinsi = 'DKI Jakarta';
  static const _defaultKabkota = 'Kota Jakarta Pusat';

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

  Future<void> _autoDetectLocation(List<String> provinsiList) async {
    state = const ImsakiyahState.detectingLocation();

    final matched = await _matchingService.autoDetectLocation(
      locationService: _locationService,
      provinsiList: provinsiList,
      getKabkotaList: (provinsi) async {
        final result = await _getKabkota(GetKabkotaParams(provinsi));
        return result.fold((_) => null, (list) => list);
      },
    );

    if (matched != null) {
      unawaited(
        _saveLastLocation(
          SaveLastLocationParams(
            provinsi: matched.provinsi,
            kabkota: matched.kabkota,
          ),
        ),
      );
      await _autoLoadJadwal(
        provinsiList: provinsiList,
        selectedProvinsi: matched.provinsi,
        selectedKabkota: matched.kabkota,
      );
      return;
    }

    await _loadDefaultJakarta(provinsiList);
  }

  Future<void> _loadDefaultJakarta(List<String> provinsiList) async {
    final kabkotaResult = await _getKabkota(const GetKabkotaParams(_defaultProvinsi));
    final kabkota = kabkotaResult.fold((_) => null, (list) => list);
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

  Future<void> _autoLoadJadwal({
    required List<String> provinsiList,
    required String selectedProvinsi,
    required String selectedKabkota,
    List<String>? kabkotaList,
  }) async {
    final kabkota = kabkotaList ??
        (await _getKabkota(GetKabkotaParams(selectedProvinsi)))
            .fold((_) => null, (list) => list);
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
