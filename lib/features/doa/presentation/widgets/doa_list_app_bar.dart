import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// AppBar untuk halaman daftar doa — dengan toggle search dan filter button.
///
/// Menerima [hasActiveFilter] dari parent (DIP) — tidak akses cubit sendiri.
class DoaListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DoaListAppBar({
    required this.l10n,
    required this.canPop,
    required this.searchVisible,
    required this.hasActiveFilter,
    required this.onToggleSearch,
    required this.onFilter,
    super.key,
  });

  final AppLocalizations l10n;
  final bool canPop;
  final bool searchVisible;

  /// Status filter aktif — di-pass dari parent, bukan diambil dari cubit.
  final bool hasActiveFilter;

  final VoidCallback onToggleSearch;
  final VoidCallback onFilter;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.appBarHeightLG);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final iconColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;
    final activeColor = isDark ? AppColors.primaryLighter : AppColors.primary;

    return AppBar(
      backgroundColor: surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: AppDimens.appBarHeightLG,
      leading: canPop
          ? BackButton(color: iconColor)
          : Builder(
              builder: (ctx) => IconButton(
                icon: Icon(Icons.menu_rounded, color: iconColor),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.doaList,
            style: AppTypography.serifHeadingMedium.copyWith(
              color: iconColor,
              height: 1,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: 20,
            height: 1.5,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        // Search toggle
        IconButton(
          icon: Icon(
            searchVisible ? Icons.search_off_rounded : Icons.search_rounded,
            color: searchVisible ? activeColor : iconColor,
          ),
          onPressed: onToggleSearch,
        ),
        // Filter dengan badge
        IconButton(
          icon: Badge(
            isLabelVisible: hasActiveFilter,
            backgroundColor: AppColors.gold,
            smallSize: 8,
            child: Icon(
              Icons.tune_rounded,
              color: hasActiveFilter ? activeColor : iconColor,
            ),
          ),
          onPressed: onFilter,
        ),
      ],
    );
  }
}
