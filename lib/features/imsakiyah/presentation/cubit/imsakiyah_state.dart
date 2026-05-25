part of 'imsakiyah_cubit.dart';

@freezed
sealed class ImsakiyahState with _$ImsakiyahState {
  /// Initial state — belum ada aksi
  const factory ImsakiyahState.initial() = ImsakiyahInitial;

  /// Loading provinsi list
  const factory ImsakiyahState.loadingProvinsi() = ImsakiyahLoadingProvinsi;

  /// Provinsi loaded, menunggu user pilih provinsi
  const factory ImsakiyahState.provinsiLoaded({
    required List<String> provinsi,
  }) = ImsakiyahProvinsiLoaded;

  /// Loading kabkota setelah provinsi dipilih
  const factory ImsakiyahState.loadingKabkota({
    required List<String> provinsi,
    required String selectedProvinsi,
  }) = ImsakiyahLoadingKabkota;

  /// Kabkota loaded, menunggu user pilih kabkota
  const factory ImsakiyahState.kabkotaLoaded({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
  }) = ImsakiyahKabkotaLoaded;

  /// Loading jadwal imsakiyah
  const factory ImsakiyahState.loadingJadwal({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
    required String selectedKabkota,
  }) = ImsakiyahLoadingJadwal;

  /// Jadwal berhasil dimuat
  const factory ImsakiyahState.success({
    required List<String> provinsi,
    required String selectedProvinsi,
    required List<String> kabkota,
    required String selectedKabkota,
    required Imsakiyah jadwal,
  }) = ImsakiyahSuccess;

  /// Error state
  const factory ImsakiyahState.failure({
    required Failure failure,
    // preserve context untuk retry
    List<String>? provinsi,
    String? selectedProvinsi,
    List<String>? kabkota,
    String? selectedKabkota,
  }) = ImsakiyahFailure;
}
