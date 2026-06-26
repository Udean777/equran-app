import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/surat_detail/presentation/constants/ayat_badge_config.dart';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Nomor badge
// ---------------------------------------------------------------------------

class AyatNumberBadge extends StatelessWidget {
  const AyatNumberBadge({
    required this.nomor,
    required this.hasCatatan,
    required this.isDark,
    required this.isPlaying,
    super.key,
  });

  final int nomor;
  final bool hasCatatan;
  final bool isDark;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final bgColor = isPlaying
        ? isDark
              ? AppColors.primaryLight
              : AppColors.primary
        : context.primaryContainerColor;
    final textColor = isPlaying
        ? AppColors.onPrimary
        : context.primaryActionColor;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isPlaying
                  ? Colors.transparent
                  : (isDark
                        ? AppColors.primaryLight.withValues(alpha: 0.3)
                        : AppColors.primary.withValues(alpha: 0.2)),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            nomor.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: nomor > AyatBadgeConfig.largeNumberThreshold
                  ? AyatBadgeConfig.fontSizeLarge
                  : AyatBadgeConfig.fontSizeSmall,
            ),
          ),
        ),
        if (hasCatatan)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.surfaceColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Action buttons row
// ---------------------------------------------------------------------------

class AyatActionButtons extends StatelessWidget {
  const AyatActionButtons({
    required this.isPlaying,
    required this.isAudioLoading,
    required this.isBookmarked,
    required this.hasCatatan,
    required this.isDownloaded,
    required this.isDownloading,
    required this.downloadProgress,
    required this.onPlayTap,
    required this.onBookmarkToggle,
    required this.onShareTap,
    required this.onCatatanTap,
    required this.onDownloadTap,
    super.key,
  });

  final bool isPlaying;
  final bool isAudioLoading;
  final bool isBookmarked;
  final bool hasCatatan;
  final bool isDownloaded;
  final bool isDownloading;
  final double downloadProgress;
  final VoidCallback? onPlayTap;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onShareTap;
  final VoidCallback? onCatatanTap;
  final VoidCallback? onDownloadTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = context.textTertiaryColor;
    final activeColor = context.primaryActionColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play
        if (onPlayTap != null)
          isAudioLoading
              ? SizedBox(
                  width: 32,
                  height: 32,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: activeColor,
                    ),
                  ),
                )
              : _AyatActionBtn(
                  icon: isPlaying
                      ? Icons.pause_circle_outline_rounded
                      : Icons.play_circle_outline_rounded,
                  color: isPlaying ? activeColor : iconColor,
                  onTap: onPlayTap,
                ),

        // Bookmark
        if (onBookmarkToggle != null)
          _AyatActionBtn(
            icon: isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            color: isBookmarked ? AppColors.gold : iconColor,
            onTap: onBookmarkToggle,
          ),

        // Share
        if (onShareTap != null)
          _AyatActionBtn(
            icon: Icons.share_rounded,
            color: iconColor,
            onTap: onShareTap,
          ),

        // Catatan
        if (onCatatanTap != null)
          _AyatActionBtn(
            icon: Icons.edit_note_rounded,
            color: hasCatatan ? AppColors.gold : iconColor,
            onTap: onCatatanTap,
          ),

        // Download
        if (onDownloadTap != null)
          isDownloading
              ? SizedBox(
                  width: 32,
                  height: 32,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: downloadProgress > 0 ? downloadProgress : null,
                      color: activeColor,
                    ),
                  ),
                )
              : _AyatActionBtn(
                  icon: isDownloaded
                      ? Icons.download_done_rounded
                      : Icons.download_outlined,
                  color: isDownloaded ? AppColors.success : iconColor,
                  onTap: isDownloaded ? null : onDownloadTap,
                ),
      ],
    );
  }
}

class _AyatActionBtn extends StatelessWidget {
  const _AyatActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: AppDimens.iconMD),
      onPressed: onTap,
      padding: const EdgeInsets.all(AppDimens.spaceXS),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
