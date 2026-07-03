import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_badge.dart';
import 'package:equran_app/features/statistik_shalat/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BadgesPage extends ConsumerWidget {
  const BadgesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badges = ref.watch(badgesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Pencapaian')),
      body: badges.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spaceLG),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 64,
                      color: isDark
                          ? AppColors.onSurfaceDarkVariant
                          : AppColors.textTertiary,
                    ),
                    const SizedBox(height: AppDimens.spaceMD),
                    Text(
                      'Belum ada pencapaian',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppDimens.spaceSM),
                    Text(
                      'Catat shalatmu secara rutin untuk membuka badge!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppDimens.spaceMD),
              itemCount: badges.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppDimens.spaceSM),
              itemBuilder: (context, index) {
                final badge = badges[index];
                return _BadgeCard(badge: badge, isDark: isDark);
              },
            ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge, required this.isDark});

  final BadgeType badge;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(
          color: _tierColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _tierColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            child: Icon(badge.icon, color: _tierColor, size: 24),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  badge.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          _TierBadge(tier: badge.tier, isDark: isDark),
        ],
      ),
    );
  }

  Color get _tierColor {
    switch (badge.tier) {
      case 1:
        return AppColors.gold;
      case 2:
        return AppColors.primary;
      case 3:
        return Colors.deepPurple;
      default:
        return AppColors.gold;
    }
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.tier, required this.isDark});

  final int tier;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        'Tier $tier',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isDark
              ? AppColors.onSurfaceDarkVariant
              : AppColors.textTertiary,
        ),
      ),
    );
  }
}
