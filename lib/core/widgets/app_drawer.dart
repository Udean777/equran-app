import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/app_logo.dart';
import 'package:equran_app/core/widgets/streak_badge.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    unawaited(_loadVersion());
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _version = 'eQuran v${info.version}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(AppDimens.radiusXL),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _DrawerHeader(isDark: isDark),

          // Menu items — scrollable
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSM,
                vertical: AppDimens.spaceSM,
              ),
              children: [
                const _SectionLabel(label: 'Ibadah'),
                _DrawerItem(
                  icon: Icons.mosque_outlined,
                  selectedIcon: Icons.mosque_rounded,
                  label: l10n.imsakiyahNav,
                  onTap: () {
                    Navigator.pop(context);
                    unawaited(context.push(AppRoutes.imsakiyah));
                  },
                ),
                if (kDebugMode)
                  _DrawerItem(
                    icon: Icons.auto_stories_outlined,
                    selectedIcon: Icons.auto_stories_rounded,
                    label: l10n.hafalanDrawer,
                    onTap: () {
                      Navigator.pop(context);
                      unawaited(context.push(AppRoutes.hafalan));
                    },
                  ),
                _DrawerItem(
                  icon: Icons.auto_stories_outlined,
                  selectedIcon: Icons.auto_stories_rounded,
                  label: l10n.doaHarianDrawer,
                  onTap: () {
                    Navigator.pop(context);
                    unawaited(context.push(AppRoutes.doaHarian));
                  },
                ),

                const SizedBox(height: AppDimens.spaceSM),
                const _SectionLabel(label: 'Catatan & Statistik'),
                _DrawerItem(
                  icon: Icons.bookmark_outline_rounded,
                  selectedIcon: Icons.bookmark_rounded,
                  label: l10n.bookmarkNav,
                  onTap: () {
                    Navigator.pop(context);
                    unawaited(context.push(AppRoutes.bookmark));
                  },
                ),
                _DrawerItem(
                  icon: Icons.edit_note_outlined,
                  selectedIcon: Icons.edit_note_rounded,
                  label: l10n.catatanDrawer,
                  onTap: () {
                    Navigator.pop(context);
                    unawaited(context.push(AppRoutes.catatan));
                  },
                ),
                _DrawerItem(
                  icon: Icons.bar_chart_outlined,
                  selectedIcon: Icons.bar_chart_rounded,
                  label: l10n.statistikBacaDrawer,
                  onTap: () {
                    Navigator.pop(context);
                    unawaited(context.push(AppRoutes.readingStats));
                  },
                ),
                _DrawerItem(
                  icon: Icons.mosque_outlined,
                  selectedIcon: Icons.mosque_rounded,
                  label: l10n.statistikShalatDrawer,
                  onTap: () {
                    Navigator.pop(context);
                    unawaited(context.push(AppRoutes.statistikShalat));
                  },
                ),

                const SizedBox(height: AppDimens.spaceSM),
                const _SectionLabel(label: 'Lainnya'),
                _DrawerItem(
                  icon: Icons.audio_file_outlined,
                  selectedIcon: Icons.audio_file_rounded,
                  label: l10n.manajemenAudioDrawer,
                  onTap: () {
                    Navigator.pop(context);
                    unawaited(context.push(AppRoutes.audioStorage));
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings_rounded,
                  label: l10n.pengaturanDrawer,
                  onTap: () async {
                    Navigator.pop(context);
                    await context.push(AppRoutes.settings);
                  },
                ),
              ],
            ),
          ),

          // Footer — versi app dynamic
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceMD,
              AppDimens.spaceSM,
              AppDimens.spaceMD,
              AppDimens.spaceLG,
            ),
            child: Text(
              _version,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textTertiary,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Drawer Header — luxury gradient
// ---------------------------------------------------------------------------

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.primaryDark, AppColors.primary]
              : [AppColors.primary, AppColors.primaryLight],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceLG,
            AppDimens.spaceLG,
            AppDimens.spaceLG,
            AppDimens.spaceLG,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo container dengan gold border
              AppLogo(
                size: 52,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),

              const SizedBox(height: AppDimens.spaceMD),

              // App name — serif
              Text(
                'eQuran',
                style: AppTypography.serifHeadingLarge.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: AppDimens.spaceXS),

              // Gold divider line
              Container(
                width: 32,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
              ),

              const SizedBox(height: AppDimens.spaceSM),

              // Streak chip
              BlocBuilder<QuranStreakCubit, QuranStreakState>(
                builder: (context, state) {
                  final streak = state.mapOrNull(loaded: (s) => s.streak) ?? 0;
                  if (streak == 0) return const SizedBox.shrink();
                  return StreakBadge(streak: streak);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section label
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMD,
        AppDimens.spaceSM,
        AppDimens.spaceMD,
        AppDimens.spaceXS,
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isDark
              ? AppColors.onSurfaceDarkVariant
              : AppColors.textTertiary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Drawer item
// ---------------------------------------------------------------------------

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        splashColor: AppColors.primaryContainer,
        highlightColor: AppColors.primaryContainer.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMD,
            vertical: AppDimens.spaceSM + 2,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDark ? AppColors.primaryLighter : AppColors.primary,
                size: AppDimens.iconMD,
              ),
              const SizedBox(width: AppDimens.spaceMD),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceDark
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                color: isDark ? AppColors.primaryLighter : AppColors.primary,
                Icons.chevron_right_rounded,
                size: AppDimens.iconSM + 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
