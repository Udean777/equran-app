/// Daftar qari yang tersedia dari API equran.id
enum Qari {
  abdullahAlMatrood('01', 'Abdullah Al-Matrood'),
  abdurrahmanAsSudais('02', 'Abdurrahman As-Sudais'),
  muhammadAyyoob('03', 'Muhammad Ayyoob'),
  muhammadJibreel('04', 'Muhammad Jibreel'),
  misyariRasyidAlAfasi('05', 'Misyari Rasyid Al-Afasi');

  const Qari(this.id, this.name);

  final String id;
  final String name;

  static Qari fromId(String id) => Qari.values.firstWhere(
    (q) => q.id == id,
    orElse: () => Qari.misyariRasyidAlAfasi,
  );
}

/// Bitrate audio yang tersedia dari CDN islamic.network
enum AudioBitrate {
  low('32'),
  medium('64'),
  high('128');

  const AudioBitrate(this.value);

  final String value;
}

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

    // Jumlah ayat kumulatif sebelum surat ke-n (index 0 = sebelum surat 1)
    final cumulative = _cumulativeAyat[suratNomor - 1];
    return cumulative + ayatNomor;
  }

  /// Tabel jumlah ayat kumulatif sebelum setiap surat.
  /// Index 0 = sebelum surat 1 (= 0)
  /// Index 1 = sebelum surat 2 (= 7, karena Al-Fatihah punya 7 ayat)
  /// dst.
  static const List<int> _cumulativeAyat = [
    0, // sebelum surat 1 (Al-Fatihah)
    7, // sebelum surat 2 (Al-Baqarah)
    293, // sebelum surat 3 (Ali Imran)
    493, // sebelum surat 4 (An-Nisa)
    669, // sebelum surat 5 (Al-Maidah)
    789, // sebelum surat 6 (Al-An'am)
    954, // sebelum surat 7 (Al-A'raf)
    1160, // sebelum surat 8 (Al-Anfal)
    1235, // sebelum surat 9 (At-Taubah)
    1364, // sebelum surat 10 (Yunus)
    1473, // sebelum surat 11 (Hud)
    1596, // sebelum surat 12 (Yusuf)
    1707, // sebelum surat 13 (Ar-Ra'd)
    1750, // sebelum surat 14 (Ibrahim)
    1802, // sebelum surat 15 (Al-Hijr)
    1901, // sebelum surat 16 (An-Nahl)
    2029, // sebelum surat 17 (Al-Isra)
    2140, // sebelum surat 18 (Al-Kahf)
    2250, // sebelum surat 19 (Maryam)
    2348, // sebelum surat 20 (Ta-Ha)
    2483, // sebelum surat 21 (Al-Anbiya)
    2595, // sebelum surat 22 (Al-Hajj)
    2673, // sebelum surat 23 (Al-Mu'minun)
    2791, // sebelum surat 24 (An-Nur)
    2855, // sebelum surat 25 (Al-Furqan)
    2932, // sebelum surat 26 (Asy-Syu'ara)
    3159, // sebelum surat 27 (An-Naml)
    3252, // sebelum surat 28 (Al-Qasas)
    3340, // sebelum surat 29 (Al-Ankabut)
    3409, // sebelum surat 30 (Ar-Rum)
    3469, // sebelum surat 31 (Luqman)
    3503, // sebelum surat 32 (As-Sajdah)
    3533, // sebelum surat 33 (Al-Ahzab)
    3606, // sebelum surat 34 (Saba)
    3660, // sebelum surat 35 (Fatir)
    3705, // sebelum surat 36 (Ya-Sin)
    3788, // sebelum surat 37 (As-Saffat)
    3970, // sebelum surat 38 (Sad)
    4058, // sebelum surat 39 (Az-Zumar)
    4133, // sebelum surat 40 (Ghafir)
    4218, // sebelum surat 41 (Fussilat)
    4272, // sebelum surat 42 (Asy-Syura)
    4325, // sebelum surat 43 (Az-Zukhruf)
    4414, // sebelum surat 44 (Ad-Dukhan)
    4473, // sebelum surat 45 (Al-Jasiyah)
    4510, // sebelum surat 46 (Al-Ahqaf)
    4545, // sebelum surat 47 (Muhammad)
    4583, // sebelum surat 48 (Al-Fath)
    4612, // sebelum surat 49 (Al-Hujurat)
    4630, // sebelum surat 50 (Qaf)
    4675, // sebelum surat 51 (Az-Zariyat)
    4735, // sebelum surat 52 (At-Tur)
    4784, // sebelum surat 53 (An-Najm)
    4846, // sebelum surat 54 (Al-Qamar)
    4901, // sebelum surat 55 (Ar-Rahman)
    4979, // sebelum surat 56 (Al-Waqi'ah)
    5075, // sebelum surat 57 (Al-Hadid)
    5104, // sebelum surat 58 (Al-Mujadila)
    5126, // sebelum surat 59 (Al-Hasyr)
    5150, // sebelum surat 60 (Al-Mumtahanah)
    5163, // sebelum surat 61 (As-Saf)
    5177, // sebelum surat 62 (Al-Jumu'ah)
    5188, // sebelum surat 63 (Al-Munafiqun)
    5199, // sebelum surat 64 (At-Tagabun)
    5217, // sebelum surat 65 (At-Talaq)
    5229, // sebelum surat 66 (At-Tahrim)
    5241, // sebelum surat 67 (Al-Mulk)
    5271, // sebelum surat 68 (Al-Qalam)
    5323, // sebelum surat 69 (Al-Haqqah)
    5375, // sebelum surat 70 (Al-Ma'arij)
    5419, // sebelum surat 71 (Nuh)
    5447, // sebelum surat 72 (Al-Jinn)
    5475, // sebelum surat 73 (Al-Muzzammil)
    5495, // sebelum surat 74 (Al-Muddassir)
    5551, // sebelum surat 75 (Al-Qiyamah)
    5591, // sebelum surat 76 (Al-Insan)
    5622, // sebelum surat 77 (Al-Mursalat)
    5672, // sebelum surat 78 (An-Naba)
    5712, // sebelum surat 79 (An-Nazi'at)
    5758, // sebelum surat 80 (Abasa)
    5800, // sebelum surat 81 (At-Takwir)
    5829, // sebelum surat 82 (Al-Infitar)
    5848, // sebelum surat 83 (Al-Mutaffifin)
    5884, // sebelum surat 84 (Al-Insyiqaq)
    5909, // sebelum surat 85 (Al-Buruj)
    5931, // sebelum surat 86 (At-Tariq)
    5948, // sebelum surat 87 (Al-A'la)
    5967, // sebelum surat 88 (Al-Gasyiyah)
    5993, // sebelum surat 89 (Al-Fajr)
    6023, // sebelum surat 90 (Al-Balad)
    6043, // sebelum surat 91 (Asy-Syams)
    6058, // sebelum surat 92 (Al-Lail)
    6079, // sebelum surat 93 (Ad-Duha)
    6090, // sebelum surat 94 (Asy-Syarh)
    6098, // sebelum surat 95 (At-Tin)
    6106, // sebelum surat 96 (Al-Alaq)
    6125, // sebelum surat 97 (Al-Qadr)
    6130, // sebelum surat 98 (Al-Bayyinah)
    6138, // sebelum surat 99 (Az-Zalzalah)
    6146, // sebelum surat 100 (Al-Adiyat)
    6157, // sebelum surat 101 (Al-Qari'ah)
    6168, // sebelum surat 102 (At-Takasur)
    6176, // sebelum surat 103 (Al-Asr)
    6179, // sebelum surat 104 (Al-Humazah)
    6188, // sebelum surat 105 (Al-Fil)
    6193, // sebelum surat 106 (Quraisy)
    6197, // sebelum surat 107 (Al-Ma'un)
    6204, // sebelum surat 108 (Al-Kausar)
    6207, // sebelum surat 109 (Al-Kafirun)
    6213, // sebelum surat 110 (An-Nasr)
    6216, // sebelum surat 111 (Al-Masad)
    6221, // sebelum surat 112 (Al-Ikhlas)
    6225, // sebelum surat 113 (Al-Falaq)
    6230, // sebelum surat 114 (An-Nas)
  ];
}
