import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Data model untuk satu item dalam [StatsRow].
class StatRowItem {
  const StatRowItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  /// Label kecil di bawah value (e.g. "Total Ayat").
  final String label;

  /// Nilai utama yang ditampilkan besar (e.g. "1234").
  final String value;

  /// Icon di atas value.
  final IconData icon;
}

/// Baris statistik horizontal — icon + value + label, dipisah divider vertikal.
///
/// Dipakai di dalam PrimaryGradientCard untuk menampilkan ringkasan angka.
///
/// Contoh:
/// ```dart
/// StatsRow(
///   items: [
///     StatRowItem(label: 'Total Ayat', value: '1234', icon: Icons.format_list_numbered_rounded),
///     StatRowItem(label: 'Streak', value: '7', icon: Icons.local_fire_department_rounded),
///     StatRowItem(label: 'Juz', value: '3', icon: Icons.auto_stories_rounded),
///   ],
/// )
/// ```
class StatsRow extends StatelessWidget {
  const StatsRow({required this.items, super.key});

  final List<StatRowItem> items;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (var i = 0; i < items.length; i++) {
      children.add(_StatItem(item: items[i]));
      if (i < items.length - 1) {
        children.add(_StatDivider());
      }
    }

    return Row(children: children);
  }
}

// ---------------------------------------------------------------------------
// Item
// ---------------------------------------------------------------------------

class _StatItem extends StatelessWidget {
  const _StatItem({required this.item});

  final StatRowItem item;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(item.icon, color: AppColors.gold, size: 16),
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            item.value,
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Text(
            item.label,
            style: TextStyle(
              color: AppColors.onPrimary.withValues(alpha: 0.7),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Divider vertikal antar item
// ---------------------------------------------------------------------------

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.onPrimary.withValues(alpha: 0.15),
    );
  }
}
