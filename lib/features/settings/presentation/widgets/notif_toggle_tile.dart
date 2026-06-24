import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/widgets/luxury_list_tile.dart';
import 'package:flutter/material.dart';

/// Toggle tile untuk notifikasi — pakai [LuxuryListTile] dengan trailing Switch.
///
/// Icon container warna berubah sesuai state aktif/nonaktif.
class NotifToggleTile extends StatelessWidget {
  const NotifToggleTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    // Warna icon container berubah sesuai state aktif/nonaktif
    final iconBg = value
        ? (isDark
              ? AppColors.primaryLight.withValues(alpha: 0.2)
              : AppColors.primaryContainer)
        : (isDark ? AppColors.surfaceDarkVariant : AppColors.surfaceVariant);

    final iconColor = value
        ? (isDark ? AppColors.primaryLighter : AppColors.primary)
        : (isDark ? AppColors.onSurfaceDarkVariant : AppColors.textTertiary);

    return LuxuryListTile(
      icon: icon,
      title: label,
      iconColor: iconColor,
      iconBackgroundColor: iconBg,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.onPrimary,
        activeTrackColor: isDark ? AppColors.primaryLighter : AppColors.primary,
        inactiveThumbColor: isDark
            ? AppColors.onSurfaceDarkVariant
            : AppColors.textTertiary,
        inactiveTrackColor: isDark
            ? AppColors.surfaceDarkVariant
            : AppColors.surfaceVariant,
      ),
    );
  }
}
