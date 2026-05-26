import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:flutter/material.dart';

class ImsakiyahTodayCard extends StatelessWidget {
  const ImsakiyahTodayCard({
    required this.entry,
    required this.tanggal,
    super.key,
  });

  final ImsakiyahEntry entry;
  final int tanggal;

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
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusSM),
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
                      Text(
                        'Hari Ini — Tanggal $tanggal',
                        style: AppTypography.serifHeadingSmall.copyWith(
                          color: AppColors.onPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

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

                  _ImsakGrid(entry: entry),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImsakGrid extends StatelessWidget {
  const _ImsakGrid({required this.entry});

  final ImsakiyahEntry entry;

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
            (item) => SizedBox(
              width: (MediaQuery.sizeOf(context).width -
                      AppDimens.pagePadding * 2 -
                      AppDimens.cardPaddingLG * 2 -
                      AppDimens.spaceSM * 3) /
                  4,
              child: Container(
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
                    Icon(item.$3, size: 14, color: AppColors.gold),
                    const SizedBox(height: 4),
                    Text(
                      item.$1,
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.$2,
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
