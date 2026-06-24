/// Interval hari untuk spaced repetition muraja'ah hafalan.
///
/// Setelah surat selesai dihafal, sistem otomatis menjadwalkan
/// muraja'ah berikutnya berdasarkan level:
///
/// Level 0 → selesai hafal    → D+1
/// Level 1 → muraja'ah ke-1   → D+3
/// Level 2 → muraja'ah ke-2   → D+7
/// Level 3 → muraja'ah ke-3   → D+30
/// Level 4 → muraja'ah ke-4   → D+90
/// Level 5 → selesai (tidak ada reminder lagi)
const List<int> kMurajaahIntervalDays = [1, 3, 7, 30, 90];

/// Level maksimum muraja'ah. Setelah level ini, hafalan dianggap kuat.
const int kMurajaahMaxLevel = 5;
