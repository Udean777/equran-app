import 'package:equran_app/core/error/failure.dart';

extension FailureExtension on Failure {
  String toUserMessage() => when(
        network: () => 'Tidak ada koneksi internet. Periksa jaringan Anda.',
        server: (statusCode) => switch (statusCode) {
          404 => 'Data tidak ditemukan.',
          500 => 'Terjadi kesalahan pada server.',
          503 => 'Layanan sedang tidak tersedia.',
          _ => 'Terjadi kesalahan (kode: $statusCode).',
        },
        unknown: (message) => 'Terjadi kesalahan yang tidak diketahui.',
      );
}
