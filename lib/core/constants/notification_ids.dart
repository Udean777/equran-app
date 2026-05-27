abstract final class NotificationIds {
  // Adzan (per waktu shalat)
  static const int subuh = 1;
  static const int dzuhur = 2;
  static const int ashar = 3;
  static const int maghrib = 4;
  static const int isya = 5;

  // Sahur & Imsak
  static const int sahur = 6;
  static const int imsak = 7;

  // Quran reminder
  static const int quranReminder = 10;

  // Hafalan reminder base (ID range: 20–133, satu per surat 1–114)
  static const int hafalanReminderBase = 20;

  // Debug/test IDs (hanya kDebugMode)
  static const int testSubuh = 901;
  static const int testDzuhur = 902;
  static const int testAshar = 903;
  static const int testMaghrib = 904;
  static const int testIsya = 905;
  static const int testSahur = 906;
  static const int testImsak = 907;
  static const int testQuranReminder = 908;
}
