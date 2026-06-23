import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/shalat_notif_cubit.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_constants.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_strings.dart';
import 'package:equran_app/features/settings/presentation/widgets/notif_toggle_tile.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section pengaturan notifikasi waktu shalat.
///
/// Menampilkan toggle per waktu shalat (Subuh, Dzuhur, Ashar, Maghrib, Isya)
/// dan pengaturan menit sebelum adzan (step 5 menit, range 0–60 menit).
/// Menggunakan [ShalatNotifCubit] untuk manage state notifikasi.
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
              label: SettingsStrings.shalatNotifSubuh,
              icon: Icons.wb_twilight_rounded,
              value: prefs.subuh,
              onChanged: (_) {
                unawaited(cubit.toggleSubuh());
                showSettingsToast(
                  context,
                  prefs.subuh
                      ? SettingsStrings.shalatNotifInactive(
                          SettingsStrings.shalatNotifSubuh,
                        )
                      : SettingsStrings.shalatNotifActive(
                          SettingsStrings.shalatNotifSubuh,
                        ),
                  isSuccess: !prefs.subuh,
                );
              },
            ),
            _InternalDivider(isDark: isDark),
            NotifToggleTile(
              label: SettingsStrings.shalatNotifDzuhur,
              icon: Icons.wb_sunny_rounded,
              value: prefs.dzuhur,
              onChanged: (_) {
                unawaited(cubit.toggleDzuhur());
                showSettingsToast(
                  context,
                  prefs.dzuhur
                      ? SettingsStrings.shalatNotifInactive(
                          SettingsStrings.shalatNotifDzuhur,
                        )
                      : SettingsStrings.shalatNotifActive(
                          SettingsStrings.shalatNotifDzuhur,
                        ),
                  isSuccess: !prefs.dzuhur,
                );
              },
            ),
            _InternalDivider(isDark: isDark),
            NotifToggleTile(
              label: SettingsStrings.shalatNotifAshar,
              icon: Icons.wb_sunny_outlined,
              value: prefs.ashar,
              onChanged: (_) {
                unawaited(cubit.toggleAshar());
                showSettingsToast(
                  context,
                  prefs.ashar
                      ? SettingsStrings.shalatNotifInactive(
                          SettingsStrings.shalatNotifAshar,
                        )
                      : SettingsStrings.shalatNotifActive(
                          SettingsStrings.shalatNotifAshar,
                        ),
                  isSuccess: !prefs.ashar,
                );
              },
            ),
            _InternalDivider(isDark: isDark),
            NotifToggleTile(
              label: SettingsStrings.shalatNotifMaghrib,
              icon: Icons.nights_stay_outlined,
              value: prefs.maghrib,
              onChanged: (_) {
                unawaited(cubit.toggleMaghrib());
                showSettingsToast(
                  context,
                  prefs.maghrib
                      ? SettingsStrings.shalatNotifInactive(
                          SettingsStrings.shalatNotifMaghrib,
                        )
                      : SettingsStrings.shalatNotifActive(
                          SettingsStrings.shalatNotifMaghrib,
                        ),
                  isSuccess: !prefs.maghrib,
                );
              },
            ),
            _InternalDivider(isDark: isDark),
            NotifToggleTile(
              label: SettingsStrings.shalatNotifIsya,
              icon: Icons.dark_mode_rounded,
              value: prefs.isya,
              onChanged: (_) {
                unawaited(cubit.toggleIsya());
                showSettingsToast(
                  context,
                  prefs.isya
                      ? SettingsStrings.shalatNotifInactive(
                          SettingsStrings.shalatNotifIsya,
                        )
                      : SettingsStrings.shalatNotifActive(
                          SettingsStrings.shalatNotifIsya,
                        ),
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
                    width: SettingsConstants.iconContainerSize,
                    height: SettingsConstants.iconContainerSize,
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
                          SettingsStrings.shalatNotifMinutesBeforeLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: SettingsConstants.fontSizeMedium,
                            color: isDark
                                ? AppColors.onSurfaceDark
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          SettingsStrings.shalatNotifMinutesSubtitle(
                            prefs.menitSebelum,
                          ),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StepButton(
                        icon: Icons.remove_rounded,
                        onTap: () {
                          final newVal =
                              (prefs.menitSebelum -
                                      SettingsConstants.notifMinutesStep)
                                  .clamp(
                                    SettingsConstants.notifMinutesMin,
                                    SettingsConstants.notifMinutesMax,
                                  );
                          unawaited(cubit.setMenitSebelum(newVal));
                          if (newVal < prefs.menitSebelum) {
                            showSettingsToast(
                              context,
                              newVal == 0
                                  ? SettingsStrings.shalatNotifExactTime
                                  : SettingsStrings.shalatNotifMinutesBefore(
                                      newVal,
                                    ),
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
                          final newVal =
                              (prefs.menitSebelum +
                                      SettingsConstants.notifMinutesStep)
                                  .clamp(
                                    SettingsConstants.notifMinutesMin,
                                    SettingsConstants.notifMinutesMax,
                                  );
                          unawaited(cubit.setMenitSebelum(newVal));
                          if (newVal > prefs.menitSebelum) {
                            showSettingsToast(
                              context,
                              SettingsStrings.shalatNotifMinutesBefore(newVal),
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

/// Divider tipis internal di antara baris toggle notifikasi.
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

/// Tombol inkrement / dekrement untuk mengubah nilai menit sebelum adzan.
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
        width: SettingsConstants.containerSizeSmall,
        height: SettingsConstants.containerSizeSmall,
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
