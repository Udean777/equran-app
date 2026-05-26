import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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
    final theme = Theme.of(context);
    final jumlahShalat = today.jumlahShalat;
    final jumlahTepatWaktu = today.jumlahTepatWaktu;

    return Container(
      margin: const EdgeInsets.all(AppDimens.spaceMD),
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      ),
      child: Row(
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXS),
                Text(
                  '$jumlahShalat/5 waktu',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXS),
                Text(
                  '$jumlahTepatWaktu tepat waktu',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          // Streak
          if (streak > 0) _StreakBadge(streak: streak),
        ],
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
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.onPrimary,
            ),
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
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.orange,
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
            streak == 1 ? 'hari' : 'hari',
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
