import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Chip label read-only — dipakai untuk tag, badge surat/ayat, kategori.
///
/// Otomatis menyesuaikan warna berdasarkan theme (light/dark).
///
/// Contoh:
/// ```dart
/// // Label surat · ayat
/// LabelChip(label: 'Al-Baqarah · 255')
///
/// // Tag kategori
/// LabelChip(label: 'Pagi')
///
/// // Dengan icon
/// LabelChip(label: 'Hafalan', icon: Icons.star_rounded)
/// ```
class LabelChip extends StatelessWidget {
  const LabelChip({
    required this.label,
    this.icon,
    this.color,
    super.key,
  });

  /// Teks label.
  final String label;

  /// Icon opsional di sisi kiri label.
  final IconData? icon;

  /// Override warna teks dan icon. Jika null, pakai primary dari theme.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveColor =
        color ?? (isDark ? AppColors.primaryLighter : AppColors.primary);
    final bgColor = isDark ? AppColors.primaryDark : AppColors.primaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: effectiveColor),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              color: effectiveColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
