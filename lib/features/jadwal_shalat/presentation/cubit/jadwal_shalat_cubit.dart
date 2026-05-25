import 'dart:async';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/location/location_service.dart';
import 'package:equran_app/core/notifications/shalat_notification_scheduler.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_local_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_kabkota_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_provinsi_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_shalat_notif_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'jadwal_shalat_cubit.freezed.dart';
part 'jadwal_shalat_state.dart';

@injectable
class JadwalShalatCubit extends Cubit<JadwalShalatState> {
  JadwalShalatCubit(
    this._getProvinsi,
    this._getKabkota,
    this._getJadwalShalat,
    this._local,
    this._locationService,
    this._scheduler,
    this._getNotifPrefs,
    this._saveNotifPrefs,
  ) : super(const JadwalShalatState.initial());

  final GetProvinsiShalat _getProvinsi;
  final GetKabkotaShalat _getKabkota;
  final GetJadwalShalat _getJadwalShalat;
  final JadwalShalatLocalDataSource _local;
  final LocationService _locationService;
  final ShalatNotificationScheduler _scheduler;
  final GetShalatNotifPrefs _getNotifPrefs;
  final SaveShalatNotifPrefs _saveNotifPrefs;

  static const _defaultProvinsi = 'DKI Jakarta';
  static const _defaultKabkota = 'Kota Jakarta';

