import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/features/audio/domain/entities/download_state.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_download_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';

/// Bottom sheet konfirmasi download seluruh surat.
class DownloadSuratSheet extends StatelessWidget {
  const DownloadSuratSheet({
    required this.detail,
    required this.qari,
    required this.downloadCubit,
    super.key,
  });

  final SuratDetail detail;
  final Qari qari;
  final AudioDownloadCubit downloadCubit;

  @override
  Widget build(BuildContext context) {
    final pending = detail.ayatList
        .where(
          (a) =>
              downloadCubit.state.stateFor(
                detail.info.nomor,
                a.nomorAyat,
                qari.id,
              ) !=
              const DownloadState.done(),
        )
        .length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Download ${detail.info.namaLatin}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$pending ayat akan didownload untuk qari ${qari.name}.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Audio tersimpan lokal dan bisa diputar tanpa internet.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Download'),
                  onPressed: () {
                    Navigator.pop(context);
                    unawaited(
                      downloadCubit.downloadSurat(
                        suratNomor: detail.info.nomor,
                        ayatList: detail.ayatList,
                        qari: qari,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
