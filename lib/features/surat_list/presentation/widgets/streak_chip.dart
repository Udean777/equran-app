import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/streak_badge.dart';
import 'package:flutter/material.dart';

/// Streak chip dengan padding halaman — wrapper [StreakBadge] untuk surat list.
class StreakChip extends StatelessWidget {
  const StreakChip({required this.streak, super.key});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceSM,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          StreakBadge(streak: streak),
        ],
      ),
    );
  }
}
