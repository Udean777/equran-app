import 'dart:async';

import 'package:equran_app/core/locale/cubit/language_cubit.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/widgets/section_header.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Tema Tampilan
          const SettingsThemeSection(),
          const Divider(height: 1),

          // Tampilan Teks
          ListTile(
            leading: const Icon(
              Icons.text_fields_rounded,
              color: AppColors.primary,
            ),
            title: const Text('Tampilan Teks'),
            subtitle: const Text('Ukuran & jenis font Arab'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () => _showFontSettingsSheet(context),
          ),
          const Divider(height: 1),

          // Language Selector
          BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, langState) => ListTile(
              leading: const Icon(
                Icons.language_rounded,
                color: AppColors.primary,
              ),
              title: Text(l10n.language),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    langState.label,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(width: AppDimens.spaceXS),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                ],
              ),
              onTap: () => _showLanguageSheet(context, langState),
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: AppDimens.spaceLG),

          // Notifikasi Waktu Shalat
          const SectionHeader(label: 'Notifikasi Waktu Shalat'),
          const SettingsShalatNotifSection(),
          const Divider(height: 1),
          const SizedBox(height: AppDimens.spaceLG),

          // Reminder Baca Quran
          const SectionHeader(label: 'Reminder Baca Quran'),
          const SettingsQuranReminderSection(),
          const Divider(height: 1),
          const SizedBox(height: AppDimens.spaceLG),

          // Sumber Data
          const SettingsAboutSection(),
          const SizedBox(height: AppDimens.spaceXL),
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
