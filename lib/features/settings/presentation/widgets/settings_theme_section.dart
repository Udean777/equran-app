import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/providers.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_constants.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_strings.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsThemeSection extends ConsumerWidget {
  const SettingsThemeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final themeState = ref.watch(themeViewModelProvider);

    if (themeState is ThemeError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSettingsToast(context, themeState.message, isSuccess: false);
      });
    }

    final selected = themeState.isDark ? 'dark' : 'light';

    return Padding(
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  Icons.palette_outlined,
                  size: AppDimens.iconSM,
                  color: isDark ? AppColors.primaryLighter : AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDimens.spaceMD),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SettingsStrings.themeLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: SettingsConstants.fontSizeMedium,
                      color: isDark
                          ? AppColors.onSurfaceDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _themeLabel(selected),
                    style: TextStyle(
                      fontSize: SettingsConstants.fontSizeSecondary,
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
                label: SettingsStrings.themeLight,
                icon: Icons.light_mode_rounded,
                isSelected: selected == 'light',
                isDark: isDark,
                onTap: () {
                  if (selected != 'light') {
                    unawaited(
                      ref.read(themeViewModelProvider.notifier).cycle(),
                    );
                    showSettingsToast(
                      context,
                      SettingsStrings.themeLightActive,
                    );
                  }
                },
              ),
              const SizedBox(width: AppDimens.spaceSM),
              _ThemeChip(
                value: 'dark',
                label: SettingsStrings.themeDark,
                icon: Icons.dark_mode_rounded,
                isSelected: selected == 'dark',
                isDark: isDark,
                onTap: () {
                  if (selected != 'dark') {
                    unawaited(
                      ref.read(themeViewModelProvider.notifier).cycle(),
                    );
                    showSettingsToast(
                      context,
                      SettingsStrings.themeDarkActive,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _themeLabel(String value) => switch (value) {
    'dark' => SettingsStrings.themeDarkActive,
    _ => SettingsStrings.themeLightActive,
  };
}

/// Chip animated untuk memilih mode tema (Terang / Gelap).
///
/// Menampilkan ikon dan label mode, serta animasi warna berdasarkan
/// [isSelected] menggunakan [AnimatedContainer].
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
          duration: const Duration(
            milliseconds: SettingsConstants.themeToggleAnimationMs,
          ),
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
                  fontSize: SettingsConstants.fontSizeTertiary,
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
