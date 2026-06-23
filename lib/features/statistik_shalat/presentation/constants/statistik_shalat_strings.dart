import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';

/// Semua string constants untuk statistik_shalat feature.
/// Catatan: Migrate ke l10n (app_localizations.arb) untuk multi-language support.
abstract final class StatistikShalatStrings {
  // Page
  static const pageTitle = 'Statistik Shalat';

  // Sections
  static const sectionKalender = 'Kalender';
  static const sectionStatistikMingguan = 'Statistik Mingguan';
  static const sectionChecklistHariIni = 'Checklist Hari Ini';

  // Weekly stats
  static const weeklyStatsTitle = 'Statistik 7 Hari Terakhir';
  static const labelTepatWaktu = 'Tepat Waktu';
  static const labelQadha = 'Qadha';
  static const labelTidakShalat = 'Tidak Shalat';
  static const labelBelumDicatat = 'Belum Dicatat';

  // Streak
  static const streakLabel = 'Hari Beruntun';
  static const streakUnit = 'hari';
  static const streakSubtitle = 'Alhamdulillah, tetap semangat!';
  static const streakSubtitleZero = 'Yuk mulai catat shalat hari ini';

  // Waktu shalat names
  static const waktuSubuh = 'Subuh';
  static const waktuDzuhur = 'Dzuhur';
  static const waktuAshar = 'Ashar';
  static const waktuMaghrib = 'Maghrib';
  static const waktuIsya = 'Isya';

  // Status
  static const statusTepatWaktu = 'Tepat Waktu';
  static const statusQadha = 'Qadha';
  static const statusTidakShalat = 'Tidak Shalat';
  static const statusBelumDicatat = 'Belum Dicatat';

  // Detail sheet
  static const detailSheetTitle = 'Detail Shalat';
  static const detailCatatanLabel = 'Catatan';
  static const detailCatatanPlaceholder = 'Tambah catatan (opsional)';
  static const detailSimpanButton = 'Simpan';

  // Delete dialog
  static const deleteDialogTitle = 'Hapus Catatan Shalat';
  static const deleteDialogContent =
      'Yakin ingin menghapus semua catatan shalat untuk tanggal ini?';
  static const deleteConfirmButton = 'Hapus';
  static const deleteCancelButton = 'Batal';
  static const deleteSuccessMessage = 'Catatan shalat berhasil dihapus';

  // Days of week
  static const dayMon = 'Sen';
  static const dayTue = 'Sel';
  static const dayWed = 'Rab';
  static const dayThu = 'Kam';
  static const dayFri = 'Jum';
  static const daySat = 'Sab';
  static const daySun = 'Min';

  // Helpers
  static String waktuShalatName(WaktuShalat waktu) => switch (waktu) {
    WaktuShalat.subuh => waktuSubuh,
    WaktuShalat.dzuhur => waktuDzuhur,
    WaktuShalat.ashar => waktuAshar,
    WaktuShalat.maghrib => waktuMaghrib,
    WaktuShalat.isya => waktuIsya,
  };

  static String statusName(ShalatStatus status) => switch (status) {
    ShalatStatus.tepatWaktu => statusTepatWaktu,
    ShalatStatus.qadha => statusQadha,
    ShalatStatus.tidakShalat => statusTidakShalat,
    ShalatStatus.belumDicatat => statusBelumDicatat,
  };
}
