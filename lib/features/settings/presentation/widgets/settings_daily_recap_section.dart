import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_constants.dart';
import 'package:equran_app/features/settings/presentation/widgets/notif_toggle_tile.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:equran_app/features/statistik_shalat/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsDailyRecapSection extends ConsumerWidget {
  const SettingsDailyRecapSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final recapService = ref.watch(shalatRecapNotificationServiceProvider);

    final isEnabled = recapService.isEnabled;
    final hour = recapService.hour;
    final minute = recapService.minute;

    return Column(
      children: [
        NotifToggleTile(
          label: 'Notifikasi Rekap Harian',
          icon: Icons.assignment_turned_in_rounded,
          value: isEnabled,
          onChanged: (val) async {
            await recapService.setEnabled(value: val);
            // Ignore stats param, service will fetch today's stats if null
            unawaited(recapService.updateSchedule());
            if (context.mounted) {
              showSettingsToast(
                context,
                val
                    ? 'Notifikasi rekap harian diaktifkan'
                    : 'Notifikasi rekap harian dinonaktifkan',
                isSuccess: val,
              );
            }
          },
        ),
        if (isEnabled) ...[
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimens.cardPadding,
            ),
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
          InkWell(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: hour, minute: minute),
              );
              if (time != null) {
                await recapService.setTime(time.hour, time.minute);
                unawaited(recapService.updateSchedule());
                if (context.mounted) {
                  showSettingsToast(
                    context,
                    'Waktu rekap harian diubah menjadi ${time.format(context)}',
                  );
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.cardPadding,
                AppDimens.spaceSM,
                AppDimens.cardPadding,
                AppDimens.spaceSM,
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
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                    child: Icon(
                      Icons.access_time_filled_rounded,
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
                          'Waktu Notifikasi',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: SettingsConstants.fontSizeMedium,
                            color: isDark
                                ? AppColors.onSurfaceDark
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Pilih waktu untuk notifikasi rekap',
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
                  Text(
                    TimeOfDay(hour: hour, minute: minute).format(context),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
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
}
