import 'dart:async';

import 'package:equran_app/core/locale/cubit/language_cubit.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/core/widgets/luxury_list_tile.dart';
import 'package:equran_app/core/widgets/section_header.dart';
import 'package:equran_app/features/settings/presentation/widgets/font_settings_sheet.dart';
import 'package:equran_app/features/settings/presentation/widgets/language_selector_sheet.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_about_section.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_luxury_card.dart';
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

    return Scaffold(
      appBar: const LuxuryAppBar(title: 'Pengaturan'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
        children: [
          // ── Tampilan ──────────────────────────────────────────────────
          const SectionHeader(
            label: 'Tampilan',
            icon: Icons.palette_outlined,
          ),
          SettingsLuxuryCard(
            children: [
              // Tema
              const SettingsThemeSection(),
              const LuxuryDivider(),
              // Tampilan Teks
              LuxuryListTile(
                icon: Icons.text_fields_rounded,
                title: 'Tampilan Teks',
                subtitle: 'Ukuran & jenis font Arab',
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                ),
                onTap: () => _showFontSettingsSheet(context),
              ),
              const LuxuryDivider(),
              // Bahasa
              BlocBuilder<LanguageCubit, LanguageState>(
                builder: (context, langState) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return LuxuryListTile(
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
                    onTap: () => _showLanguageSheet(context, langState),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // ── Notifikasi Waktu Shalat ───────────────────────────────────
          const SectionHeader(
            label: 'Notifikasi Waktu Shalat',
            icon: Icons.notifications_outlined,
          ),
          const SettingsLuxuryCard(
            children: [SettingsShalatNotifSection()],
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // ── Reminder Baca Quran ───────────────────────────────────────
          const SectionHeader(
            label: 'Reminder Baca Quran',
            icon: Icons.auto_stories_rounded,
          ),
          const SettingsLuxuryCard(
            children: [SettingsQuranReminderSection()],
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // ── Sumber Data ───────────────────────────────────────────────
          const SectionHeader(
            label: 'Sumber Data',
            icon: Icons.cloud_outlined,
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
