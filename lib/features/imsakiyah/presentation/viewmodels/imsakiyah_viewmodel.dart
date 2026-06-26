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
  GetLastLocationImsakiyah get _getLastLocation =>
      ref.read(getLastLocationImsakiyahProvider);
  SaveLastLocationImsakiyah get _saveLastLocation =>
      ref.read(saveLastLocationImsakiyahProvider);
  LocationService get _locationService => ref.read(locationServiceProvider);
  LocationMatchingService get _matchingService =>
      ref.read(locationMatchingServiceProvider);

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
    final provinsiList = state.provinsiList;
    state = ImsakiyahState.loadingKabkota(
      provinsi: provinsiList,
      selectedProvinsi: provinsi,
    );

    final result = await _getKabkota(GetKabkotaParams(provinsi));
    result.fold(
      (failure) => state = ImsakiyahState.failure(
        failure: failure,
        provinsi: provinsiList,
        selectedProvinsi: provinsi,
      ),
      (kabkota) => state = ImsakiyahState.kabkotaLoaded(
        provinsi: provinsiList,
        selectedProvinsi: provinsi,
        kabkota: kabkota,
      ),
    );
  }

  Future<void> selectKabkota(String kabkota) async {
    final provinsiList = state.provinsiList;
    final selectedProvinsi = state.selectedProvinsi;
    final kabkotaList = state.kabkotaList;

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

    await _fallbackToFirstProvinsi(provinsiList);
  }

  Future<void> _fallbackToFirstProvinsi(List<String> provinsiList) async {
    final firstProvinsi = provinsiList.first;
    final kabkotaResult = await _getKabkota(
      GetKabkotaParams(firstProvinsi),
    );
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
        SaveLastLocationParams(provinsi: firstProvinsi, kabkota: matched),
      ),
    );

    await _autoLoadJadwal(
      provinsiList: provinsiList,
      selectedProvinsi: firstProvinsi,
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
    final kabkota =
        kabkotaList ??
        (await _getKabkota(
          GetKabkotaParams(selectedProvinsi),
        )).fold((_) => null, (list) => list);
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
}
