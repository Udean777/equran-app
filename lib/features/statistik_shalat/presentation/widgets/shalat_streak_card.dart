import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:flutter/material.dart';

/// Card header yang menampilkan streak dan progress hari ini.
class ShalatStreakCard extends StatelessWidget {
  const ShalatStreakCard({
    required this.streak,
    required this.today,
    super.key,
  });

  final int streak;
  final ShalatDayStats today;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final jumlahShalat = today.jumlahShalat;
    final jumlahTepatWaktu = today.jumlahTepatWaktu;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceMD,
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
              right: -24,
              bottom: -24,
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
                children: [
                  Row(
                    children: [
                      // Progress circle
                      _ProgressCircle(
                        jumlahShalat: jumlahShalat,
                        jumlahTepatWaktu: jumlahTepatWaktu,
                      ),
                      const SizedBox(width: AppDimens.spaceMD),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shalat Hari Ini',
                              style: TextStyle(
                                color: AppColors.onPrimary
                                    .withValues(alpha: 0.7),
                                fontSize: 11,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceXS),
                            Text(
                              '$jumlahShalat/5 waktu',
                              style: AppTypography.serifHeadingSmall.copyWith(
                                color: AppColors.onPrimary,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceXS),
                            Text(
                              '$jumlahTepatWaktu tepat waktu',
                              style: TextStyle(
                                color: AppColors.onPrimary
                                    .withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (streak > 0) _StreakBadge(streak: streak),
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
                          AppColors.gold.withValues(alpha: 0.4),
                          AppColors.gold.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // Progress bar 5 waktu
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusFull),
                    child: LinearProgressIndicator(
                      value: jumlahShalat / 5,
                      minHeight: 6,
                      backgroundColor:
                          AppColors.onPrimary.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.gold,
                      ),
                    ),
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

class _ProgressCircle extends StatelessWidget {
  const _ProgressCircle({
    required this.jumlahShalat,
    required this.jumlahTepatWaktu,
  });

  final int jumlahShalat;
  final int jumlahTepatWaktu;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: jumlahShalat / 5,
            strokeWidth: 5,
            backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
          Text(
            '$jumlahShalat/5',
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.gold,
            size: 20,
          ),
          const SizedBox(height: 2),
          Text(
            '$streak',
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            'hari',
            style: TextStyle(
              color: AppColors.onPrimary.withValues(alpha: 0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
