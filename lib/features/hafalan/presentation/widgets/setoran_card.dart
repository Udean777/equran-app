import 'dart:ui' as ui;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/setoran_jawab_buttons.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';

/// Kartu ayat untuk mode setoran hafalan.
class SetoranCard extends StatelessWidget {
  const SetoranCard({
    required this.ayat,
    required this.currentIndex,
    required this.totalAyat,
    required this.showTerjemahan,
    required this.onToggleTerjemahan,
    required this.onHafal,
    required this.onBelumHafal,
    super.key,
  });

  final Ayat ayat;
  final int currentIndex;
  final int totalAyat;
  final bool showTerjemahan;
  final VoidCallback onToggleTerjemahan;
  final VoidCallback onHafal;
  final VoidCallback onBelumHafal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;

    return Column(
      children: [
        // Progress bar atas — gold
        LinearProgressIndicator(
          value: (currentIndex + 1) / totalAyat,
          minHeight: 3,
          backgroundColor:
              isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.gold),
        ),

        Expanded(
          child: ColoredBox(
            color: bgColor,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.spaceLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Label ayat
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceMD,
                        vertical: AppDimens.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDarkVariant
                            : AppColors.surfaceVariant,
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusFull),
                        border: Border.all(color: borderColor),
                      ),
                      child: Text(
                        'Ayat ${ayat.nomorAyat}  ·  ${currentIndex + 1} / $totalAyat',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.onSurfaceDarkVariant
                              : AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  // Card teks Arab
                  Container(
                    padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusXL),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary
                              .withValues(alpha: isDark ? 0.04 : 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Gold ornamen atas
                        Container(
                          width: 40,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.goldDark,
                                AppColors.gold,
                                AppColors.goldDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusFull,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceLG),

                        // Teks Arab
                        Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Text(
                            ayat.teksArab,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 30,
                              height: 2.2,
                              color: isDark
                                  ? AppColors.primaryLighter
                                  : AppColors.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppDimens.spaceLG),
                        Container(
                          width: 40,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.goldDark,
                                AppColors.gold,
                                AppColors.goldDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusFull,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceLG),

                  // Terjemahan toggle
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    crossFadeState: showTerjemahan
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Center(
                      child: OutlinedButton.icon(
                        onPressed: onToggleTerjemahan,
                        icon: Icon(
                          Icons.visibility_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.onSurfaceDarkVariant
                              : AppColors.textSecondary,
                        ),
                        label: Text(
                          'Tampilkan Terjemahan',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.onSurfaceDarkVariant
                                : AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusFull,
                            ),
                          ),
                        ),
                      ),
                    ),
                    secondChild: Container(
                      padding: const EdgeInsets.all(AppDimens.cardPadding),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDarkVariant
                            : AppColors.surfaceVariant,
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusLG),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            ayat.teksLatin,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.onSurfaceDarkVariant
                                  : AppColors.textTertiary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceSM),
                          Text(
                            ayat.teksIndonesia,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.onSurfaceDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceSM),
                          Center(
                            child: TextButton.icon(
                              onPressed: onToggleTerjemahan,
                              icon: Icon(
                                Icons.visibility_off_rounded,
                                size: 14,
                                color: isDark
                                    ? AppColors.onSurfaceDarkVariant
                                    : AppColors.textTertiary,
                              ),
                              label: Text(
                                'Sembunyikan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.onSurfaceDarkVariant
                                      : AppColors.textTertiary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Tombol jawab
        SetoranJawabButtons(
          onHafal: onHafal,
          onBelumHafal: onBelumHafal,
          isDark: isDark,
        ),
      ],
    );
  }
}
