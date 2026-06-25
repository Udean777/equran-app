import 'dart:async';

import 'package:equran_app/core/locale/providers.dart';
import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/providers.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/core/widgets/luxury_list_tile.dart';
import 'package:equran_app/core/widgets/section_header.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_strings.dart';
import 'package:equran_app/features/settings/presentation/widgets/font_settings_sheet.dart';
import 'package:equran_app/features/settings/presentation/widgets/language_selector_sheet.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_about_section.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_brand_header.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_confirmation_dialog.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_luxury_card.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_quran_reminder_section.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_shalat_notif_section.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_theme_section.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langState = ref.watch(languageViewModelProvider);

    if (langState is LanguageError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSettingsToast(context, langState.message, isSuccess: false);
      });
    }

    return Scaffold(
      appBar: const LuxuryAppBar(title: SettingsStrings.pageTitle),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
        children: [
          // Brand Header
          const SettingsBrandHeader(),

          // ── Tampilan ──────────────────────────────────────────────────
          const SectionHeader(
            label: SettingsStrings.sectionDisplay,
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
                title: SettingsStrings.fontSettingsTitle,
                subtitle: SettingsStrings.fontSettingsSubtitle,
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                ),
                onTap: () => _showFontSettingsSheet(context),
              ),
              const LuxuryDivider(),
              // Bahasa
              _LanguageTile(
                langState: langState,
                onTap: () => _showLanguageSheet(context, ref, langState),
              ),
            ],
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // ── Notifikasi Waktu Shalat ───────────────────────────────────
          const SectionHeader(
            label: SettingsStrings.shalatNotifTitle,
            icon: Icons.notifications_outlined,
          ),
          const SettingsLuxuryCard(
            children: [SettingsShalatNotifSection()],
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // ── Reminder Baca Quran ───────────────────────────────────────
          const SectionHeader(
            label: SettingsStrings.quranReminderTitle,
            icon: Icons.auto_stories_rounded,
          ),
          const SettingsLuxuryCard(
            children: [SettingsQuranReminderSection()],
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // ── Developer ─────────────────────────────────────────────────
          if (kDebugMode) ...[
            const SizedBox(height: AppDimens.spaceMD),

            // ── Developer ─────────────────────────────────────────────────
            const SectionHeader(
              label: SettingsStrings.sectionDeveloper,
              icon: Icons.developer_mode_rounded,
            ),
            SettingsLuxuryCard(
              children: [
                LuxuryListTile(
                  icon: Icons.notifications_active_rounded,
                  title: 'Test Notifikasi',
                  subtitle: 'Coba semua jenis notif — adzan, imsak, quran, dll',
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                  ),
                  onTap: () => context.push(AppRoutes.notificationTest),
                ),
              ],
            ),
          ],

          const SizedBox(height: AppDimens.spaceMD),

          // ── Sumber Data ───────────────────────────────────────────────
          const SectionHeader(
            label: SettingsStrings.sectionDataSource,
            icon: Icons.cloud_outlined,
          ),
          const SettingsAboutSection(),

          const SizedBox(height: AppDimens.spaceXL),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLG),
            child: ElevatedButton.icon(
              onPressed: () => _handleResetAll(context, ref),
              icon: const Icon(Icons.restore_rounded),
              label: const Text(SettingsStrings.resetAllButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
                foregroundColor: AppColors.error,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleResetAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showSettingsConfirmationDialog(
      context: context,
      title: SettingsStrings.resetAllDialogTitle,
      message: SettingsStrings.resetAllDialogMessage,
      isDestructive: true,
      confirmText: 'Reset',
    );

    if (confirmed == true && context.mounted) {
      await ref.read(themeViewModelProvider.notifier).reset();
      await ref.read(quranFontViewModelProvider.notifier).reset();
      await ref.read(languageViewModelProvider.notifier).reset();

      if (context.mounted) {
        showSettingsToast(context, SettingsStrings.resetAllSuccess);
      }
    }
  }

  void _showFontSettingsSheet(BuildContext context) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => const FontSettingsSheet(),
      ),
    );
  }

  void _showLanguageSheet(
    BuildContext context,
    WidgetRef ref,
    LanguageState current,
  ) {
    final l10n = AppLocalizations.of(context)!;
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => LanguageSelectorSheet(current: current, l10n: l10n),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.langState, required this.onTap});

  final LanguageState langState;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return LuxuryListTile(
      icon: Icons.language_rounded,
      title: AppLocalizations.of(context)!.language,
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
      onTap: onTap,
    );
  }
}
