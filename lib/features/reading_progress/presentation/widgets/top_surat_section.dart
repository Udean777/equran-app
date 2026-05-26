import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:flutter/material.dart';

/// Top 5 surat paling sering dibaca.
class TopSuratSection extends StatelessWidget {
  const TopSuratSection({required this.topSurat, super.key});

  final List<SuratReadCount> topSurat;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    if (topSurat.isEmpty) return const SizedBox.shrink();

    final maxAyat = topSurat.first.jumlahAyatDibaca;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 3,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Text(
                  'Surat Paling Sering Dibaca',
                  style: AppTypography.serifHeadingSmall.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceDark
                        : AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceMD),

            ...topSurat.asMap().entries.map(
              (entry) => _TopSuratRow(
                rank: entry.key + 1,
                surat: entry.value,
                maxAyat: maxAyat,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopSuratRow extends StatelessWidget {
  const _TopSuratRow({
    required this.rank,
    required this.surat,
    required this.maxAyat,
    required this.isDark,
  });

  final int rank;
  final SuratReadCount surat;
  final int maxAyat;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final ratio = maxAyat > 0 ? surat.jumlahAyatDibaca / maxAyat : 0.0;
    final rankColor = _rankColor(rank);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXS),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: rankColor.withValues(alpha: 0.4),
              ),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          // Nama surat
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surat.namaLatin,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark
                        ? AppColors.onSurfaceDark
                        : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${surat.jumlahAyatDibaca} ayat',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          // Bar
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 7,
                backgroundColor: isDark
                    ? AppColors.outlineDark
                    : AppColors.outlineVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  rank == 1
                      ? AppColors.gold
                      : AppColors.primary.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _rankColor(int rank) => switch (rank) {
    1 => AppColors.gold,
    2 => const Color(0xFFC0C0C0),
    3 => const Color(0xFFCD7F32),
    _ => AppColors.primary,
  };
}
