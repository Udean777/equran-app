import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_reminder_cubit.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_constants.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_strings.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section pengaturan reminder harian membaca Al-Quran.
///
/// Menampilkan toggle aktif/nonaktif dan jam pengingat.
/// Menggunakan `QuranReminderCubit` untuk manage state reminder.
/// User dapat memilih waktu via system time picker.
class SettingsQuranReminderSection extends StatelessWidget {
  const SettingsQuranReminderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<QuranReminderCubit, QuranReminderState>(
      builder: (context, state) {
        final cubit = context.read<QuranReminderCubit>();
        final prefs =
            state.mapOrNull(loaded: (s) => s.prefs) ??
            const QuranReminderPrefs();
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
                          ? (isDark
                                ? AppColors.primaryLighter
                                : AppColors.primary)
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
                      unawaited(cubit.toggleEnabled());
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
                color: isDark
                    ? AppColors.outlineDark
                    : AppColors.outlineVariant,
              ),
              // Jam reminder
              InkWell(
                onTap: () => _pickTime(context, prefs, cubit),
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
      },
    );
  }

  /// Membuka dialog system time picker untuk memilih jam pengingat.
  ///
  /// Setelah user memilih waktu, memanggil `QuranReminderCubit.setTime`
  /// dan menampilkan toast konfirmasi.
  Future<void> _pickTime(
    BuildContext context,
    QuranReminderPrefs prefs,
    QuranReminderCubit cubit,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: prefs.hour, minute: prefs.minute),
    );
    if (picked != null) {
      unawaited(cubit.setTime(hour: picked.hour, minute: picked.minute));
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
