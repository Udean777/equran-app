import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/domain/repositories/audio_download_repository.dart'
    show DownloadedAyatInfo;
import 'package:equran_app/features/audio/presentation/cubit/audio_storage_cubit.dart';
import 'package:equran_app/features/audio/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// List tile premium untuk satu file audio yang sudah didownload.
class AudioFileItem extends StatelessWidget {
  const AudioFileItem({required this.file, super.key});

  final DownloadedAyatInfo file;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePadding,
        vertical: AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryDark
                  : AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
            ),
            child: Icon(
              Icons.audio_file_rounded,
              color: isDark ? AppColors.primaryLighter : AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ayat ${file.ayatNomor}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.onSurfaceDark
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${file.qari.name} • ${file.sizeBytes.toReadableBytes()}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
            color: AppColors.error,
            tooltip: 'Hapus',
            onPressed: () => context.read<AudioStorageCubit>().deleteFile(
              suratNomor: file.suratNomor,
              ayatNomor: file.ayatNomor,
              qari: file.qari,
            ),
          ),
        ],
      ),
    );
  }
}