  /// Load provinsi list + restore last location jika ada,
  /// atau auto-detect dari GPS, fallback ke Jakarta.
  Future<void> init() async {
    emit(const JadwalShalatState.loadingProvinsi());

    final result = await _getProvinsi();
    await result.fold(
      (failure) async => emit(JadwalShalatState.failure(failure: failure)),
      (provinsi) async {
        // 1. Coba restore lokasi terakhir
        final lastProvinsi = await _local.getLastProvinsi();
        final lastKabkota = await _local.getLastKabkota();

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
        emit(const JadwalShalatState.detectingLocation());
        final detected = await _locationService.detectCurrentLocation();

        if (detected != null) {
          final matchedProvinsi = _fuzzyMatch(detected.provinsi, provinsi);

          if (matchedProvinsi != null) {
            final kabkotaResult = await _getKabkota(matchedProvinsi);
            await kabkotaResult.fold(
              (failure) async =>
                  emit(JadwalShalatState.provinsiLoaded(provinsi: provinsi)),
              (kabkota) async {
                final matchedKabkota = _fuzzyMatch(detected.kabkota, kabkota);

                if (matchedKabkota != null) {
                  await _local.saveLastProvinsi(matchedProvinsi);
                  await _local.saveLastKabkota(matchedKabkota);
                  await _autoLoadJadwal(
                    provinsiList: provinsi,
                    selectedProvinsi: matchedProvinsi,
                    selectedKabkota: matchedKabkota,
                    kabkotaList: kabkota,
                  );
                } else {
                  emit(
                    JadwalShalatState.kabkotaLoaded(
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

  /// Fallback: load jadwal dengan lokasi default Jakarta.
  Future<void> _loadDefaultJakarta({required List<String> provinsiList}) async {
    final kabkotaResult = await _getKabkota(_defaultProvinsi);
    await kabkotaResult.fold(
      (failure) async =>
          emit(JadwalShalatState.provinsiLoaded(provinsi: provinsiList)),
      (kabkota) async {
        final matched = kabkota.contains(_defaultKabkota)
            ? _defaultKabkota
            : kabkota.first;
        await _local.saveLastProvinsi(_defaultProvinsi);
        await _local.saveLastKabkota(matched);
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
  /// Bulan & tahun default = sekarang (UTC+7).
  Future<void> _autoLoadJadwal({
    required List<String> provinsiList,
    required String selectedProvinsi,
    required String selectedKabkota,
    List<String>? kabkotaList,
    int? bulan,
    int? tahun,
  }) async {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final targetBulan = bulan ?? now.month;
    final targetTahun = tahun ?? now.year;

    final kabkota = kabkotaList ?? await _fetchKabkotaList(selectedProvinsi);
    if (kabkota == null) {
      emit(JadwalShalatState.provinsiLoaded(provinsi: provinsiList));
      return;
    }

    if (!kabkota.contains(selectedKabkota)) {
      emit(JadwalShalatState.provinsiLoaded(provinsi: provinsiList));
      return;
    }

    emit(
      JadwalShalatState.loadingJadwal(
        provinsi: provinsiList,
        selectedProvinsi: selectedProvinsi,
        kabkota: kabkota,
        selectedKabkota: selectedKabkota,
        bulan: targetBulan,
        tahun: targetTahun,
      ),
    );

    final jadwalResult = await _getJadwalShalat(
      provinsi: selectedProvinsi,
      kabkota: selectedKabkota,
      bulan: targetBulan,
      tahun: targetTahun,
    );
    jadwalResult.fold(
      (failure) => emit(
        JadwalShalatState.failure(
          failure: failure,
          provinsi: provinsiList,
          selectedProvinsi: selectedProvinsi,
          kabkota: kabkota,
          selectedKabkota: selectedKabkota,
          bulan: targetBulan,
          tahun: targetTahun,
        ),
      ),
      (jadwal) {
        emit(
          JadwalShalatState.success(
            provinsi: provinsiList,
            selectedProvinsi: selectedProvinsi,
            kabkota: kabkota,
            selectedKabkota: selectedKabkota,
            jadwal: jadwal,
            bulan: targetBulan,
            tahun: targetTahun,
          ),
        );
        // Schedule notifikasi untuk hari ini jika bulan = bulan ini
        final now = DateTime.now().toUtc().add(const Duration(hours: 7));
        if (targetBulan == now.month && targetTahun == now.year) {
          _scheduleNotifications(jadwal);
        }
      },
    );
  }

  /// Fetch kabkota list, return null jika gagal.
  Future<List<String>?> _fetchKabkotaList(String provinsi) async {
    final result = await _getKabkota(provinsi);
    return result.fold((_) => null, (list) => list);
  }

  /// User memilih provinsi → load kabkota
  Future<void> selectProvinsi(String provinsi) async {
    final currentProvinsiList = _extractProvinsiList();
    emit(
      JadwalShalatState.loadingKabkota(
        provinsi: currentProvinsiList,
        selectedProvinsi: provinsi,
      ),
    );

    final result = await _getKabkota(provinsi);
    result.fold(
      (failure) => emit(
        JadwalShalatState.failure(
          failure: failure,
          provinsi: currentProvinsiList,
          selectedProvinsi: provinsi,
        ),
      ),
      (kabkota) => emit(
        JadwalShalatState.kabkotaLoaded(
          provinsi: currentProvinsiList,
          selectedProvinsi: provinsi,
          kabkota: kabkota,
        ),
      ),
    );
  }

  /// User memilih kabkota → load jadwal bulan ini
  Future<void> selectKabkota(String kabkota) async {
    final provinsiList = _extractProvinsiList();
    final selectedProvinsi = _extractSelectedProvinsi();
    final kabkotaList = _extractKabkotaList();

    if (selectedProvinsi == null) return;

    await _local.saveLastProvinsi(selectedProvinsi);
    await _local.saveLastKabkota(kabkota);

    await _autoLoadJadwal(
      provinsiList: provinsiList,
      selectedProvinsi: selectedProvinsi,
      selectedKabkota: kabkota,
      kabkotaList: kabkotaList.isEmpty ? null : kabkotaList,
    );
  }

  /// Navigasi ke bulan lain (prev/next)
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

  /// Retry dari failure state
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

  /// Fuzzy match — sama dengan ImsakiyahCubit
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

  /// Update preferensi notifikasi + reschedule.
  Future<void> updateNotifPrefs(ShalatNotifPrefs prefs) async {
    await _saveNotifPrefs(prefs);
    final s = state;
    if (s is JadwalShalatSuccess) {
      _scheduleNotifications(s.jadwal);
    }
  }

  /// Schedule notifikasi untuk entry hari ini dari [jadwal].
  void _scheduleNotifications(JadwalShalat jadwal) {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final todayEntry = jadwal.jadwal
        .where((e) => e.tanggal == now.day)
        .firstOrNull;

    if (todayEntry == null) return;

    unawaited(
      _getNotifPrefs().then((result) {
        unawaited(
          result.fold(
            (_) => _scheduler.scheduleForToday(
              todayEntry,
              const ShalatNotifPrefs(),
            ),
            (prefs) => _scheduler.scheduleForToday(todayEntry, prefs),
          ),
        );
      }).catchError((Object e) {
        debugPrint('JadwalShalatCubit: schedule notification error: $e');
      }),
    );
  }

  // --- helpers ---

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
