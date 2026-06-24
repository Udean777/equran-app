import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/core/widgets/primary_gradient_card.dart';
import 'package:equran_app/core/widgets/streak_badge.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_constants.dart';
import 'package:equran_app/features/statistik_shalat/presentation/constants/statistik_shalat_strings.dart';
import 'package:flutter/material.dart';

/// Card header yang menampilkan streak dan progress shalat hari ini.
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
    final jumlahShalat = today.jumlahShalat;
    final jumlahTepatWaktu = today.jumlahTepatWaktu;

    return PrimaryGradientCard(
      ornamentRight: -24,
      ornamentTop: null,
      ornamentBottom: -20,
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
                      StatistikShalatStrings.sectionChecklistHariIni,
                      style: TextStyle(
                        color: AppColors.onPrimary.withValues(alpha: 0.7),
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXS),
                    Text(
                      '$jumlahShalat/${StatistikShalatConstants.totalWaktuShalat} Waktu',
                      style: AppTypography.serifHeadingSmall.copyWith(
                        color: AppColors.onPrimary,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '$jumlahTepatWaktu ${StatistikShalatStrings.labelTepatWaktu.toLowerCase()}',
                      style: TextStyle(
                        color: AppColors.onPrimary.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              if (streak > 0)
                StreakBadge(
                  streak: streak,
                  variant: StreakBadgeVariant.onPrimary,
                  showLabel: false,
                ),
            ],
          ),

          const SizedBox(height: AppDimens.spaceMD),
          const GoldDivider(verticalMargin: 0),
          const SizedBox(height: AppDimens.spaceMD),

          // Progress bar 5 waktu
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            child: LinearProgressIndicator(
              value: jumlahShalat / StatistikShalatConstants.totalWaktuShalat,
              minHeight: 6,
              backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Progress circle — shalat hari ini
// ---------------------------------------------------------------------------

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
            value: jumlahShalat / StatistikShalatConstants.totalWaktuShalat,
            strokeWidth: 5,
            backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
          Text(
            '$jumlahShalat/${StatistikShalatConstants.totalWaktuShalat}',
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
