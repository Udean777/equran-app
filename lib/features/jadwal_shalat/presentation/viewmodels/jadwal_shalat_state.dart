import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'jadwal_shalat_state.freezed.dart';

@freezed
sealed class JadwalShalatState with _$JadwalShalatState {
  const factory JadwalShalatState.initial() = JadwalShalatInitial;

  const factory JadwalShalatState.loadingProvinsi() =
      JadwalShalatLoadingProvinsi;

  const factory JadwalShalatState.detectingLocation() =
      JadwalShalatDetectingLocation;

  const factory JadwalShalatState.provinsiLoaded({
    required List<String> provinsi,
  }) = JadwalShalatProvinsiLoaded;

  const factory JadwalShalatState.loadingKabkota({
    required List<String> provinsi,
    required String selectedProvinsi,
  }) = JadwalShalatLoadingKabkota;

  const factory JadwalShalatState.kabkotaLoaded({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
  }) = JadwalShalatKabkotaLoaded;

  const factory JadwalShalatState.loadingJadwal({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
    required String selectedKabkota,
    required int bulan,
    required int tahun,
  }) = JadwalShalatLoadingJadwal;

  const factory JadwalShalatState.success({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
    required String selectedKabkota,
    required JadwalShalat jadwal,
    required int bulan,
    required int tahun,
  }) = JadwalShalatSuccess;

  const factory JadwalShalatState.failure({
    required Failure failure,
    List<String>? provinsi,
    String? selectedProvinsi,
    List<String>? kabkota,
    String? selectedKabkota,
    int? bulan,
    int? tahun,
  }) = JadwalShalatFailure;
}

extension JadwalShalatStateX on JadwalShalatState {
  List<String> get provinsiList => switch (this) {
    JadwalShalatProvinsiLoaded(:final provinsi) => provinsi,
    JadwalShalatLoadingKabkota(:final provinsi) => provinsi,
    JadwalShalatKabkotaLoaded(:final provinsi) => provinsi,
    JadwalShalatLoadingJadwal(:final provinsi) => provinsi,
    JadwalShalatSuccess(:final provinsi) => provinsi,
    JadwalShalatFailure(:final provinsi) => provinsi ?? [],
    _ => [],
  };

  List<String> get kabkotaList => switch (this) {
    JadwalShalatKabkotaLoaded(:final kabkota) => kabkota,
    JadwalShalatLoadingJadwal(:final kabkota) => kabkota,
    JadwalShalatSuccess(:final kabkota) => kabkota,
    JadwalShalatFailure(:final kabkota) => kabkota ?? [],
    _ => [],
  };

  String? get selectedProvinsi => switch (this) {
    JadwalShalatLoadingKabkota(:final selectedProvinsi) => selectedProvinsi,
    JadwalShalatKabkotaLoaded(:final selectedProvinsi) => selectedProvinsi,
    JadwalShalatLoadingJadwal(:final selectedProvinsi) => selectedProvinsi,
    JadwalShalatSuccess(:final selectedProvinsi) => selectedProvinsi,
    JadwalShalatFailure(:final selectedProvinsi) => selectedProvinsi,
    _ => null,
  };
}
