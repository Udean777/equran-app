import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:flutter/material.dart';

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    required this.bookmark,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  final Bookmark bookmark;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Material(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(AppDimens.cardPadding),
            child: Row(
              children: [
                // Gold bookmark icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.bookmark_rounded,
                    color: AppColors.gold,
                    size: AppDimens.iconSM,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMD),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${bookmark.namaLatin} · Ayat ${bookmark.ayatNomor}',
                        style: AppTypography.serifHeadingSmall.copyWith(
                          color: isDark
                              ? AppColors.primaryLighter
                              : AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXS),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          bookmark.teksArab,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 16,
                            color: isDark
                                ? AppColors.primaryLighter
                                : AppColors.primary,
                            height: 1.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXS),
                      Text(
                        bookmark.teksIndonesia,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.onSurfaceDarkVariant
                              : AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                // Remove button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error.withValues(alpha: 0.6),
                    size: AppDimens.iconSM,
                  ),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
