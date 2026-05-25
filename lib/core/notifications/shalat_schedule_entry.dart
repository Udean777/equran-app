/// Value object di core layer yang merepresentasikan waktu-waktu shalat
/// dalam satu hari. Tidak bergantung pada feature entity manapun.
///
/// Field waktu menggunakan format string "HH:mm" (contoh: "04:32").
class ShalatScheduleEntry {
  const ShalatScheduleEntry({
    required this.subuh,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });

  final String subuh;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;
}
