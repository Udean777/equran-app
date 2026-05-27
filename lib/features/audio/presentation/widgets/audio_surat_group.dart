import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/utils/format_utils.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_download_repository.dart'
    show DownloadedAyatInfo;
import 'package:equran_app/features/audio/presentation/widgets/audio_file_item.dart';
import 'package:flutter/material.dart';

/// ExpansionTile untuk satu surat beserta daftar file audio-nya.
class AudioSuratGroup extends StatelessWidget {
  const AudioSuratGroup({
    required this.suratNomor,
    required this.files,
    this.suratName,
    this.isComplete = false,
    this.onPlayTap,
    super.key,
  });

  final int suratNomor;
  final List<DownloadedAyatInfo> files;

  /// Nama latin surat — jika null, fallback ke 'Surat $suratNomor'.
  final String? suratName;

  /// Apakah semua ayat surat ini sudah didownload.
  /// Jika true, tampilkan tombol play di header.
  final bool isComplete;

  /// Callback saat tombol play di-tap.
  final VoidCallback? onPlayTap;

  @override
  Widget build(BuildContext context) {
    final totalBytes = files.fold<int>(0, (sum, f) => sum + f.sizeBytes);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;

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
      title: Text(suratName ?? 'Surat $suratNomor'),
      subtitle: Text(
        '${files.length} ayat • ${totalBytes.toReadableBytes()}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.grey[500],
        ),
      ),
      // Tombol play hanya muncul jika semua ayat sudah didownload
      trailing: isComplete
          ? IconButton(
              icon: Icon(
                Icons.play_circle_rounded,
                color: primaryColor,
                size: 28,
              ),
              tooltip: 'Putar semua ayat',
              onPressed: onPlayTap,
            )
          : null,
      children: files.map((file) => AudioFileItem(file: file)).toList(),
    );
  }
}
