import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_constants.dart';
import 'package:equran_app/features/settings/presentation/constants/settings_strings.dart';
import 'package:equran_app/features/settings/presentation/widgets/settings_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bottom sheet untuk mengatur preferensi teks Al-Quran.
///
/// Memungkinkan user untuk:
/// - Memilih jenis font Arab (Amiri atau KFGQPC Uthmani)
/// - Mengatur ukuran font Arab (range: 18–40px)
/// - Mengatur ukuran font terjemahan (range: 12–22px)
///
/// Menggunakan [QuranFontCubit] untuk manage state font.
/// Menampilkan preview teks Arab dan terjemahan secara real-time.
class FontSettingsSheet extends StatelessWidget {
  const FontSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranFontCubit, QuranFontState>(
      builder: (context, state) {
        if (state.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSettingsToast(context, state.errorMessage!, isSuccess: false);
          });
        }

        final cubit = context.read<QuranFontCubit>();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceMD,
              AppDimens.spaceSM,
              AppDimens.spaceMD,
              AppDimens.spaceLG,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                const Center(child: BottomSheetHandle()),
                const SizedBox(height: AppDimens.spaceMD),

                // Judul
                Text(
                  SettingsStrings.fontSettingsTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceLG),

                // ── Pilihan Font Arab ──────────────────────────────────────
                Text(
                  SettingsStrings.fontArabicLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceSM),
                Row(
                  children: [
                    _FontChip(
                      label: SettingsStrings.fontAmiri,
                      selected: state.arabicFontFamily == kFontAmiri,
                      onTap: () {
                        unawaited(cubit.setArabicFontFamily(kFontAmiri));
                        showSettingsToast(
                          context,
                          SettingsStrings.fontAmiriActive,
                        );
                      },
                    ),
                    const SizedBox(width: AppDimens.spaceSM),
                    _FontChip(
                      label: SettingsStrings.fontUthmani,
                      selected: state.arabicFontFamily == kFontKFGQPC,
                      onTap: () {
                        unawaited(cubit.setArabicFontFamily(kFontKFGQPC));
                        showSettingsToast(
                          context,
                          SettingsStrings.fontUthmaniActive,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceLG),

                // ── Preview Teks Arab ──────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimens.spaceMD),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Preview Arab
                      Text(
                        SettingsStrings.previewArabic,
                        textAlign: TextAlign.right,
                        style: AppTypography.arabicDynamic(state).copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceSM),
                      // Preview terjemahan
                      Text(
                        SettingsStrings.previewTranslation,
                        style: AppTypography.translationDynamic(state).copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.spaceLG),

                // ── Slider Ukuran Font Arab ────────────────────────────────
                _FontSizeSlider(
                  label: SettingsStrings.fontArabicSizeLabel,
                  value: state.arabicFontSize,
                  min: SettingsConstants.minArabicFontSize,
                  max: SettingsConstants.maxArabicFontSize,
                  onChanged: cubit.setArabicFontSize,
                  onChangeEnd: (v) => showSettingsToast(
                    context,
                    SettingsStrings.fontArabicSizeValue(v.round()),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMD),

                // ── Slider Ukuran Font Terjemahan ──────────────────────────
                _FontSizeSlider(
                  label: SettingsStrings.fontTranslationSizeLabel,
                  value: state.translationFontSize,
                  min: SettingsConstants.minTranslationFontSize,
                  max: SettingsConstants.maxTranslationFontSize,
                  onChanged: cubit.setTranslationFontSize,
                  onChangeEnd: (v) => showSettingsToast(
                    context,
                    SettingsStrings.fontTranslationSizeValue(v.round()),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMD),

                // ── Reset ──────────────────────────────────────────────────
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      unawaited(
                        cubit.setArabicFontSize(
                          SettingsConstants.defaultArabicFontSize,
                        ),
                      );
                      unawaited(
                        cubit.setTranslationFontSize(
                          SettingsConstants.defaultTranslationFontSize,
                        ),
                      );
                      unawaited(cubit.setArabicFontFamily(kFontAmiri));
                      showSettingsToast(
                        context,
                        SettingsStrings.fontResetSuccess,
                      );
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text(SettingsStrings.fontResetButton),
                    style: TextButton.styleFrom(
                      foregroundColor: context.isDark
                          ? AppColors.onSurfaceDarkVariant
                          : AppColors.textSecondary,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Private widgets
// ---------------------------------------------------------------------------

/// Chip selector untuk memilih jenis font Arab.
/// Menampilkan label font dan merespons tap untuk mengubah [QuranFontCubit].
class _FontChip extends StatelessWidget {
  const _FontChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: SettingsConstants.themeToggleAnimationMs,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD,
          vertical: AppDimens.spaceSM,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Slider untuk mengatur ukuran font dengan label dan nilai saat ini.
/// Memanggil [onChanged] saat nilai berubah dan [onChangeEnd] saat selesai geser.
class _FontSizeSlider extends StatelessWidget {
  const _FontSizeSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.onChangeEnd,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${value.round()}px',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: context.isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          activeColor: AppColors.primary,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }
}
