import 'dart:async';

import 'package:equran_app/core/locale/cubit/language_cubit.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/cubit/theme_cubit.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/shalat_notif_cubit.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
          const Divider(height: 1),
          const SizedBox(height: AppDimens.spaceLG),

          // ── Notifikasi Waktu Shalat ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMD,
              vertical: AppDimens.spaceXS,
            ),
            child: Text(
              'Notifikasi Waktu Shalat',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          BlocBuilder<ShalatNotifCubit, ShalatNotifPrefs>(
            builder: (context, prefs) {
              final cubit = context.read<ShalatNotifCubit>();
              return Column(
                children: [
                  _NotifToggleTile(
                    label: 'Subuh',
                    icon: Icons.wb_twilight_rounded,
                    value: prefs.subuh,
                    onChanged: (_) => cubit.toggleSubuh(),
                  ),
                  _NotifToggleTile(
                    label: 'Dzuhur',
                    icon: Icons.wb_sunny_rounded,
                    value: prefs.dzuhur,
                    onChanged: (_) => cubit.toggleDzuhur(),
                  ),
                  _NotifToggleTile(
                    label: 'Ashar',
                    icon: Icons.wb_sunny_outlined,
                    value: prefs.ashar,
                    onChanged: (_) => cubit.toggleAshar(),
                  ),
                  _NotifToggleTile(
                    label: 'Maghrib',
                    icon: Icons.nights_stay_outlined,
                    value: prefs.maghrib,
                    onChanged: (_) => cubit.toggleMaghrib(),
                  ),
                  _NotifToggleTile(
                    label: 'Isya',
                    icon: Icons.nightlight_round,
                    value: prefs.isya,
                    onChanged: (_) => cubit.toggleIsya(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.timer_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text('Ingatkan sebelum'),
                    trailing: DropdownButton<int>(
                      value: prefs.menitSebelum,
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Tepat waktu')),
                        DropdownMenuItem(
                          value: 5,
                          child: Text('5 menit sebelum'),
                        ),
                        DropdownMenuItem(
                          value: 10,
                          child: Text('10 menit sebelum'),
                        ),
                        DropdownMenuItem(
                          value: 15,
                          child: Text('15 menit sebelum'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) unawaited(cubit.setMenitSebelum(val));
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 1),
          const SizedBox(height: AppDimens.spaceLG),

          // ── Sumber Data ──────────────────────────────────────────────
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
              ),
            ),
            color: Theme.of(context).cardColor.withValues(alpha: 0.4),
            margin: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMD),
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.spaceMD),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.cloud_done_outlined,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sumber Data & API',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Didukung oleh equran.id',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceMD),
                  Text(
                    'Seluruh data Al-Quran, terjemahan, tafsir Kemenag RI, serta kumpulan doa harian disinkronkan secara real-time dari API publik equran.id.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      height: 1.4,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceSM),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async {
                        final url = Uri.parse('https://equran.id/');
                        try {
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tidak dapat membuka tautan'),
                                ),
                              );
                            }
                          }
                        } on Exception catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Terjadi kesalahan saat membuka tautan',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: const Text(
                        'Kunjungi equran.id',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),
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

class _NotifToggleTile extends StatelessWidget {
  const _NotifToggleTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(label),
      value: value,
      activeThumbColor: AppColors.primary,
      onChanged: onChanged,
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
