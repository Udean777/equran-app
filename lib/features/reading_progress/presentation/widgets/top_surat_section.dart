import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:flutter/material.dart';

/// Top 5 surat paling sering dibaca.
class TopSuratSection extends StatelessWidget {
  const TopSuratSection({
    required this.topSurat,
    super.key,
  });

  final List<SuratReadCount> topSurat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (topSurat.isEmpty) return const SizedBox.shrink();

    final maxAyat = topSurat.first.jumlahAyatDibaca;

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
                Icons.star_rounded,
                size: AppDimens.iconSM + 2,
                color: AppColors.secondary,
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                'Surat Paling Sering Dibaca',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
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
            ),
          ),
        ],
      ),
    );
  }
}

class _TopSuratRow extends StatelessWidget {
  const _TopSuratRow({
    required this.rank,
    required this.surat,
    required this.maxAyat,
  });

  final int rank;
  final SuratReadCount surat;
  final int maxAyat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = maxAyat > 0 ? surat.jumlahAyatDibaca / maxAyat : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXS),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _rankColor(rank).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _rankColor(rank),
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${surat.jumlahAyatDibaca} ayat',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
                minHeight: 6,
                backgroundColor: AppColors.outline.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // gold
      case 2:
        return const Color(0xFFC0C0C0); // silver
      case 3:
        return const Color(0xFFCD7F32); // bronze
      default:
        return AppColors.primary;
    }
  }
}
