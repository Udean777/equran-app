import 'dart:async';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/location/location_selection_mixin.dart';
import 'package:equran_app/core/location/location_service.dart';
import 'package:equran_app/core/notifications/shalat_notif_config.dart';
import 'package:equran_app/core/notifications/shalat_notification_scheduler.dart';
import 'package:equran_app/core/notifications/shalat_schedule_entry.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_kabkota_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_provinsi_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/get_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_last_location_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/usecases/save_shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/shalat_notif_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'jadwal_shalat_cubit.freezed.dart';
part 'jadwal_shalat_state.dart';

@injectable
class JadwalShalatCubit extends Cubit<JadwalShalatState>
    with LocationSelectionMixin<JadwalShalatState> {
  JadwalShalatCubit(
    this._getProvinsi,
    this._getKabkota,
    this._getJadwalShalat,
    this._getLastLocation,
    this._saveLastLocation,
    this.locationService,
    this._scheduler,
    this._getNotifPrefs,
    this._saveNotifPrefs,
    this._shalatNotifCubit,
  ) : super(const JadwalShalatState.initial());

  final GetProvinsiShalat _getProvinsi;
  final GetKabkotaShalat _getKabkota;
  final GetJadwalShalat _getJadwalShalat;
  final GetLastLocationShalat _getLastLocation;
  final SaveLastLocationShalat _saveLastLocation;
  @override
  final LocationService locationService;
  final ShalatNotificationScheduler _scheduler;
  final GetShalatNotifPrefs _getNotifPrefs;
  final SaveShalatNotifPrefs _saveNotifPrefs;
  final ShalatNotifCubit _shalatNotifCubit;
  // ─── LocationSelectionMixin overrides ────────────────────────────────────────

  @override
  Future<List<String>?> getKabkotaList(String provinsi) async {
    final result = await _getKabkota(provinsi);
    return result.fold((_) => null, (list) => list);
  }

  @override
  Future<void> saveLocation({
    required String provinsi,
    required String kabkota,
  }) =>
      _saveLastLocation(provinsi: provinsi, kabkota: kabkota);

  @override
  Future<void> onLocationDetected({
    required List<String> provinsiList,
    required String selectedProvinsi,
    required String selectedKabkota,
    List<String>? kabkotaList,
  }) =>
      _autoLoadJadwal(
        provinsiList: provinsiList,
        selectedProvinsi: selectedProvinsi,
        selectedKabkota: selectedKabkota,
        kabkotaList: kabkotaList,
      );

  @override
  void onDetectingLocation() {
    emit(const JadwalShalatState.detectingLocation());
  }

  @override
  Future<void> onLocationDetectFailed(List<String> provinsiList) =>
      loadDefaultJakarta(provinsiList);

  // ─── Public API ──────────────────────────────────────────────────────────────

  /// Load provinsi list + restore last location jika ada,
  /// atau auto-detect dari GPS, fallback ke Jakarta.
  Future<void> init() async {
    emit(const JadwalShalatState.loadingProvinsi());

    final result = await _getProvinsi();
    await result.fold(
      (failure) async => emit(JadwalShalatState.failure(failure: failure)),
      (provinsi) async {
        // 1. Coba restore lokasi terakhir
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

        // 2. Belum ada riwayat → auto-detect GPS (mixin)
        await autoDetectLocation(provinsi);
      },
    );
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

    unawaited(
      saveLocation(
        provinsi: selectedProvinsi,
        kabkota: kabkota,
      ),
    );

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

  /// Update preferensi notifikasi + reschedule.
  Future<void> updateNotifPrefs(ShalatNotifPrefs prefs) async {
    await _saveNotifPrefs(prefs);
    final s = state;
    if (s is JadwalShalatSuccess) {
      _scheduleNotifications(s.jadwal);
    }
  }

  // ─── Private helpers ─────────────────────────────────────────────────────────

  /// Auto-load jadwal dengan provinsi & kabkota yang sudah diketahui.
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

    final kabkota = kabkotaList ?? await getKabkotaList(selectedProvinsi);
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
        final now = DateTime.now();
        if (targetBulan == now.month && targetTahun == now.year) {
          _scheduleNotifications(jadwal);
        }
      },
    );
  }

  /// Schedule notifikasi untuk entry hari ini dari [jadwal].
  void _scheduleNotifications(JadwalShalat jadwal) {
    final now = DateTime.now();
    final todayEntry = jadwal.jadwal
        .where((e) => e.tanggal == now.day)
        .firstOrNull;

    if (todayEntry == null) return;

    final entry = _toScheduleEntry(todayEntry);
    _shalatNotifCubit.setTodayEntry(entry);

    unawaited(
      _getNotifPrefs()
          .then((result) {
            final prefs = result.fold(
              (_) => const ShalatNotifPrefs(),
              (p) => p,
            );
            unawaited(
              _scheduler.scheduleForToday(
                entry,
                _toNotifConfig(prefs),
              ),
            );
          })
          .catchError((Object e) {
            debugPrint('JadwalShalatCubit: schedule notification error: $e');
          }),
    );
  }

  ShalatScheduleEntry _toScheduleEntry(JadwalShalatEntry entry) =>
      ShalatScheduleEntry(
        subuh: entry.subuh,
        dzuhur: entry.dzuhur,
        ashar: entry.ashar,
        maghrib: entry.maghrib,
        isya: entry.isya,
      );

  ShalatNotifConfig _toNotifConfig(ShalatNotifPrefs prefs) => ShalatNotifConfig(
    subuh: prefs.subuh,
    dzuhur: prefs.dzuhur,
    ashar: prefs.ashar,
    maghrib: prefs.maghrib,
    isya: prefs.isya,
    menitSebelum: prefs.menitSebelum,
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
