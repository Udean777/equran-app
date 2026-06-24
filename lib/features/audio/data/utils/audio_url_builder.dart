import 'package:equran_app/features/audio/domain/entities/qari.dart';

/// Helper untuk membangun URL audio ayat dari CDN islamic.network.
///
/// Format URL: https://cdn.islamic.network/quran/audio/{bitrate}/{qariId}/{globalAyatNumber}.mp3
///
/// Contoh: https://cdn.islamic.network/quran/audio/128/05/1.mp3
///         → Surat Al-Fatihah ayat 1, qari Misyari, bitrate 128kbps
class AudioUrlBuilder {
  const AudioUrlBuilder._();

  static const _baseUrl = 'https://cdn.islamic.network/quran/audio';

  /// Bangun URL audio untuk ayat tertentu.
  ///
  /// [suratNomor] — nomor surat (1–114)
  /// [ayatNomor] — nomor ayat dalam surat (1-based)
  /// [qari] — qari yang dipilih
  /// [bitrate] — bitrate audio (default: high/128kbps)
  static String buildAyatUrl({
    required int suratNomor,
    required int ayatNomor,
    required Qari qari,
    AudioBitrate bitrate = AudioBitrate.high,
  }) {
    final globalNumber = toGlobalAyatNumber(
      suratNomor: suratNomor,
      ayatNomor: ayatNomor,
    );
    return '$_baseUrl/${bitrate.value}/${qari.id}/$globalNumber.mp3';
  }

  /// Konversi nomor surat + nomor ayat ke nomor ayat global (1–6236).
  ///
  /// Nomor ayat global dihitung berdasarkan jumlah ayat kumulatif
  /// dari surat 1 hingga surat sebelumnya, ditambah nomor ayat dalam surat.
  static int toGlobalAyatNumber({
    required int suratNomor,
    required int ayatNomor,
  }) {
    assert(suratNomor >= 1 && suratNomor <= 114, 'suratNomor harus 1–114');
    assert(ayatNomor >= 1, 'ayatNomor harus >= 1');

    final cumulative = _cumulativeAyat[suratNomor - 1];
    return cumulative + ayatNomor;
  }

  static const List<int> _cumulativeAyat = [
    0,
    7,
    293,
    493,
    669,
    789,
    954,
    1160,
    1235,
    1364,
    1473,
    1596,
    1707,
    1750,
    1802,
    1901,
    2029,
    2140,
    2250,
    2348,
    2483,
    2595,
    2673,
    2791,
    2855,
    2932,
    3159,
    3252,
    3340,
    3409,
    3469,
    3503,
    3533,
    3606,
    3660,
    3705,
    3788,
    3970,
    4058,
    4133,
    4218,
    4272,
    4325,
    4414,
    4473,
    4510,
    4545,
    4583,
    4612,
    4630,
    4675,
    4735,
    4784,
    4846,
    4901,
    4979,
    5075,
    5104,
    5126,
    5150,
    5163,
    5177,
    5188,
    5199,
    5217,
    5229,
    5241,
    5271,
    5323,
    5375,
    5419,
    5447,
    5475,
    5495,
    5551,
    5591,
    5622,
    5672,
    5712,
    5758,
    5800,
    5829,
    5848,
    5884,
    5909,
    5931,
    5948,
    5967,
    5993,
    6023,
    6043,
    6058,
    6079,
    6090,
    6098,
    6106,
    6125,
    6130,
    6138,
    6146,
    6157,
    6168,
    6176,
    6179,
    6188,
    6193,
    6197,
    6204,
    6207,
    6213,
    6216,
    6221,
    6225,
    6230,
  ];
}
