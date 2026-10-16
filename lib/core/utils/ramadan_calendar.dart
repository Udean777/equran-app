/// Kalender Hijriah tabular ringan untuk menentukan apakah tanggal berada di
/// bulan Ramadan.
///
/// Penentuan ini sengaja tidak bergantung pada jaringan karena dipakai saat
/// membangun drawer dan saat GoRouter mengevaluasi redirect. Awal Ramadan
/// dapat berbeda satu hari berdasarkan hasil rukyat setempat; toleransi itu
/// tidak memengaruhi pembatasan fitur secara umum.
abstract final class RamadanCalendar {
  static bool isRamadan([DateTime? date]) {
    final value = date ?? DateTime.now();
    return _toHijri(value.year, value.month, value.day).month == 9;
  }

  static ({int year, int month, int day}) _toHijri(
    int year,
    int month,
    int day,
  ) {
    final julianDay = _gregorianToJulianDay(year, month, day);
    final hijriYear = ((30 * (julianDay - 1948439) + 10646) / 10631)
        .floor();
    final firstDay = _islamicToJulianDay(hijriYear, 1, 1);
    final hijriMonth = ((julianDay - (29 + firstDay)) / 29.5).ceil() + 1;
    final normalizedMonth = hijriMonth.clamp(1, 12);
    final hijriDay = julianDay - _islamicToJulianDay(
      hijriYear,
      normalizedMonth,
      1,
    ) + 1;

    return (year: hijriYear, month: normalizedMonth, day: hijriDay);
  }

  static int _gregorianToJulianDay(int year, int month, int day) {
    final adjustment = ((14 - month) / 12).floor();
    final adjustedYear = year + 4800 - adjustment;
    final adjustedMonth = month + 12 * adjustment - 3;

    return day +
        ((153 * adjustedMonth + 2) / 5).floor() +
        365 * adjustedYear +
        (adjustedYear / 4).floor() -
        (adjustedYear / 100).floor() +
        (adjustedYear / 400).floor() -
        32045;
  }

  static int _islamicToJulianDay(int year, int month, int day) =>
      day +
      (29.5 * (month - 1)).ceil() +
      (year - 1) * 354 +
      ((3 + 11 * year) / 30).floor() +
      1948439;
}
