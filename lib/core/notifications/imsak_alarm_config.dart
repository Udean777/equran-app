/// Value object di core layer yang merepresentasikan preferensi alarm
/// imsak dan sahur. Tidak bergantung pada feature entity manapun.
class ImsakAlarmConfig {
  const ImsakAlarmConfig({
    this.imsakEnabled = false,
    this.sahurEnabled = false,
    this.menitSebelumImsak = 60,
  });

  /// Aktifkan alarm tepat di waktu imsak.
  final bool imsakEnabled;

  /// Aktifkan alarm sahur — berbunyi [menitSebelumImsak] menit sebelum imsak.
  final bool sahurEnabled;

  /// Berapa menit sebelum imsak alarm sahur berbunyi.
  /// Nilai valid: 30, 45, 60, 90. Default: 60.
  final int menitSebelumImsak;
}
