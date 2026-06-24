import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

class ShareAyatActionBar extends StatelessWidget {
  const ShareAyatActionBar({
    required this.onShare,
    required this.onSaveToGallery,
    required this.isGenerating,
    required this.isSaving,
    this.shareButtonKey,
    super.key,
  });

  final VoidCallback? onShare;
  final VoidCallback? onSaveToGallery;
  final bool isGenerating;
  final bool isSaving;
  final GlobalKey? shareButtonKey;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final surfaceColor = context.surfaceColor;
    final borderColor = context.borderVariantColor;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: borderColor),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        0,
        AppDimens.spaceMD,
        0,
        AppDimens.spaceLG,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.pagePadding,
          ),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  key: shareButtonKey,
                  onPressed: (isGenerating || isSaving) ? null : onShare,
                  icon: isGenerating
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : const Icon(Icons.share_rounded, size: 16),
                  label: Text(
                    isGenerating ? 'Membuat...' : 'Bagikan',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.primaryLight
                        : AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: (isGenerating || isSaving)
                      ? null
                      : onSaveToGallery,
                  icon: isSaving
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.primaryActionColor,
                          ),
                        )
                      : Icon(
                          Icons.download_rounded,
                          size: 16,
                          color: context.primaryActionColor,
                        ),
                  label: Text(
                    isSaving ? 'Menyimpan...' : 'Simpan',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.primaryActionColor,
                    side: BorderSide(
                      color: context.primaryActionColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
