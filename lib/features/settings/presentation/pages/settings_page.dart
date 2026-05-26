import 'dart:async';

import 'package:equran_app/core/locale/cubit/language_cubit.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:equran_app/core/theme/cubit/theme_cubit.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/widgets/section_header.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/shalat_notif_cubit.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_reminder_cubit.dart';
import 'package:equran_app/features/settings/presentation/widgets/font_settings_sheet.dart';
import 'package:equran_app/features/settings/presentation/widgets/language_selector_sheet.dart';
import 'package:equran_app/features/settings/presentation/widgets/notif_toggle_tile.dart';
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
          // Tema — 3-way segmented button
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMD,
                vertical: AppDimens.spaceSM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.palette_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppDimens.spaceSM),
                      Text(
                        'Tema Tampilan',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceSM),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'light',
                        label: Text('Terang'),
                        icon: Icon(Icons.light_mode_rounded),
                      ),
                      ButtonSegment(
                        value: 'dark',
                        label: Text('Gelap'),
                        icon: Icon(Icons.dark_mode_rounded),
                      ),
                      ButtonSegment(
                        value: 'sepia',
                        label: Text('Sepia'),
                        icon: Icon(Icons.auto_stories_rounded),
                      ),
                    ],
                    selected: {
                      if (themeState.isSepia)
                        'sepia'
                      else if (themeState.isDark)
                        'dark'
                      else
                        'light',
                    },
                    onSelectionChanged: (selected) {
                      final current = themeState.isSepia
                          ? 'sepia'
                          : themeState.isDark
                          ? 'dark'
                          : 'light';
                      if (selected.first != current) {
                        unawaited(context.read<ThemeCubit>().cycle());
                      }
                    },
                    style: ButtonStyle(
                      iconColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.onPrimary;
                        }
                        return AppColors.primary;
                      }),
                      backgroundColor: WidgetStateProperty.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.primary;
                          }
                          return null;
                        },
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.onPrimary;
                          }
                          return AppColors.primary;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          const SectionHeader(
            label: 'Notifikasi Waktu Shalat',
          ),
          BlocBuilder<ShalatNotifCubit, ShalatNotifPrefs>(
            builder: (context, prefs) {
              final cubit = context.read<ShalatNotifCubit>();
              return Column(
                children: [
                  NotifToggleTile(
                    label: 'Subuh',
                    icon: Icons.wb_twilight_rounded,
                    value: prefs.subuh,
                    onChanged: (_) => cubit.toggleSubuh(),
                  ),
                  NotifToggleTile(
                    label: 'Dzuhur',
                    icon: Icons.wb_sunny_rounded,
                    value: prefs.dzuhur,
                    onChanged: (_) => cubit.toggleDzuhur(),
                  ),
                  NotifToggleTile(
                    label: 'Ashar',
                    icon: Icons.wb_sunny_outlined,
                    value: prefs.ashar,
                    onChanged: (_) => cubit.toggleAshar(),
                  ),
                  NotifToggleTile(
                    label: 'Maghrib',
                    icon: Icons.nights_stay_outlined,
                    value: prefs.maghrib,
                    onChanged: (_) => cubit.toggleMaghrib(),
                  ),
                  NotifToggleTile(
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

          // ── Reminder Baca Quran ──────────────────────────────────────
          const SectionHeader(label: 'Reminder Baca Quran'),
          BlocBuilder<QuranReminderCubit, QuranReminderPrefs>(
            builder: (context, prefs) {
              final cubit = context.read<QuranReminderCubit>();
              final timeLabel =
                  '${prefs.hour.toString().padLeft(2, '0')}:'
                  '${prefs.minute.toString().padLeft(2, '0')}';
              return Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(
                      Icons.auto_stories_rounded,
                      color: AppColors.primary,
                    ),
                    title: const Text('Aktifkan Reminder'),
                    subtitle: const Text('Pengingat harian membaca Al-Quran'),
                    value: prefs.enabled,
                    activeThumbColor: AppColors.primary,
                    onChanged: (_) => unawaited(cubit.toggleEnabled()),
                  ),
                  if (prefs.enabled) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.primary,
                      ),
                      title: const Text('Jam Reminder'),
                      trailing: Text(
                        'Setiap hari pukul $timeLabel',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: prefs.hour,
                            minute: prefs.minute,
                          ),
                        );
                        if (picked != null && context.mounted) {
                          unawaited(
                            cubit.setTime(
                              hour: picked.hour,
                              minute: picked.minute,
                            ),
                          );
                        }
                      },
                    ),
                  ],
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
