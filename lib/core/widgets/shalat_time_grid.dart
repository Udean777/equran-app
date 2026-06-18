import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Data model untuk satu item waktu shalat/imsakiyah.
class ShalatTimeItem {
  const ShalatTimeItem({
    required this.label,
    required this.time,
    required this.icon,
    this.isHighlighted = false,
  });

  /// Nama waktu (e.g. "Subuh", "Dzuhur").
  final String label;

  /// Jam dalam format string (e.g. "04:32").
  final String time;

  /// Icon yang mewakili waktu ini.
  final IconData icon;

  /// Highlight item ini (e.g. waktu shalat berikutnya).
  final bool isHighlighted;
}

/// Grid waktu shalat/imsakiyah — Wrap layout, 4 kolom.
///
/// Dipakai di JadwalShalatTodayCard dan ImsakiyahTodayCard.
///
/// Contoh:
/// ```dart
/// ShalatTimeGrid(
///   items: [
///     ShalatTimeItem(label: 'Subuh', time: '04:32', icon: Icons.wb_twilight_outlined),
///     ShalatTimeItem(label: 'Dzuhur', time: '12:01', icon: Icons.light_mode_outlined, isHighlighted: true),
///   ],
/// )
/// ```
class ShalatTimeGrid extends StatelessWidget {
  const ShalatTimeGrid({required this.items, super.key});

  final List<ShalatTimeItem> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimens.spaceSM,
      runSpacing: AppDimens.spaceSM,
      children: items.map((item) {
        final itemWidth =
            (MediaQuery.sizeOf(context).width -
                AppDimens.pagePadding * 2 -
                AppDimens.cardPaddingLG * 2 -
                AppDimens.spaceSM * 3) /
            4;

        return SizedBox(
          width: itemWidth,
          child: _ShalatTimeCell(item: item),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Cell
// ---------------------------------------------------------------------------

class _ShalatTimeCell extends StatelessWidget {
  const _ShalatTimeCell({required this.item});

  final ShalatTimeItem item;

  @override
  Widget build(BuildContext context) {
    final highlighted = item.isHighlighted;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.spaceSM,
        horizontal: AppDimens.spaceXS,
      ),
      decoration: highlighted
          ? BoxDecoration(
              color: AppColors.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.5),
              ),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 14,
            color: highlighted
                ? AppColors.gold
                : AppColors.onPrimary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: AppDimens.spaceXXS),
          Text(
            item.time,
            style: TextStyle(
              color: highlighted ? AppColors.gold : AppColors.onPrimary,
              fontWeight: highlighted ? FontWeight.w700 : FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            item.label,
            style: TextStyle(
              color: AppColors.onPrimary.withValues(alpha: 0.7),
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
