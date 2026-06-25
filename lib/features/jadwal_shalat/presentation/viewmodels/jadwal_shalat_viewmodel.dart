import 'dart:async';

import 'package:equran_app/core/location/location_service.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_kabkota_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_provinsi_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/params/jadwal_shalat_params.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/notifications/shalat_schedule_entry.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/viewmodels/jadwal_shalat_state.dart';
import 'package:equran_app/features/jadwal_shalat/services/shalat_notif_scheduler_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JadwalShalatViewModel extends StateNotifier<JadwalShalatState> {
  JadwalShalatViewModel(
    this._getProvinsi,
    this._getKabkota,
    this._getJadwalShalat,
    this._getLastLocation,
    this._saveLastLocation,
    this._locationService,
    this._saveNotifPrefs,
    this._schedulerService,
  ) : super(const JadwalShalatState.initial());

  final GetProvinsiShalat _getProvinsi;
  final GetKabkotaShalat _getKabkota;
  final GetJadwalShalat _getJadwalShalat;
  final GetLastLocationShalat _getLastLocation;
  final SaveLastLocationShalat _saveLastLocation;
  final LocationService _locationService;
  final SaveShalatNotifPrefs _saveNotifPrefs;
  final ShalatNotifSchedulerService _schedulerService;

  static const _defaultProvinsi = 'DKI Jakarta';
  static const _defaultKabkota = 'Kota Jakarta Pusat';

  // --- Public API ---

  Future<void> init() async {
    state = const JadwalShalatState.loadingProvinsi();

    final result = await _getProvinsi();
    await result.fold(
      (failure) async => state = JadwalShalatState.failure(failure: failure),
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
    state = JadwalShalatState.loadingKabkota(
      provinsi: currentProvinsiList,
      selectedProvinsi: provinsi,
    );

    final result = await _getKabkota(GetKabkotaShalatParams(provinsi));
    result.fold(
      (failure) => state = JadwalShalatState.failure(
        failure: failure,
        provinsi: currentProvinsiList,
        selectedProvinsi: provinsi,
      ),
      (kabkota) => state = JadwalShalatState.kabkotaLoaded(
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
        SaveLastLocationShalatParams(
          provinsi: selectedProvinsi,
          kabkota: kabkota,
        ),
      ),
    );

    await _autoLoadJadwal(
      provinsiList: provinsiList,
      selectedProvinsi: selectedProvinsi,
      selectedKabkota: kabkota,
      kabkotaList: kabkotaList.isEmpty ? null : kabkotaList,
    );
  }

  Future<void> changeBulan(int bulan, int tahun) async {
    final s = state;
    if (s is! JadwalShalatSuccess) return;

    await _autoLoadJadwal(
      provinsiList: s.provinsi,
      selectedProvinsi: s.selectedProvinsi,
      selectedKabkota: s.selectedKabkota,
      kabkotaList: s.kabkota,
      bulan: bulan,
      tahun: tahun,
    );
  }

  Future<void> retry() async {
    final current = state;
    if (current is JadwalShalatFailure) {
      final provinsi = current.selectedProvinsi;
      final kabkota = current.selectedKabkota;
      final bulan = current.bulan;
      final tahun = current.tahun;

      if (provinsi != null && kabkota != null) {
        await _autoLoadJadwal(
          provinsiList: current.provinsi ?? [],
          selectedProvinsi: provinsi,
          selectedKabkota: kabkota,
          kabkotaList: current.kabkota,
          bulan: bulan,
          tahun: tahun,
        );
      } else if (provinsi != null) {
        await selectProvinsi(provinsi);
      } else {
        await init();
      }
    } else {
      await init();
    }
  }

  Future<void> updateNotifPrefs(ShalatNotifPrefs prefs) async {
    await _saveNotifPrefs(prefs);
    final s = state;
    if (s is JadwalShalatSuccess) {
      _scheduleNotifications(s.jadwal, s.bulan, s.tahun);
    }
  }

  // --- GPS Detection (inlined from LocationSelectionMixin) ---

  Future<void> _autoDetectLocation(List<String> provinsiList) async {
    state = const JadwalShalatState.detectingLocation();

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
                SaveLastLocationShalatParams(
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
    final result = await _getKabkota(GetKabkotaShalatParams(provinsi));
    return result.fold((_) => null, (list) => list);
  }

  Future<void> _loadDefaultJakarta(List<String> provinsiList) async {
    final kabkota = await _getKabkotaList(_defaultProvinsi);
    if (kabkota == null) {
      state = JadwalShalatState.provinsiLoaded(provinsi: provinsiList);
      return;
    }

    final matched = kabkota.contains(_defaultKabkota)
        ? _defaultKabkota
        : kabkota.first;

    unawaited(
      _saveLastLocation(
        SaveLastLocationShalatParams(
          provinsi: _defaultProvinsi,
          kabkota: matched,
        ),
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

  // --- Private helpers ---

  Future<void> _autoLoadJadwal({
    required List<String> provinsiList,
    required String selectedProvinsi,
    required String selectedKabkota,
    List<String>? kabkotaList,
    int? bulan,
    int? tahun,
  }) async {
    final now = DateTime.now();
    final targetBulan = bulan ?? now.month;
    final targetTahun = tahun ?? now.year;

    final kabkota = kabkotaList ?? await _getKabkotaList(selectedProvinsi);
    if (kabkota == null) {
      state = JadwalShalatState.provinsiLoaded(provinsi: provinsiList);
      return;
    }

    if (!kabkota.contains(selectedKabkota)) {
      state = JadwalShalatState.provinsiLoaded(provinsi: provinsiList);
      return;
    }

    state = JadwalShalatState.loadingJadwal(
      provinsi: provinsiList,
      selectedProvinsi: selectedProvinsi,
      kabkota: kabkota,
      selectedKabkota: selectedKabkota,
      bulan: targetBulan,
      tahun: targetTahun,
    );

    final jadwalResult = await _getJadwalShalat(
      GetJadwalShalatParams(
        provinsi: selectedProvinsi,
        kabkota: selectedKabkota,
        bulan: targetBulan,
        tahun: targetTahun,
      ),
    );
    jadwalResult.fold(
      (failure) => state = JadwalShalatState.failure(
        failure: failure,
        provinsi: provinsiList,
        selectedProvinsi: selectedProvinsi,
        kabkota: kabkota,
        selectedKabkota: selectedKabkota,
        bulan: targetBulan,
        tahun: targetTahun,
      ),
      (jadwal) {
        state = JadwalShalatState.success(
          provinsi: provinsiList,
          selectedProvinsi: selectedProvinsi,
          kabkota: kabkota,
          selectedKabkota: selectedKabkota,
          jadwal: jadwal,
          bulan: targetBulan,
          tahun: targetTahun,
        );
        final now = DateTime.now();
        if (targetBulan == now.month && targetTahun == now.year) {
          _scheduleNotifications(jadwal, targetBulan, targetTahun);
        }
      },
    );
  }

  void _scheduleNotifications(JadwalShalat jadwal, int bulan, int tahun) {
    final now = DateTime.now();
    final futureEntries = jadwal.jadwal
        .where((e) => e.tanggal >= now.day)
        .take(2)
        .map((e) => _toScheduleEntry(e, bulan, tahun))
        .toList();

    if (futureEntries.isEmpty) return;

    unawaited(_schedulerService.scheduleForEntries(futureEntries));
  }

  ShalatScheduleEntry _toScheduleEntry(
    JadwalShalatEntry entry,
    int bulan,
    int tahun,
  ) => ShalatScheduleEntry(
    date: DateTime(tahun, bulan, entry.tanggal),
    subuh: entry.subuh,
    dzuhur: entry.dzuhur,
    ashar: entry.ashar,
    maghrib: entry.maghrib,
    isya: entry.isya,
  );

  List<String> _extractProvinsiList() {
    final s = state;
    return switch (s) {
      JadwalShalatProvinsiLoaded() => s.provinsi,
      JadwalShalatLoadingKabkota() => s.provinsi,
      JadwalShalatKabkotaLoaded() => s.provinsi,
      JadwalShalatLoadingJadwal() => s.provinsi,
      JadwalShalatSuccess() => s.provinsi,
      JadwalShalatFailure() => s.provinsi ?? [],
      _ => [],
    };
  }

  String? _extractSelectedProvinsi() {
    final s = state;
    return switch (s) {
      JadwalShalatLoadingKabkota() => s.selectedProvinsi,
      JadwalShalatKabkotaLoaded() => s.selectedProvinsi,
      JadwalShalatLoadingJadwal() => s.selectedProvinsi,
      JadwalShalatSuccess() => s.selectedProvinsi,
      JadwalShalatFailure() => s.selectedProvinsi,
      _ => null,
    };
  }

  List<String> _extractKabkotaList() {
    final s = state;
    return switch (s) {
      JadwalShalatKabkotaLoaded() => s.kabkota,
      JadwalShalatLoadingJadwal() => s.kabkota,
      JadwalShalatSuccess() => s.kabkota,
      JadwalShalatFailure() => s.kabkota ?? [],
      _ => [],
    };
  }
}
