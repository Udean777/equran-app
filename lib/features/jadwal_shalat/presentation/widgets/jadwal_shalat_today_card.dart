import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';
import 'package:flutter/material.dart';

class JadwalShalatTodayCard extends StatelessWidget {
  const JadwalShalatTodayCard({
    required this.entry,
    super.key,
  });

  final JadwalShalatEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.primaryDark, AppColors.primary]
                : [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Ornamen circle
            Positioned(
              right: -16,
              top: -16,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onPrimary.withValues(alpha: 0.05),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusSM,
                          ),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Icon(
                          Icons.today_rounded,
                          size: 16,
                          color: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceSM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hari Ini',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.onPrimary.withValues(
                                  alpha: 0.7,
                                ),
                                letterSpacing: 0.5,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              '${entry.hari}, ${entry.tanggalLengkap}',
                              style: AppTypography.serifHeadingSmall.copyWith(
                                color: AppColors.onPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // Gold divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gold.withValues(alpha: 0),
                          AppColors.gold.withValues(alpha: 0.5),
                          AppColors.gold.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // Shalat grid
                  _ShalatGrid(entry: entry),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShalatGrid extends StatelessWidget {
  const _ShalatGrid({required this.entry});

  final JadwalShalatEntry entry;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Imsak', entry.imsak, Icons.nightlight_round),
      ('Subuh', entry.subuh, Icons.wb_twilight_outlined),
      ('Terbit', entry.terbit, Icons.wb_sunny_outlined),
      ('Dhuha', entry.dhuha, Icons.sunny_snowing),
      ('Dzuhur', entry.dzuhur, Icons.light_mode_outlined),
      ('Ashar', entry.ashar, Icons.wb_cloudy_outlined),
      ('Maghrib', entry.maghrib, Icons.nights_stay_outlined),
      ('Isya', entry.isya, Icons.bedtime_outlined),
    ];

    return Wrap(
      spacing: AppDimens.spaceSM,
      runSpacing: AppDimens.spaceSM,
      children: items
          .map(
            (item) => _ShalatItem(
              label: item.$1,
              time: item.$2,
              icon: item.$3,
            ),
          )
          .toList(),
    );
  }
}

class _ShalatItem extends StatelessWidget {
  const _ShalatItem({
    required this.label,
    required this.time,
    required this.icon,
  });

  final String label;
  final String time;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          (MediaQuery.sizeOf(context).width -
              AppDimens.pagePadding * 2 -
              AppDimens.cardPaddingLG * 2 -
              AppDimens.spaceSM * 3) /
          4,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXS,
        vertical: AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(
          color: AppColors.onPrimary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 14, color: AppColors.gold),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontSize: 9,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
