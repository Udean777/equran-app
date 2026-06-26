import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/audio/presentation/providers.dart';
import 'package:equran_app/features/bookmark/presentation/providers.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Bar aksi dengan tombol pill berlabel agar user tahu fungsinya.
/// Ditempatkan di atas SwipeNavBar di dalam bottomNavigationBar.
class SuratActionBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final surfaceColor = context.surfaceColor;
    final borderColor = context.borderSubtleColor;

    final bookmarkState = ref.watch(bookmarkViewModelProvider);
    final isCompleted =
        bookmarkState.mapOrNull(
          success: (s) => s.suratProgressMap[detail.nomor] == 1.0,
        ) ??
        false;

    final downloadState = ref.watch(audioDownloadViewModelProvider);
    final audioState = ref.watch(audioViewModelProvider);
    final downloadNotifier = ref.read(audioDownloadViewModelProvider.notifier);
    final audioNotifier = ref.read(audioViewModelProvider.notifier);
    final qari = audioState.currentQari;

    final isAllDownloaded = downloadState.isAllDownloaded(
      detail.nomor,
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
          if (kDebugMode) ...[
            _ActionPill(
              icon: Icons.auto_stories_outlined,
              label: 'Hafalan',
              onTap: () => unawaited(
                context.push(
                  AppRoutes.hafalanSurat(detail.nomor),
                ),
              ),
            ),
            const _ActionDivider(),
          ],

          if (downloadState.isDownloadingSurat)
            _DownloadingPill(
              downloadState: downloadState,
              onCancel: downloadNotifier.cancelSuratDownload,
            )
          else
            _ActionPill(
              icon: isAllDownloaded
                  ? Icons.download_done_rounded
                  : (isCompleted
                        ? Icons.download_for_offline_outlined
                        : Icons.lock_outline_rounded),
              label: isAllDownloaded ? 'Terunduh' : 'Unduh Audio',
              iconColor: isAllDownloaded
                  ? AppColors.success
                  : (isCompleted ? null : context.textTertiaryColor),
              onTap: isAllDownloaded
                  ? null
                  : (isCompleted
                        ? () => unawaited(
                            downloadNotifier.downloadSurat(
                              suratNomor: detail.nomor,
                              ayatList: detail.ayatList,
                              qari: qari,
                            ),
                          )
                        : () => showLockedToast(
                            context,
                            'Selesaikan membaca semua ayat terlebih dahulu untuk mengunduh surat',
                          )),
            ),

          if (audioNotifier.isPlaylistMode) ...[
            const _ActionDivider(),
            _ActionPill(
              icon: autoScrollEnabled
                  ? Icons.gps_fixed_rounded
                  : Icons.gps_not_fixed_rounded,
              label: autoScrollEnabled ? 'Sinkron' : 'Manual',
              iconColor: autoScrollEnabled ? context.primaryActionColor : null,
              onTap: onToggleAutoScroll,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryActionColor;
    final disabledColor = context.textTertiaryColor;
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
                color: labelColor ?? context.textSecondaryColor,
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
  });

  final AudioDownloadState downloadState;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryActionColor;
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
                color: context.textSecondaryColor,
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
  const _ActionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: context.borderSubtleColor,
    );
  }
}
