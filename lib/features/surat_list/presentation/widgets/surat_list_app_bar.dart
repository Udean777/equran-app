import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/theme/providers.dart';
import 'package:equran_app/core/widgets/app_logo.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// AppBar untuk SuratListPage — serif title, theme toggle, settings.
class SuratListAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SuratListAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.appBarHeightLG);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final contentColor = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;
    final themeState = ref.watch(themeViewModelProvider);

    return AppBar(
      backgroundColor: surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      shadowColor: AppColors.outline,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: AppDimens.appBarHeightLG,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLogo(
                size: 24,
                borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                l10n.appTitle,
                style: AppTypography.serifHeadingMedium.copyWith(
                  color: contentColor,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            width: 32,
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
        IconButton(
          icon: Icon(
            themeState.isDark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            color: contentColor,
          ),
          onPressed: () => ref.read(themeViewModelProvider.notifier).cycle(),
        ),
        IconButton(
          tooltip: l10n.settings,
          icon: Icon(Icons.settings_outlined, color: contentColor),
          onPressed: () => context.push(AppRoutes.settings),
        ),
      ],
    );
  }
}
