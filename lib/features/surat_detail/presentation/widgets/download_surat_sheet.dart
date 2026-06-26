import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
import 'package:equran_app/core/widgets/gradient_button.dart';
import 'package:equran_app/features/audio/domain/entities/download_state.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom sheet konfirmasi download seluruh surat.
class DownloadSuratSheet extends ConsumerWidget {
  const DownloadSuratSheet({
    required this.detail,
    required this.qari,
    super.key,
  });

  final SuratDetail detail;
  final Qari qari;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadState = ref.watch(audioDownloadViewModelProvider);
    final downloadNotifier = ref.read(audioDownloadViewModelProvider.notifier);

    final pending = detail.ayatList
        .where(
          (a) =>
              downloadState.stateFor(
                detail.nomor,
                a.nomorAyat,
                qari.id,
              ) !=
              const DownloadState.done(),
        )
        .length;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceLG),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          const Center(child: BottomSheetHandle()),
          const SizedBox(height: AppDimens.spaceMD),

          Text(
            'Download ${detail.namaLatin}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primaryActionColor,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          Text(
            '$pending ayat akan didownload untuk qari ${qari.name}.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Audio tersimpan lokal dan bisa diputar tanpa internet.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.textTertiaryColor,
            ),
          ),
          const SizedBox(height: AppDimens.spaceLG),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.primaryActionColor,
                    side: BorderSide(
                      color: context.borderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.spaceMD,
                    ),
                  ),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Expanded(
                child: GradientButton(
                  label: 'Download',
                  icon: Icons.download_rounded,
                  onTap: () {
                    Navigator.pop(context);
                    unawaited(
                      downloadNotifier.downloadSurat(
                        suratNomor: detail.nomor,
                        ayatList: detail.ayatList,
                        qari: qari,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXS),
        ],
      ),
    );
  }
}
