import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/utils/format_utils.dart';
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart'
    show DownloadedAyatInfo;
import 'package:equran_app/features/audio/presentation/widgets/audio_file_item.dart';
import 'package:flutter/material.dart';

/// ExpansionTile untuk satu surat beserta daftar file audio-nya.
class AudioSuratGroup extends StatelessWidget {
  const AudioSuratGroup({
    required this.suratNomor,
    required this.files,
    super.key,
  });

  final int suratNomor;
  final List<DownloadedAyatInfo> files;

  @override
  Widget build(BuildContext context) {
    final totalBytes = files.fold<int>(0, (sum, f) => sum + f.sizeBytes);

    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Text(
          '$suratNomor',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      title: Text('Surat $suratNomor'),
      subtitle: Text(
        '${files.length} ayat • ${totalBytes.toReadableBytes()}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.grey[500],
        ),
      ),
      children: files.map((file) => AudioFileItem(file: file)).toList(),
    );
  }
}
