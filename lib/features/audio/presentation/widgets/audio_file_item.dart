import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/format_utils.dart';
import 'package:equran_app/features/audio/data/datasources/audio_download_data_source.dart'
    show DownloadedAyatInfo;
import 'package:equran_app/features/audio/presentation/cubit/audio_storage_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// List tile untuk satu file audio yang sudah didownload.
class AudioFileItem extends StatelessWidget {
  const AudioFileItem({required this.file, super.key});

  final DownloadedAyatInfo file;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: AppDimens.spaceXL + AppDimens.spaceMD,
        right: AppDimens.spaceSM,
      ),
      leading: const Icon(
        Icons.audio_file_rounded,
        color: AppColors.primary,
        size: AppDimens.iconSM + 4,
      ),
      title: Text('Ayat ${file.ayatNomor}'),
      subtitle: Text(
        '${file.qari.name} • ${file.sizeBytes.toReadableBytes()}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.grey[500],
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline_rounded, size: 20),
        color: Colors.red[400],
        tooltip: 'Hapus',
        onPressed: () => context.read<AudioStorageCubit>().deleteFile(
          suratNomor: file.suratNomor,
          ayatNomor: file.ayatNomor,
          qari: file.qari,
        ),
      ),
    );
  }
}
