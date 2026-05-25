part of 'jadwal_shalat_cubit.dart';

@freezed
sealed class JadwalShalatState with _$JadwalShalatState {
  /// Initial state
  const factory JadwalShalatState.initial() = JadwalShalatInitial;

  /// Loading provinsi list
  const factory JadwalShalatState.loadingProvinsi() =
      JadwalShalatLoadingProvinsi;

  /// Sedang mendeteksi lokasi GPS
  const factory JadwalShalatState.detectingLocation() =
      JadwalShalatDetectingLocation;

  /// Provinsi loaded, menunggu user pilih provinsi
  const factory JadwalShalatState.provinsiLoaded({
    required List<String> provinsi,
  }) = JadwalShalatProvinsiLoaded;

  /// Loading kabkota setelah provinsi dipilih
  const factory JadwalShalatState.loadingKabkota({
    required List<String> provinsi,
    required String selectedProvinsi,
  }) = JadwalShalatLoadingKabkota;

  /// Kabkota loaded, menunggu user pilih kabkota
  const factory JadwalShalatState.kabkotaLoaded({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
  }) = JadwalShalatKabkotaLoaded;

  /// Loading jadwal shalat
  const factory JadwalShalatState.loadingJadwal({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
    required String selectedKabkota,
    required int bulan,
    required int tahun,
  }) = JadwalShalatLoadingJadwal;

  /// Jadwal berhasil dimuat
  const factory JadwalShalatState.success({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
    required String selectedKabkota,
    required JadwalShalat jadwal,
    required int bulan,
    required int tahun,
  }) = JadwalShalatSuccess;

  /// Error state
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
