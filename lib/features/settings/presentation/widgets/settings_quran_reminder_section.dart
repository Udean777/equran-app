import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/presentation/providers.dart';
import 'package:equran_app/features/quran_reminder/presentation/viewmodels/quran_reminder_viewmodel.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_constants.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_strings.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Section pengaturan reminder harian membaca Al-Quran.
///
/// Menampilkan toggle aktif/nonaktif dan jam pengingat.
/// Menggunakan `QuranReminderViewModel` via Riverpod untuk manage state reminder.
/// User dapat memilih waktu via system time picker.
class SettingsQuranReminderSection extends ConsumerWidget {
  const SettingsQuranReminderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(quranReminderViewModelProvider);
    final notifier = ref.read(quranReminderViewModelProvider.notifier);
    final prefs =
        state.mapOrNull(loaded: (s) => s.prefs) ?? const QuranReminderPrefs();
    final timeLabel =
        '${prefs.hour.toString().padLeft(2, '0')}:'
        '${prefs.minute.toString().padLeft(2, '0')}';

    return Column(
      children: [
        // Toggle aktif
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.cardPadding,
            vertical: AppDimens.spaceXS,
          ),
          child: Row(
            children: [
              Container(
                width: SettingsConstants.iconContainerSize,
                height: SettingsConstants.iconContainerSize,
                decoration: BoxDecoration(
                  color: prefs.enabled
                      ? (isDark
                            ? AppColors.primaryLight.withValues(alpha: 0.2)
                            : AppColors.primaryContainer)
                      : (isDark
                            ? AppColors.surfaceDarkVariant
                            : AppColors.surfaceVariant),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: AppDimens.iconSM,
                  color: prefs.enabled
                      ? (isDark ? AppColors.primaryLighter : AppColors.primary)
                      : (isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary),
                ),
              ),
              const SizedBox(width: AppDimens.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SettingsStrings.quranReminderToggle,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: SettingsConstants.fontSizeMedium,
                        color: isDark
                            ? AppColors.onSurfaceDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      SettingsStrings.quranReminderSubtitle,
                      style: TextStyle(
                        fontSize: SettingsConstants.fontSizeSecondary,
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: prefs.enabled,
                onChanged: (_) {
                  unawaited(notifier.toggleEnabled());
                  showSettingsToast(
                    context,
                    prefs.enabled
                        ? SettingsStrings.quranReminderInactive
                        : SettingsStrings.quranReminderActive,
                    isSuccess: !prefs.enabled,
                  );
                },
                activeThumbColor: AppColors.onPrimary,
                activeTrackColor: isDark
                    ? AppColors.primaryLighter
                    : AppColors.primary,
                inactiveThumbColor: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textTertiary,
                inactiveTrackColor: isDark
                    ? AppColors.surfaceDarkVariant
                    : AppColors.surfaceVariant,
              ),
            ],
          ),
        ),

        if (prefs.enabled) ...[
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimens.cardPadding,
            ),
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
          // Jam reminder
          InkWell(
            onTap: () => _pickTime(context, prefs, notifier),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.cardPadding,
                vertical: AppDimens.spaceMD,
              ),
              child: Row(
                children: [
                  Container(
                    width: SettingsConstants.iconContainerSize,
                    height: SettingsConstants.iconContainerSize,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusMD,
                      ),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      size: AppDimens.iconSM,
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          SettingsStrings.quranReminderTimeLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: SettingsConstants.fontSizeMedium,
                            color: isDark
                                ? AppColors.onSurfaceDark
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          SettingsStrings.quranReminderTimeValue(timeLabel),
                          style: TextStyle(
                            fontSize: SettingsConstants.fontSizeSecondary,
                            color: isDark
                                ? AppColors.onSurfaceDarkVariant
                                : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceMD,
                      vertical: AppDimens.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusFull,
                      ),
                    ),
                    child: Text(
                      timeLabel,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.primaryLighter
                            : AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: SettingsConstants.fontSizeMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Membuka dialog system time picker untuk memilih jam pengingat.
  ///
  /// Setelah user memilih waktu, memanggil `QuranReminderViewModel.setTime`
  /// dan menampilkan toast konfirmasi.
  Future<void> _pickTime(
    BuildContext context,
    QuranReminderPrefs prefs,
    QuranReminderViewModel notifier,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: prefs.hour, minute: prefs.minute),
    );
    if (picked != null) {
      unawaited(notifier.setTime(hour: picked.hour, minute: picked.minute));
      if (context.mounted) {
        final hh = picked.hour.toString().padLeft(2, '0');
        final mm = picked.minute.toString().padLeft(2, '0');
        showSettingsToast(
          context,
          SettingsStrings.quranReminderTimeChanged(hh, mm),
        );
      }
    }
  }
}
