import 'package:equran_app/features/audio/domain/entities/qari.dart';

class DownloadedAyatInfo {
  const DownloadedAyatInfo({
    required this.suratNomor,
    required this.ayatNomor,
    required this.qari,
    required this.filePath,
    required this.sizeBytes,
  });

  final int suratNomor;
  final int ayatNomor;
  final Qari qari;
  final String filePath;
  final int sizeBytes;
}
