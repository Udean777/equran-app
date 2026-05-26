import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:flutter/material.dart';

class HafalanStatsCard extends StatelessWidget {
  const HafalanStatsCard({required this.stats, super.key});

  final HafalanStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final persen = (stats.persentaseQuran * 100).toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceMD,
        AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.auto_stories_rounded,
                  color: AppColors.onPrimary,
                  size: AppDimens.iconLG,
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress Hafalan',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                      Text(
                        '$persen% Al-Quran',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Total ayat hafal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${stats.totalAyatHafal}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ayat hafal',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Progress bar keseluruhan
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              child: LinearProgressIndicator(
                value: stats.persentaseQuran,
                minHeight: 8,
                backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.onPrimary,
                ),
              ),
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Statistik bawah: 3 kolom
            Row(
              children: [
                _StatChip(
                  icon: Icons.check_circle_rounded,
                  label: 'Selesai',
                  value: '${stats.totalSuratSelesai} surat',
                  color: AppColors.onPrimary,
                ),
                const SizedBox(width: AppDimens.spaceSM),
                _StatChip(
                  icon: Icons.edit_note_rounded,
                  label: 'Sedang',
                  value: '${stats.suratSedangDihafal} surat',
                  color: AppColors.onPrimary,
                ),
                const SizedBox(width: AppDimens.spaceSM),
                _StatChip(
                  icon: Icons.refresh_rounded,
                  label: 'Murajaah',
                  value: '${stats.suratPerluMurajaah} surat',
                  color: stats.suratPerluMurajaah > 0
                      ? AppColors.secondary
                      : AppColors.onPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceSM,
          vertical: AppDimens.spaceXS,
        ),
        decoration: BoxDecoration(
          color: AppColors.onPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimens.radiusSM),
        ),
        child: Row(
          children: [
            Icon(icon, size: AppDimens.iconSM, color: color),
            const SizedBox(width: AppDimens.spaceXS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.7),
                      fontSize: 9,
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
