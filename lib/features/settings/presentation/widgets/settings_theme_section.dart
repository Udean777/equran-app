import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/cubit/theme_cubit.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section tema tampilan — segmented button light/dark.
class SettingsThemeSection extends StatelessWidget {
  const SettingsThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final selected = themeState.isDark ? 'dark' : 'light';

        return Padding(
          padding: const EdgeInsets.all(AppDimens.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                      Icons.palette_outlined,
                      size: AppDimens.iconSM,
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceMD),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tema Tampilan',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.onSurfaceDark
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _themeLabel(selected),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.onSurfaceDarkVariant
                              : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceMD),
              Row(
                children: [
                  _ThemeChip(
                    value: 'light',
                    label: 'Terang',
                    icon: Icons.light_mode_rounded,
                    isSelected: selected == 'light',
                    isDark: isDark,
                    onTap: () {
                      if (selected != 'light') {
                        unawaited(context.read<ThemeCubit>().cycle());
                        showSettingsToast(context, 'Mode Terang aktif');
                      }
                    },
                  ),
                  const SizedBox(width: AppDimens.spaceSM),
                  _ThemeChip(
                    value: 'dark',
                    label: 'Gelap',
                    icon: Icons.dark_mode_rounded,
                    isSelected: selected == 'dark',
                    isDark: isDark,
                    onTap: () {
                      if (selected != 'dark') {
                        unawaited(context.read<ThemeCubit>().cycle());
                        showSettingsToast(context, 'Mode Gelap aktif');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _themeLabel(String value) => switch (value) {
    'dark' => 'Mode Gelap aktif',
    _ => 'Mode Terang aktif',
  };
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.value,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String value;
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.spaceSM,
            horizontal: AppDimens.spaceXS,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.primaryLight : AppColors.primary)
                : (isDark
                      ? AppColors.surfaceDarkVariant
                      : AppColors.surfaceVariant),
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark ? AppColors.outlineDark : AppColors.outlineVariant),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? AppColors.onPrimary
                    : (isDark
                          ? AppColors.onSurfaceDarkVariant
                          : AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? AppColors.onPrimary
                      : (isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
