import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Progress bar 30 juz Al-Quran.
class JuzProgressSection extends StatelessWidget {
  const JuzProgressSection({
    required this.progressPerJuz, super.key,
  });

  /// Map juz → persentase (0.0–1.0).
  final Map<int, double> progressPerJuz;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceSM,
      ),
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.library_books_rounded,
                size: AppDimens.iconSM + 2,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                'Progress Per Juz',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${progressPerJuz.values.where((p) => p > 0).length}/30 juz',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),
          ...List.generate(30, (i) {
            final juz = i + 1;
            final progress = progressPerJuz[juz] ?? 0.0;
            return _JuzRow(juz: juz, progress: progress);
          }),
        ],
      ),
    );
  }
}

class _JuzRow extends StatelessWidget {
  const _JuzRow({required this.juz, required this.progress});

  final int juz;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final persen = (progress * 100).toStringAsFixed(0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          // Nomor juz
          SizedBox(
            width: 36,
            child: Text(
              'Juz $juz',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: progress > 0 ? FontWeight.w600 : FontWeight.normal,
                color: progress > 0
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          // Progress bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.outline.withValues(alpha: 0.4),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _colorForProgress(progress),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          // Persentase
          SizedBox(
            width: 32,
            child: Text(
              progress > 0 ? '$persen%' : '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _colorForProgress(progress),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForProgress(double progress) {
    if (progress >= 1.0) return AppColors.success;
    if (progress >= 0.5) return AppColors.primary;
    if (progress > 0) return AppColors.primary.withValues(alpha: 0.7);
    return AppColors.outline;
  }
}
