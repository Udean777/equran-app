import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:equran_app/features/imsakiyah/presentation/cubit/imsak_alarm_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImsakAlarmToggleCard extends StatelessWidget {
  const ImsakAlarmToggleCard({
    required this.todayEntry,
    super.key,
  });

  final ImsakiyahEntry todayEntry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImsakAlarmCubit, ImsakAlarmState>(
      builder: (context, state) {
        final prefs = switch (state) {
          ImsakAlarmLoaded(:final prefs) => prefs,
          _ => const ImsakAlarmPrefs(),
        };
        return _AlarmCard(prefs: prefs, todayEntry: todayEntry);
      },
    );
  }
}

class _AlarmCard extends StatelessWidget {
  const _AlarmCard({
    required this.prefs,
    required this.todayEntry,
  });

  final ImsakAlarmPrefs prefs;
  final ImsakiyahEntry todayEntry;

  static const _menitOptions = [30, 45, 60, 90];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryDark
                        : AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                  ),
                  child: Icon(
                    Icons.alarm_rounded,
                    size: 16,
                    color: isDark
                        ? AppColors.primaryLighter
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Text(
                  'Alarm Sahur & Imsak',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.onSurfaceDark
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Gold divider
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.gold.withValues(alpha: 0),
                    AppColors.gold.withValues(alpha: 0.4),
                    AppColors.gold.withValues(alpha: 0),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Toggle imsak
            _AlarmToggleRow(
              icon: Icons.nightlight_round,
              label: 'Alarm Imsak',
              subtitle: 'Berbunyi tepat pukul ${todayEntry.imsak}',
              value: prefs.imsakEnabled,
              isDark: isDark,
              onChanged: (_) => context.read<ImsakAlarmCubit>().toggleImsak(
                entry: todayEntry,
              ),
            ),

            const SizedBox(height: AppDimens.spaceSM),

            // Toggle sahur
            _AlarmToggleRow(
              icon: Icons.restaurant_rounded,
              label: 'Alarm Sahur',
              subtitle:
                  '${prefs.menitSebelumImsak} menit sebelum imsak (${_sahurTime(todayEntry.imsak, prefs.menitSebelumImsak)})',
              value: prefs.sahurEnabled,
              isDark: isDark,
              onChanged: (_) => context.read<ImsakAlarmCubit>().toggleSahur(
                entry: todayEntry,
              ),
            ),

            // Dropdown menit
            if (prefs.sahurEnabled) ...[
              const SizedBox(height: AppDimens.spaceMD),
              Row(
                children: [
                  Text(
                    'Berapa menit sebelum imsak:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.onSurfaceDarkVariant
                          : AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSM),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceSM,
                      vertical: AppDimens.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                    ),
                    child: DropdownButton<int>(
                      value: prefs.menitSebelumImsak,
                      isDense: true,
                      underline: const SizedBox.shrink(),
                      dropdownColor: isDark
                          ? AppColors.surfaceDark
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                      items: _menitOptions
                          .map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text(
                                '$m menit',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.primaryLighter
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        unawaited(
                          context.read<ImsakAlarmCubit>().setMenitSebelum(
                            val,
                            entry: todayEntry,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _sahurTime(String imsak, int menit) {
    try {
      final parts = imsak.trim().split(':');
      if (parts.length != 2) return '--:--';
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final total = h * 60 + m - menit;
      final hh = (total ~/ 60) % 24;
      final mm = total % 60;
      return '${hh.toString().padLeft(2, '0')}:${mm.abs().toString().padLeft(2, '0')}';
    } on Object catch (_) {
      return '--:--';
    }
  }
}

class _AlarmToggleRow extends StatelessWidget {
  const _AlarmToggleRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: value
                ? (isDark ? AppColors.primaryDark : AppColors.primaryContainer)
                : (isDark
                      ? AppColors.surfaceDarkVariant
                      : AppColors.surfaceVariant),
            borderRadius: BorderRadius.circular(AppDimens.radiusSM),
          ),
          child: Icon(
            icon,
            size: 14,
            color: value
                ? (isDark ? AppColors.primaryLighter : AppColors.primary)
                : (isDark
                      ? AppColors.onSurfaceDarkVariant
                      : AppColors.textTertiary),
          ),
        ),
        const SizedBox(width: AppDimens.spaceSM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.onSurfaceDark
                      : AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.onSurfaceDarkVariant
                      : AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: isDark
              ? AppColors.primaryLighter
              : AppColors.primary,
          activeTrackColor: isDark
              ? AppColors.primaryDark
              : AppColors.primaryContainer,
          inactiveThumbColor: isDark
              ? AppColors.onSurfaceDarkVariant
              : AppColors.textTertiary,
          inactiveTrackColor: isDark
              ? AppColors.outlineDark
              : AppColors.outlineVariant,
        ),
      ],
    );
  }
}
