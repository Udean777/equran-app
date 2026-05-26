import 'dart:async';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/location/location_service.dart';
import 'package:equran_app/core/utils/string_utils.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_kabkota.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_last_location_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_provinsi.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/save_last_location_imsakiyah.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'imsakiyah_cubit.freezed.dart';
part 'imsakiyah_state.dart';

@injectable
class ImsakiyahCubit extends Cubit<ImsakiyahState> {
  ImsakiyahCubit(
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

  /// Load provinsi list + restore last location jika ada,
  /// atau auto-detect dari GPS jika belum pernah dipilih.
  Future<void> init() async {
    emit(const ImsakiyahState.loadingProvinsi());

    final result = await _getProvinsi();
    await result.fold(
      (failure) async => emit(ImsakiyahState.failure(failure: failure)),
      (provinsi) async {
        // 1. Coba restore lokasi terakhir (saved preference)
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

        // 2. Belum ada riwayat → coba auto-detect dari GPS
        emit(const ImsakiyahState.detectingLocation());
        final detected = await _locationService.detectCurrentLocation();

        if (detected != null) {
          // Cocokkan dengan daftar provinsi (case-insensitive partial match)
          final matchedProvinsi = fuzzyMatch(detected.provinsi, provinsi);

          if (matchedProvinsi != null) {
            final kabkotaResult = await _getKabkota(matchedProvinsi);
            await kabkotaResult.fold(
              (failure) async =>
                  emit(ImsakiyahState.provinsiLoaded(provinsi: provinsi)),
              (kabkota) async {
                final matchedKabkota = fuzzyMatch(detected.kabkota, kabkota);

                if (matchedKabkota != null) {
                  // Simpan preferensi dan langsung load jadwal
                  unawaited(
                    _saveLastLocation(
                      provinsi: matchedProvinsi,
                      kabkota: matchedKabkota,
                    ),
                  );
                  await _autoLoadJadwal(
                    provinsiList: provinsi,
                    selectedProvinsi: matchedProvinsi,
                    selectedKabkota: matchedKabkota,
                    kabkotaList: kabkota,
                  );
                } else {
                  // Provinsi cocok tapi kabkota tidak → pre-select provinsi
                  emit(
                    ImsakiyahState.kabkotaLoaded(
                      provinsi: provinsi,
                      selectedProvinsi: matchedProvinsi,
                      kabkota: kabkota,
                    ),
                  );
                }
              },
            );
            return;
          }
        }

        // 3. GPS gagal / tidak cocok → default Jakarta
        await _loadDefaultJakarta(provinsiList: provinsi);
      },
    );
  }

  static const _defaultProvinsi = 'DKI Jakarta';
  static const _defaultKabkota = 'Kota Jakarta Pusat';

  /// Fallback: load jadwal dengan lokasi default Jakarta Pusat.
  Future<void> _loadDefaultJakarta({required List<String> provinsiList}) async {
    final kabkotaResult = await _getKabkota(_defaultProvinsi);
    await kabkotaResult.fold(
      (failure) async =>
          emit(ImsakiyahState.provinsiLoaded(provinsi: provinsiList)),
      (kabkota) async {
        // Cari kabkota Jakarta Pusat, fallback ke first jika tidak ada
        final matched = kabkota.contains(_defaultKabkota)
            ? _defaultKabkota
            : kabkota.first;
        unawaited(
          _saveLastLocation(
            provinsi: _defaultProvinsi,
            kabkota: matched,
          ),
        );
        await _autoLoadJadwal(
          provinsiList: provinsiList,
          selectedProvinsi: _defaultProvinsi,
          selectedKabkota: matched,
          kabkotaList: kabkota,
        );
      },
    );
  }

  /// Auto-load jadwal dengan provinsi & kabkota yang sudah diketahui.
  Future<void> _autoLoadJadwal({
    required List<String> provinsiList,
    required String selectedProvinsi,
    required String selectedKabkota,
    List<String>? kabkotaList,
  }) async {
    // Jika kabkotaList belum tersedia, load dulu
    final kabkota = kabkotaList ?? await _fetchKabkotaList(selectedProvinsi);
    if (kabkota == null) {
      emit(ImsakiyahState.provinsiLoaded(provinsi: provinsiList));
      return;
    }

    // Validasi kabkota ada di dalam list
    if (!kabkota.contains(selectedKabkota)) {
      emit(ImsakiyahState.provinsiLoaded(provinsi: provinsiList));
      return;
    }

    emit(
      ImsakiyahState.loadingJadwal(
        provinsi: provinsiList,
        selectedProvinsi: selectedProvinsi,
        kabkota: kabkota,
        selectedKabkota: selectedKabkota,
      ),
    );

    final jadwalResult = await _getImsakiyah(
      provinsi: selectedProvinsi,
      kabkota: selectedKabkota,
    );
    jadwalResult.fold(
      (failure) => emit(
        ImsakiyahState.failure(
          failure: failure,
          provinsi: provinsiList,
          selectedProvinsi: selectedProvinsi,
          kabkota: kabkota,
          selectedKabkota: selectedKabkota,
        ),
      ),
      (jadwal) => emit(
        ImsakiyahState.success(
          provinsi: provinsiList,
          selectedProvinsi: selectedProvinsi,
          kabkota: kabkota,
          selectedKabkota: selectedKabkota,
          jadwal: jadwal,
        ),
      ),
    );
  }

  /// Fetch kabkota list, return null jika gagal.
  Future<List<String>?> _fetchKabkotaList(String provinsi) async {
    final result = await _getKabkota(provinsi);
    return result.fold((_) => null, (list) => list);
  }

  /// Fuzzy match: cari item dalam candidates yang paling mendekati query.
  ///
  /// Geocoding sering mengembalikan nama tanpa prefix (e.g. "Medan", "Deli Serdang")
  /// sedangkan API mengembalikan "Kota Medan" atau "Kab. Deli Serdang".
  /// User memilih provinsi → load kabkota
  Future<void> selectProvinsi(String provinsi) async {
    final currentProvinsiList = _extractProvinsiList();
    emit(
      ImsakiyahState.loadingKabkota(
        provinsi: currentProvinsiList,
        selectedProvinsi: provinsi,
      ),
    );

    final result = await _getKabkota(provinsi);
    result.fold(
      (failure) => emit(
        ImsakiyahState.failure(
          failure: failure,
          provinsi: currentProvinsiList,
          selectedProvinsi: provinsi,
        ),
      ),
      (kabkota) => emit(
        ImsakiyahState.kabkotaLoaded(
          provinsi: currentProvinsiList,
          selectedProvinsi: provinsi,
          kabkota: kabkota,
        ),
      ),
    );
  }

  /// User memilih kabkota → load jadwal
  Future<void> selectKabkota(String kabkota) async {
    final provinsiList = _extractProvinsiList();
    final selectedProvinsi = _extractSelectedProvinsi();
    final kabkotaList = _extractKabkotaList();

    if (selectedProvinsi == null) return;

    emit(
      ImsakiyahState.loadingJadwal(
        provinsi: provinsiList,
        selectedProvinsi: selectedProvinsi,
        kabkota: kabkotaList,
        selectedKabkota: kabkota,
      ),
    );

    // Simpan preferensi
    unawaited(
      _saveLastLocation(
        provinsi: selectedProvinsi,
        kabkota: kabkota,
      ),
    );

    final result = await _getImsakiyah(
      provinsi: selectedProvinsi,
      kabkota: kabkota,
    );
    result.fold(
      (failure) => emit(
        ImsakiyahState.failure(
          failure: failure,
          provinsi: provinsiList,
          selectedProvinsi: selectedProvinsi,
          kabkota: kabkotaList,
          selectedKabkota: kabkota,
        ),
      ),
      (jadwal) => emit(
        ImsakiyahState.success(
          provinsi: provinsiList,
          selectedProvinsi: selectedProvinsi,
          kabkota: kabkotaList,
          selectedKabkota: kabkota,
          jadwal: jadwal,
        ),
      ),
    );
  }

  /// Retry dari failure state
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

  // --- helpers ---

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
