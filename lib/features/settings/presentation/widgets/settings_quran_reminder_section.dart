import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_reminder_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section reminder baca Quran — toggle + jam reminder.
class SettingsQuranReminderSection extends StatelessWidget {
  const SettingsQuranReminderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<QuranReminderCubit, QuranReminderPrefs>(
      builder: (context, prefs) {
        final cubit = context.read<QuranReminderCubit>();
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
                    width: 36,
                    height: 36,
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
                          'Aktifkan Reminder',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: isDark
                                ? AppColors.onSurfaceDark
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Pengingat harian membaca Al-Quran',
                          style: TextStyle(
                            fontSize: 12,
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
                    onChanged: (_) => unawaited(cubit.toggleEnabled()),
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
                        width: 36,
                        height: 36,
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
                              'Jam Reminder',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.onSurfaceDark
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Setiap hari pukul $timeLabel',
                              style: TextStyle(
                                fontSize: 12,
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
                            fontSize: 14,
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
    }
  }
}
