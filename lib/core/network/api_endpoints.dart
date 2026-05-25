abstract final class ApiEndpoints {
  static const String baseUrl = 'https://equran.id/api/v2';
  static const String suratList = '/surat';

  static String suratDetail(int nomor) => '/surat/$nomor';
  static String tafsir(int nomor) => '/tafsir/$nomor';
}
