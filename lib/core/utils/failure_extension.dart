import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/l10n/app_localizations.dart';

extension FailureExtension on Failure {
  /// Fallback tanpa l10n — dipakai di test dan context yang tidak ada l10n.
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

  /// Pesan yang sudah dilokalisasi — gunakan ini di widget.
  String toLocalizedMessage(AppLocalizations l10n) => when(
    network: () => l10n.errorNoInternet,
    server: (statusCode) => switch (statusCode) {
      404 => l10n.errorUnknown,
      500 => l10n.errorServer,
      503 => l10n.errorServer,
      _ => l10n.errorServer,
    },
    unknown: (_) => l10n.errorUnknown,
  );
}
