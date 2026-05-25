abstract final class ApiEndpoints {
  static const String baseUrl = 'https://equran.id/api/v2';
  static const String doaBaseUrl = 'https://equran.id/api';
  static const String suratList = '/surat';

  static String suratDetail(int nomor) => '/surat/$nomor';
  static String tafsir(int nomor) => '/tafsir/$nomor';

  // Doa uses different base URL (no /v2 prefix)
  static const String doaList = '/doa';
  static String doaDetail(int id) => '/doa/$id';

  static String doaListUrl() => '$doaBaseUrl$doaList';
  static String doaDetailUrl(int id) => '$doaBaseUrl${doaDetail(id)}';

  // Imsakiyah — uses baseUrl (/api/v2)
  static const String imsakiyah = '/imsakiyah';
  static const String imsakiyahProvinsi = '/imsakiyah/provinsi';
  static const String imsakiyahKabkota = '/imsakiyah/kabkota';

  // Jadwal Shalat — uses baseUrl (/api/v2)
  static const String shalat = '/shalat';
  static const String shalatProvinsi = '/shalat/provinsi';
  static const String shalatKabkota = '/shalat/kabkota';
}
