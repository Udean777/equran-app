import 'dart:async';

import 'package:equran_app/core/locale/cubit/language_cubit.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/cubit/theme_cubit.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // Dark Mode Toggle
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) => SwitchListTile(
              secondary: Icon(
                themeState.isDark
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: AppColors.primary,
              ),
              title: Text(
                themeState.isDark ? l10n.darkMode : l10n.lightMode,
              ),
              value: themeState.isDark,
              activeThumbColor: AppColors.primary,
              onChanged: (_) => context.read<ThemeCubit>().toggle(),
            ),
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
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceXS),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                ],
              ),
              onTap: () => _showLanguageSheet(context, langState),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, LanguageState current) {
    final l10n = AppLocalizations.of(context)!;

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (sheetContext) => BlocProvider.value(
          value: context.read<LanguageCubit>(),
          child: _LanguageSelectorSheet(current: current, l10n: l10n),
        ),
      ),
    );
  }
}

class _LanguageSelectorSheet extends StatelessWidget {
  const _LanguageSelectorSheet({
    required this.current,
    required this.l10n,
  });

  final LanguageState current;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final languages = [
      (const LanguageState.id(), l10n.indonesia, '🇮🇩'),
      (const LanguageState.en(), l10n.english, '🇬🇧'),
      (const LanguageState.ar(), l10n.arabic, '🇸🇦'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMD),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppDimens.spaceMD),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMD),
            child: Text(
              l10n.bahasa,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          ...languages.map(
            (entry) {
              final (lang, label, flag) = entry;
              final isSelected = lang.runtimeType == current.runtimeType;

              return ListTile(
                leading: Text(flag, style: const TextStyle(fontSize: 24)),
                title: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected ? AppColors.primary : null,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  unawaited(context.read<LanguageCubit>().changeLanguage(lang));
                  Navigator.pop(context);
                },
              );
            },
          ),
          const SizedBox(height: AppDimens.spaceMD),
        ],
      ),
    );
  }
}
