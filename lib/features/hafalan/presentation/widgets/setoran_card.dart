import 'dart:ui' as ui;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/setoran_compare_result.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/setoran_jawab_buttons.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';

enum SetoranRecordState { idle, recording, comparing }

/// Kartu ayat untuk mode setoran hafalan.
class SetoranCard extends StatelessWidget {
  const SetoranCard({
    required this.ayat,
    required this.currentIndex,
    required this.totalAyat,
    required this.showTerjemahan,
    required this.onToggleTerjemahan,
    required this.recordState,
    required this.onStartRecord,
    required this.onStopRecord,
    required this.onHafal,
    required this.onBelumHafal,
    this.compareResult,
    super.key,
  });

  final Ayat ayat;
  final int currentIndex;
  final int totalAyat;
  final bool showTerjemahan;
  final VoidCallback onToggleTerjemahan;

  /// State perekaman untuk ayat ini.
  final SetoranRecordState recordState;

  /// Hasil AI comparison (null sebelum selesai).
  final SetoranCompareResult? compareResult;

  final VoidCallback onStartRecord;
  final VoidCallback onStopRecord;
  final VoidCallback onHafal;
  final VoidCallback onBelumHafal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return Column(
      children: [
        // Progress bar atas — gold
        LinearProgressIndicator(
          value: (currentIndex + 1) / totalAyat,
          minHeight: 3,
          backgroundColor: isDark
              ? AppColors.outlineDark
              : AppColors.outlineVariant,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
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
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusFull,
                        ),
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
                      borderRadius: BorderRadius.circular(AppDimens.radiusXL),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(
                            alpha: isDark ? 0.04 : 0.06,
                          ),
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
                        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
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

        // Recording / Answer area
        _buildBottomArea(theme: theme, isDark: isDark),
      ],
    );
  }

  Widget _buildBottomArea({
    required ThemeData theme,
    required bool isDark,
  }) {
    if (compareResult != null) {
      return _buildResultArea(theme: theme, isDark: isDark);
    }

    switch (recordState) {
      case SetoranRecordState.idle:
        return _buildIdleArea(isDark: isDark);
      case SetoranRecordState.recording:
        return _buildRecordingArea(isDark: isDark);
      case SetoranRecordState.comparing:
        return _buildComparingArea(isDark: isDark);
    }
  }

  Widget _buildIdleArea({required bool isDark}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceLG,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onStartRecord,
              icon: const Icon(Icons.mic_rounded, size: 20),
              label: const Text('Rekam Bacaan'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          SetoranJawabButtons(
            onHafal: onHafal,
            onBelumHafal: onBelumHafal,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingArea({required bool isDark}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceLG,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fiber_manual_record_rounded, color: Colors.red, size: 16),
              SizedBox(width: 8),
              Text(
                'Merekam...',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onStopRecord,
              icon: const Icon(Icons.stop_rounded, size: 20),
              label: const Text('Berhenti Rekam'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparingArea({required bool isDark}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceLG,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          SizedBox(height: AppDimens.spaceSM),
          Text(
            'Membandingkan bacaan...',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildResultArea({
    required ThemeData theme,
    required bool isDark,
  }) {
    final result = compareResult!;
    final scoreColor = result.passed ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
        AppDimens.pagePadding,
        AppDimens.spaceLG,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${result.score.toStringAsFixed(0)}%',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: scoreColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Icon(
                result.passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: scoreColor,
                size: 28,
              ),
            ],
          ),
          if (!result.passed && result.wordErrors.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceSM),
            Text(
              'Kata yang tidak cocok:',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.onSurfaceDarkVariant : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimens.spaceXS),
            ...result.wordErrors.take(3).map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                '${e.position + 1}. Diharapkan: "${e.expected}" → Terbaca: "${e.actual}"',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.onSurfaceDarkVariant : AppColors.textTertiary,
                ),
              ),
            )),
          ],
          const SizedBox(height: AppDimens.spaceMD),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: result.passed ? onHafal : onStartRecord,
                  icon: Icon(
                    result.passed ? Icons.check_rounded : Icons.replay_rounded,
                    size: 18,
                  ),
                  label: Text(result.passed ? 'Lanjut' : 'Rekam Ulang'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.spaceSM,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onHafal,
                  icon: const Icon(Icons.skip_next_rounded, size: 18),
                  label: const Text('Lewati'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.spaceSM,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
