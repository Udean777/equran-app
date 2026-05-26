import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_download_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// AppBar untuk SuratDetailPage.
///
/// Menangani: tombol hafalan, download surat, auto-scroll toggle, play surat.
class SuratDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SuratDetailAppBar({
    required this.detail,
    required this.autoScrollEnabled,
    required this.onToggleAutoScroll,
    required this.onDownloadTap,
    super.key,
  });

  final SuratDetail detail;
  final bool autoScrollEnabled;
  final VoidCallback onToggleAutoScroll;
  final VoidCallback onDownloadTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioDownloadCubit, AudioDownloadState>(
      builder: (context, downloadState) {
        final downloadCubit = context.read<AudioDownloadCubit>();

        return BlocBuilder<AudioCubit, AudioPlayerState>(
          buildWhen: (prev, next) =>
              prev.isPlaying != next.isPlaying ||
              prev.isPaused != next.isPaused ||
              prev.currentQari != next.currentQari,
          builder: (context, audioState) {
            final cubit = context.read<AudioCubit>();
            final qari = audioState.currentQari;

            final isAllDownloaded = downloadState.isAllDownloaded(
              detail.info.nomor,
              detail.ayatList,
              qari.id,
            );

            return AppBar(
              title: Text(detail.info.namaLatin),
              actions: [
                // Tombol Hafalan
                IconButton(
                  icon: const Icon(Icons.auto_stories_outlined),
                  color: AppColors.primary,
                  tooltip: 'Hafalan',
                  onPressed: () => unawaited(
                    context.push('/hafalan/${detail.info.nomor}'),
                  ),
                ),
                // Tombol Download Surat
                if (downloadState.isDownloadingSurat)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              value: downloadState.suratDownloadTotal > 0
                                  ? downloadState.suratDownloadDone /
                                        downloadState.suratDownloadTotal
                                  : null,
                              color: AppColors.primary,
                            ),
                            GestureDetector(
                              onTap: downloadCubit.cancelSuratDownload,
                              child: const Icon(
                                Icons.close,
                                size: 10,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(
                      isAllDownloaded
                          ? Icons.download_done_rounded
                          : Icons.download_for_offline_outlined,
                      color: isAllDownloaded
                          ? Colors.green[600]
                          : AppColors.primary,
                    ),
                    tooltip: isAllDownloaded
                        ? 'Semua ayat sudah didownload'
                        : 'Download surat',
                    onPressed: isAllDownloaded ? null : onDownloadTap,
                  ),
                // Tombol Toggle Auto-Scroll
                if (cubit.isPlaylistMode)
                  IconButton(
                    icon: Icon(
                      autoScrollEnabled
                          ? Icons.gps_fixed_rounded
                          : Icons.gps_not_fixed_rounded,
                    ),
                    color: autoScrollEnabled
                        ? AppColors.primary
                        : Colors.grey[400],
                    tooltip: autoScrollEnabled
                        ? 'Auto-Scroll Aktif'
                        : 'Auto-Scroll Nonaktif',
                    onPressed: onToggleAutoScroll,
                  ),
                // Tombol Play Surat
                IconButton(
                  icon: Icon(
                    cubit.isPlaylistMode && audioState.isPlaying
                        ? Icons.pause_circle_outline_rounded
                        : Icons.play_circle_outline_rounded,
                  ),
                  color: AppColors.primary,
                  tooltip: 'Play Surat',
                  onPressed: () {
                    if (cubit.isPlaylistMode && audioState.isPlaying) {
                      unawaited(cubit.pause());
                    } else if (cubit.isPlaylistMode && audioState.isPaused) {
                      unawaited(cubit.resume());
                    } else {
                      unawaited(
                        cubit.playFullSurat(
                          ayatList: detail.ayatList,
                          startIndex: 0,
                          qari: audioState.currentQari,
                          suratNomor: detail.info.nomor,
                          suratName: detail.info.namaLatin,
                          audioMap: detail.audioFull,
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
