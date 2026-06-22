import 'package:equran_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Sticky search bar delegate untuk [SliverPersistentHeader].
///
/// Menampilkan shadow saat di-pin (scroll melewati posisi awal).
class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  const SearchBarDelegate({required this.child});

  final Widget child;

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

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
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isPinned ? surfaceColor : bgColor,
        boxShadow: isPinned
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
