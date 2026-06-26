import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'imsakiyah_state.freezed.dart';

@freezed
sealed class ImsakiyahState with _$ImsakiyahState {
  const factory ImsakiyahState.initial() = ImsakiyahInitial;

  const factory ImsakiyahState.loadingProvinsi() = ImsakiyahLoadingProvinsi;

  const factory ImsakiyahState.detectingLocation() = ImsakiyahDetectingLocation;

  const factory ImsakiyahState.provinsiLoaded({
    required List<String> provinsi,
  }) = ImsakiyahProvinsiLoaded;

  const factory ImsakiyahState.loadingKabkota({
    required List<String> provinsi,
    required String selectedProvinsi,
  }) = ImsakiyahLoadingKabkota;

  const factory ImsakiyahState.kabkotaLoaded({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
  }) = ImsakiyahKabkotaLoaded;

  const factory ImsakiyahState.loadingJadwal({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
    required String selectedKabkota,
  }) = ImsakiyahLoadingJadwal;

  const factory ImsakiyahState.success({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
    required String selectedKabkota,
    required Imsakiyah jadwal,
  }) = ImsakiyahSuccess;

  const factory ImsakiyahState.failure({
    required Failure failure,
    List<String>? provinsi,
    String? selectedProvinsi,
    List<String>? kabkota,
    String? selectedKabkota,
  }) = ImsakiyahFailure;
}

extension ImsakiyahStateX on ImsakiyahState {
  List<String> get provinsiList => switch (this) {
    ImsakiyahProvinsiLoaded(:final provinsi) => provinsi,
    ImsakiyahLoadingKabkota(:final provinsi) => provinsi,
    ImsakiyahKabkotaLoaded(:final provinsi) => provinsi,
    ImsakiyahLoadingJadwal(:final provinsi) => provinsi,
    ImsakiyahSuccess(:final provinsi) => provinsi,
    ImsakiyahFailure(:final provinsi) => provinsi ?? [],
    _ => [],
  };

  List<String> get kabkotaList => switch (this) {
    ImsakiyahKabkotaLoaded(:final kabkota) => kabkota,
    ImsakiyahLoadingJadwal(:final kabkota) => kabkota,
    ImsakiyahSuccess(:final kabkota) => kabkota,
    ImsakiyahFailure(:final kabkota) => kabkota ?? [],
    _ => [],
  };

  String? get selectedProvinsi => switch (this) {
    ImsakiyahLoadingKabkota(:final selectedProvinsi) => selectedProvinsi,
    ImsakiyahKabkotaLoaded(:final selectedProvinsi) => selectedProvinsi,
    ImsakiyahLoadingJadwal(:final selectedProvinsi) => selectedProvinsi,
    ImsakiyahSuccess(:final selectedProvinsi) => selectedProvinsi,
    ImsakiyahFailure(:final selectedProvinsi) => selectedProvinsi,
    _ => null,
  };
}
