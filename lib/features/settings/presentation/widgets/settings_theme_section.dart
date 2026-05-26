import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section tema tampilan — segmented button light/dark/sepia.
class SettingsThemeSection extends StatelessWidget {
  const SettingsThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
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
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary;
                  }
                  return null;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.onPrimary;
                  }
                  return AppColors.primary;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
