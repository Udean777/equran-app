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
