import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Variant tampilan streak badge.
enum StreakBadgeVariant {
  /// Di atas surface — background gold, teks gelap.
  /// Dipakai di list page, drawer.
  surface,

  /// Di atas gradient primary — background semi-transparan, teks putih.
  /// Dipakai di dalam PrimaryGradientCard.
  onPrimary,
}

/// Badge streak — menampilkan jumlah hari berturut-turut dengan fire icon.
///
/// Contoh surface (di list page):
/// ```dart
/// StreakBadge(streak: 7)
/// ```
///
/// Contoh onPrimary (di dalam card gradient):
/// ```dart
/// StreakBadge(streak: 7, variant: StreakBadgeVariant.onPrimary)
/// ```
class StreakBadge extends StatelessWidget {
  const StreakBadge({
    required this.streak,
    this.variant = StreakBadgeVariant.surface,
    this.showLabel = true,
    super.key,
  });

  final int streak;

  /// Variant tampilan. Default [StreakBadgeVariant.surface].
  final StreakBadgeVariant variant;

  /// Tampilkan label "hari berturut-turut" di samping angka.
  /// Default true. Set false untuk tampilan compact (di dalam card).
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (variant) {
      StreakBadgeVariant.surface => _SurfaceBadge(
          streak: streak,
          isDark: isDark,
          showLabel: showLabel,
        ),
      StreakBadgeVariant.onPrimary => _OnPrimaryBadge(
          streak: streak,
          showLabel: showLabel,
        ),
    };
  }
}

// ---------------------------------------------------------------------------
// Surface variant — background gold, dipakai di list/drawer
// ---------------------------------------------------------------------------

class _SurfaceBadge extends StatelessWidget {
  const _SurfaceBadge({
    required this.streak,
    required this.isDark,
    required this.showLabel,
  });

  final int streak;
  final bool isDark;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM + 2,
        vertical: AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.goldDark.withValues(alpha: 0.2)
            : AppColors.goldLighter,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.orange,
            size: 13,
          ),
          const SizedBox(width: AppDimens.spaceXS),
          Text(
            showLabel ? '$streak hari berturut-turut' : '$streak',
            style: TextStyle(
              color: isDark ? AppColors.goldLight : AppColors.goldDark,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// OnPrimary variant — di atas gradient card
// ---------------------------------------------------------------------------

class _OnPrimaryBadge extends StatelessWidget {
  const _OnPrimaryBadge({
    required this.streak,
    required this.showLabel,
  });

  final int streak;
  final bool showLabel;

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
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: showLabel
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.gold,
                  size: 14,
                ),
                const SizedBox(width: AppDimens.spaceXS),
                Text(
                  '$streak hari',
                  style: const TextStyle(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.gold,
                  size: 18,
                ),
                Text(
                  '$streak',
                  style: const TextStyle(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
