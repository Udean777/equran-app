abstract interface class QuranStreakRepository {
  /// Ambil streak count saat ini. Returns 0 jika belum ada data.
  Future<int> getStreakCount();

  /// Ambil tanggal terakhir baca. Returns null jika belum pernah baca.
  Future<String?> getLastReadDate();

  /// Simpan streak — date format: 'yyyy-MM-dd'.
  Future<void> saveStreak({required String date, required int count});
}
