import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/domain/entities/audio_state_entity.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:equran_app/features/audio/presentation/cubit/audio_download_cubit.dart';
import 'package:equran_app/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Bar aksi dengan tombol pill berlabel agar user tahu fungsinya.
/// Ditempatkan di atas SwipeNavBar di dalam bottomNavigationBar.
class SuratActionBar extends StatelessWidget {
  const SuratActionBar({
    required this.detail,
    required this.autoScrollEnabled,
    required this.onToggleAutoScroll,
    super.key,
  });

  final SuratDetail detail;
  final bool autoScrollEnabled;
  final VoidCallback onToggleAutoScroll;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return BlocSelector<BookmarkCubit, BookmarkState, bool>(
      selector: (state) =>
          state.mapOrNull(
            success: (s) => s.suratProgressMap[detail.info.nomor] == 1.0,
          ) ??
          false,
      builder: (context, isCompleted) {
        return BlocBuilder<AudioDownloadCubit, AudioDownloadState>(
          builder: (context, downloadState) {
            final downloadCubit = context.read<AudioDownloadCubit>();

            return BlocBuilder<AudioCubit, AudioPlayerState>(
              buildWhen: (prev, next) => prev.currentQari != next.currentQari,
              builder: (context, audioState) {
                final audioCubit = context.read<AudioCubit>();
                final qari = audioState.currentQari;

                final isAllDownloaded = downloadState.isAllDownloaded(
                  detail.info.nomor,
                  detail.ayatList,
                  qari.id,
                );

                return Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    border: Border(top: BorderSide(color: borderColor)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceMD,
                    vertical: AppDimens.spaceXS + 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Hafalan — hanya muncul di debug mode
                      if (kDebugMode) ...[
                        _ActionPill(
                          icon: Icons.auto_stories_outlined,
                          label: 'Hafalan',
                          isDark: isDark,
                          onTap: () => unawaited(
                            context.push(
                              AppRoutes.hafalanSurat(detail.info.nomor),
                            ),
                          ),
                        ),
                        _ActionDivider(isDark: isDark),
                      ],

                      // Download — terkunci jika belum selesai baca semua ayat
                      if (downloadState.isDownloadingSurat)
                        _DownloadingPill(
                          downloadState: downloadState,
                          onCancel: downloadCubit.cancelSuratDownload,
                          isDark: isDark,
                        )
                      else
                        _ActionPill(
                          icon: isAllDownloaded
                              ? Icons.download_done_rounded
                              : (isCompleted
                                    ? Icons.download_for_offline_outlined
                                    : Icons.lock_outline_rounded),
                          label: isAllDownloaded ? 'Terunduh' : 'Unduh Audio',
                          isDark: isDark,
                          iconColor: isAllDownloaded
                              ? AppColors.success
                              : (isCompleted
                                    ? null
                                    : (isDark
                                          ? AppColors.onSurfaceDarkVariant
                                          : AppColors.textTertiary)),
                          onTap: isAllDownloaded
                              ? null
                              : (isCompleted
                                    ? () => unawaited(
                                        context
                                            .read<AudioDownloadCubit>()
                                            .downloadSurat(
                                              suratNomor: detail.info.nomor,
                                              ayatList: detail.ayatList,
                                              qari: qari,
                                            ),
                                      )
                                    : () => showLockedToast(
                                        context,
                                        'Selesaikan membaca semua ayat terlebih dahulu untuk mengunduh surat',
                                      )),
                        ),

                      // Auto-scroll toggle — hanya muncul saat playlist aktif
                      if (audioCubit.isPlaylistMode) ...[
                        _ActionDivider(isDark: isDark),
                        _ActionPill(
                          icon: autoScrollEnabled
                              ? Icons.gps_fixed_rounded
                              : Icons.gps_not_fixed_rounded,
                          label: autoScrollEnabled ? 'Sinkron' : 'Manual',
                          isDark: isDark,
                          iconColor: autoScrollEnabled
                              ? (isDark
                                    ? AppColors.primaryLighter
                                    : AppColors.primary)
                              : null,
                          onTap: onToggleAutoScroll,
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;
    final disabledColor = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textTertiary;
    final resolvedIconColor = onTap == null
        ? disabledColor
        : (iconColor ?? primaryColor);
    final labelColor = onTap == null ? disabledColor : null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceXS,
          vertical: AppDimens.spaceXS,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: resolvedIconColor),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color:
                    labelColor ??
                    (isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textSecondary),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadingPill extends StatelessWidget {
  const _DownloadingPill({
    required this.downloadState,
    required this.onCancel,
    required this.isDark,
  });

  final AudioDownloadState downloadState;
  final VoidCallback onCancel;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColors.primaryLighter : AppColors.primary;
    final progress = downloadState.suratDownloadTotal > 0
        ? downloadState.suratDownloadDone / downloadState.suratDownloadTotal
        : null;

    return GestureDetector(
      onTap: onCancel,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceXS,
          vertical: AppDimens.spaceXS,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2.5,
                    value: progress,
                    color: primaryColor,
                  ),
                  Icon(Icons.close, size: 9, color: primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Text(
              progress != null ? '${(progress * 100).round()}%' : 'Unduh...',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionDivider extends StatelessWidget {
  const _ActionDivider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: (isDark ? AppColors.outlineDark : AppColors.outlineVariant),
    );
  }
}
