import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/shalat_notif_cubit.dart';
import 'package:equran_app/features/settings/presentation/widgets/notif_toggle_tile.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section notifikasi waktu shalat — toggle per waktu + menit sebelum.
class SettingsShalatNotifSection extends StatelessWidget {
  const SettingsShalatNotifSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<ShalatNotifCubit, ShalatNotifPrefs>(
      builder: (context, prefs) {
        final cubit = context.read<ShalatNotifCubit>();
        return Column(
          children: [
            NotifToggleTile(
              label: 'Subuh',
              icon: Icons.wb_twilight_rounded,
              value: prefs.subuh,
              onChanged: (_) {
                unawaited(cubit.toggleSubuh());
                showSettingsToast(
                  context,
                  prefs.subuh
                      ? 'Notifikasi Subuh dimatikan'
                      : 'Notifikasi Subuh aktif',
                  isSuccess: !prefs.subuh,
                );
              },
            ),
            _InternalDivider(isDark: isDark),
            NotifToggleTile(
              label: 'Dzuhur',
              icon: Icons.wb_sunny_rounded,
              value: prefs.dzuhur,
              onChanged: (_) {
                unawaited(cubit.toggleDzuhur());
                showSettingsToast(
                  context,
                  prefs.dzuhur
                      ? 'Notifikasi Dzuhur dimatikan'
                      : 'Notifikasi Dzuhur aktif',
                  isSuccess: !prefs.dzuhur,
                );
              },
            ),
            _InternalDivider(isDark: isDark),
            NotifToggleTile(
              label: 'Ashar',
              icon: Icons.wb_sunny_outlined,
              value: prefs.ashar,
              onChanged: (_) {
                unawaited(cubit.toggleAshar());
                showSettingsToast(
                  context,
                  prefs.ashar
                      ? 'Notifikasi Ashar dimatikan'
                      : 'Notifikasi Ashar aktif',
                  isSuccess: !prefs.ashar,
                );
              },
            ),
            _InternalDivider(isDark: isDark),
            NotifToggleTile(
              label: 'Maghrib',
              icon: Icons.nights_stay_outlined,
              value: prefs.maghrib,
              onChanged: (_) {
                unawaited(cubit.toggleMaghrib());
                showSettingsToast(
                  context,
                  prefs.maghrib
                      ? 'Notifikasi Maghrib dimatikan'
                      : 'Notifikasi Maghrib aktif',
                  isSuccess: !prefs.maghrib,
                );
              },
            ),
            _InternalDivider(isDark: isDark),
            NotifToggleTile(
              label: 'Isya',
              icon: Icons.dark_mode_rounded,
              value: prefs.isya,
              onChanged: (_) {
                unawaited(cubit.toggleIsya());
                showSettingsToast(
                  context,
                  prefs.isya
                      ? 'Notifikasi Isya dimatikan'
                      : 'Notifikasi Isya aktif',
                  isSuccess: !prefs.isya,
                );
              },
            ),
            _InternalDivider(isDark: isDark),
            // Menit sebelum
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.cardPadding,
                AppDimens.spaceSM,
                AppDimens.cardPadding,
                AppDimens.spaceSM,
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
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                    child: Icon(
                      Icons.timer_outlined,
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
                          'Menit Sebelum Adzan',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: isDark
                                ? AppColors.onSurfaceDark
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${prefs.menitSebelum} menit sebelum',
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StepButton(
                        icon: Icons.remove_rounded,
                        onTap: () {
                          final newVal = (prefs.menitSebelum - 5).clamp(0, 60);
                          unawaited(cubit.setMenitSebelum(newVal));
                          if (newVal < prefs.menitSebelum) {
                            showSettingsToast(
                              context,
                              newVal == 0
                                  ? 'Notifikasi tepat saat adzan'
                                  : 'Notifikasi $newVal menit sebelum adzan',
                            );
                          }
                        },
                        isDark: isDark,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceSM,
                        ),
                        child: Text(
                          '${prefs.menitSebelum}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: isDark
                                ? AppColors.primaryLighter
                                : AppColors.primary,
                          ),
                        ),
                      ),
                      _StepButton(
                        icon: Icons.add_rounded,
                        onTap: () {
                          final newVal = (prefs.menitSebelum + 5).clamp(0, 60);
                          unawaited(cubit.setMenitSebelum(newVal));
                          if (newVal > prefs.menitSebelum) {
                            showSettingsToast(
                              context,
                              'Notifikasi $newVal menit sebelum adzan',
                            );
                          }
                        },
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InternalDivider extends StatelessWidget {
  const _InternalDivider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.cardPadding),
      color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isDark ? AppColors.primaryDark : AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(AppDimens.radiusSM),
          border: Border.all(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDark ? AppColors.primaryLighter : AppColors.primary,
        ),
      ),
    );
  }
}
