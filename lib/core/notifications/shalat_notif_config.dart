/// Value object di core layer yang merepresentasikan preferensi notifikasi
/// waktu shalat. Tidak bergantung pada feature entity manapun.
class ShalatNotifConfig {
  const ShalatNotifConfig({
    this.subuh = true,
    this.dzuhur = true,
    this.ashar = true,
    this.maghrib = true,
    this.isya = true,
    this.menitSebelum = 0,
  });

  final bool subuh;
  final bool dzuhur;
  final bool ashar;
  final bool maghrib;
  final bool isya;

  /// Menit sebelum waktu shalat untuk notifikasi.
  /// Nilai valid: 0, 5, 10, 15.
  final int menitSebelum;
}
