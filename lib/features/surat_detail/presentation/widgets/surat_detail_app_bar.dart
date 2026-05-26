import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_download_cubit.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// AppBar untuk SuratDetailPage — luxury style, putih, serif title.
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
  Size get preferredSize => const Size.fromHeight(AppDimens.appBarHeightLG);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor =
        isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;
    final surfaceColor =
        isDark ? AppColors.surfaceDark : AppColors.surface;

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
              backgroundColor: surfaceColor,
              elevation: 0,
              scrolledUnderElevation: 0.5,
              shadowColor: AppColors.outline,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: AppDimens.appBarHeightLG,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: iconColor),
                onPressed: () => context.pop(),
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    detail.info.namaLatin,
                    style: AppTypography.serifHeadingSmall.copyWith(
                      color: isDark
                          ? AppColors.onSurfaceDark
                          : AppColors.textPrimary,
                      fontSize: 17,
                      height: 1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Container(
                    width: 20,
                    height: 1.5,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusFull),
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                // Hafalan
                IconButton(
                  icon: Icon(
                    Icons.auto_stories_outlined,
                    color: isDark ? AppColors.primaryLighter : AppColors.primary,
                  ),
                  tooltip: 'Hafalan',
                  onPressed: () => unawaited(
                    context.push('/hafalan/${detail.info.nomor}'),
                  ),
                ),

                // Download
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
                              color: isDark
                                  ? AppColors.primaryLighter
                                  : AppColors.primary,
                            ),
                            GestureDetector(
                              onTap: downloadCubit.cancelSuratDownload,
                              child: Icon(
                                Icons.close,
                                size: 10,
                                color: isDark
                                    ? AppColors.primaryLighter
                                    : AppColors.primary,
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
                          ? AppColors.success
                          : (isDark
                              ? AppColors.primaryLighter
                              : AppColors.primary),
                    ),
                    tooltip: isAllDownloaded
                        ? 'Semua ayat sudah didownload'
                        : 'Download surat',
                    onPressed: isAllDownloaded ? null : onDownloadTap,
                  ),

                // Auto-scroll toggle
                if (cubit.isPlaylistMode)
                  IconButton(
                    icon: Icon(
                      autoScrollEnabled
                          ? Icons.gps_fixed_rounded
                          : Icons.gps_not_fixed_rounded,
                      color: autoScrollEnabled
                          ? (isDark
                              ? AppColors.primaryLighter
                              : AppColors.primary)
                          : iconColor.withValues(alpha: 0.4),
                    ),
                    tooltip: autoScrollEnabled
                        ? 'Auto-Scroll Aktif'
                        : 'Auto-Scroll Nonaktif',
                    onPressed: onToggleAutoScroll,
                  ),

                // Play/Pause
                IconButton(
                  icon: Icon(
                    cubit.isPlaylistMode && audioState.isPlaying
                        ? Icons.pause_circle_outline_rounded
                        : Icons.play_circle_outline_rounded,
                    color: isDark
                        ? AppColors.primaryLighter
                        : AppColors.primary,
                  ),
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
