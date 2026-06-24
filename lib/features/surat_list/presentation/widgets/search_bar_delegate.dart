import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/surat_list/constants/surat_list_constants.dart';
import 'package:flutter/material.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  const SearchBarDelegate({required this.child});

  final Widget child;

  @override
  double get maxExtent => AppDimens.searchBarHeight;

  @override
  double get minExtent => AppDimens.searchBarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final isDark = context.isDark;
    final isPinned = shrinkOffset > 0 || overlapsContent;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;

    return AnimatedContainer(
      duration: AppDimens.animationFast,
      decoration: BoxDecoration(
        color: isPinned ? surfaceColor : bgColor,
        boxShadow: isPinned
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark
                        ? SuratListConstants.searchBarShadowAlphaDark
                        : SuratListConstants.searchBarShadowAlphaLight,
                  ),
                  blurRadius: SuratListConstants.searchBarShadowBlur,
                  offset: const Offset(0, SuratListConstants.searchBarShadowOffset),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate is! SearchBarDelegate || child != oldDelegate.child;
}
