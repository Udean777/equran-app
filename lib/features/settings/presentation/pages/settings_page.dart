import 'dart:async';

import 'package:equran_app/core/locale/cubit/language_cubit.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/settings/presentation/widgets/font_settings_sheet.dart';
import 'package:equran_app/features/settings/presentation/widgets/language_selector_sheet.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_about_section.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_quran_reminder_section.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_shalat_notif_section.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_theme_section.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final iconColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimens.appBarHeightLG,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.settings,
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
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
        children: [
          // ── Tampilan ──────────────────────────────────────────────────
          _SettingsSectionHeader(
            label: 'Tampilan',
            icon: Icons.palette_outlined,
            isDark: isDark,
          ),
          _LuxurySettingsCard(
            isDark: isDark,
            children: [
              // Tema
              const SettingsThemeSection(),
              _LuxuryDivider(isDark: isDark),
              // Tampilan Teks
              _LuxuryListTile(
                icon: Icons.text_fields_rounded,
                title: 'Tampilan Teks',
                subtitle: 'Ukuran & jenis font Arab',
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                ),
                isDark: isDark,
                onTap: () => _showFontSettingsSheet(context),
              ),
              _LuxuryDivider(isDark: isDark),
              // Bahasa
              BlocBuilder<LanguageCubit, LanguageState>(
                builder: (context, langState) => _LuxuryListTile(
                  icon: Icons.language_rounded,
                  title: l10n.language,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        langState.label,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.onSurfaceDarkVariant
                              : AppColors.textTertiary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceXS),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                      ),
                    ],
                  ),
                  isDark: isDark,
                  onTap: () => _showLanguageSheet(context, langState),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // ── Notifikasi Waktu Shalat ───────────────────────────────────
          _SettingsSectionHeader(
            label: 'Notifikasi Waktu Shalat',
            icon: Icons.notifications_outlined,
            isDark: isDark,
          ),
          _LuxurySettingsCard(
            isDark: isDark,
            children: const [SettingsShalatNotifSection()],
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // ── Reminder Baca Quran ───────────────────────────────────────
          _SettingsSectionHeader(
            label: 'Reminder Baca Quran',
            icon: Icons.auto_stories_rounded,
            isDark: isDark,
          ),
          _LuxurySettingsCard(
            isDark: isDark,
            children: const [SettingsQuranReminderSection()],
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // ── Sumber Data ───────────────────────────────────────────────
          _SettingsSectionHeader(
            label: 'Sumber Data',
            icon: Icons.cloud_outlined,
            isDark: isDark,
          ),
          const SettingsAboutSection(),
        ],
      ),
    );
  }

  void _showFontSettingsSheet(BuildContext context) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => BlocProvider.value(
          value: context.read<QuranFontCubit>(),
          child: const FontSettingsSheet(),
        ),
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, LanguageState current) {
    final l10n = AppLocalizations.of(context)!;
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (sheetContext) => BlocProvider.value(
          value: context.read<LanguageCubit>(),
          child: LanguageSelectorSheet(current: current, l10n: l10n),
        ),
      ),
    );
  }
}

// ── Shared luxury widgets ─────────────────────────────────────────────────────

class _SettingsSectionHeader extends StatelessWidget {
  const _SettingsSectionHeader({
    required this.label,
    required this.icon,
    required this.isDark,
  });

  final String label;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Icon(
            icon,
            size: 15,
            color: isDark ? AppColors.primaryLighter : AppColors.primary,
          ),
          const SizedBox(width: AppDimens.spaceXS),
          Text(
            label,
            style: AppTypography.serifHeadingSmall.copyWith(
              color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
              fontSize: 13,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _LuxurySettingsCard extends StatelessWidget {
  const _LuxurySettingsCard({
    required this.isDark,
    required this.children,
  });

  final bool isDark;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pagePadding),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          border: Border.all(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

class _LuxuryListTile extends StatelessWidget {
  const _LuxuryListTile({
    required this.icon,
    required this.title,
    required this.isDark,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.cardPadding,
          vertical: AppDimens.spaceMD,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryDark
                    : AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(
                icon,
                size: AppDimens.iconSM,
                color: isDark ? AppColors.primaryLighter : AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimens.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.onSurfaceDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _LuxuryDivider extends StatelessWidget {
  const _LuxuryDivider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.cardPadding),
      color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
    );
  }
}
