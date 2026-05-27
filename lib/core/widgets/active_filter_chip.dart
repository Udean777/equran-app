import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Chip filter aktif yang bisa di-dismiss — menampilkan label filter
/// yang sedang aktif dengan tombol close di sisi kanan.
///
/// Otomatis menyesuaikan warna berdasarkan theme (light/dark).
///
/// Contoh:
/// ```dart
/// ActiveFilterChip(
///   label: 'Doa Pagi',
///   onClear: () => cubit.clearFilter(),
/// )
/// ```
class ActiveFilterChip extends StatelessWidget {
  const ActiveFilterChip({
    required this.label,
    required this.onClear,
    super.key,
  });

  /// Label filter yang sedang aktif.
  final String label;

  /// Callback saat user tap tombol close.
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? AppColors.primaryLighter : AppColors.primary;
    final bgColor = isDark ? AppColors.primaryDark : AppColors.primaryContainer;
    final borderColor = isDark
        ? AppColors.primaryLight.withValues(alpha: 0.3)
        : AppColors.primary.withValues(alpha: 0.3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceSM + 2,
              vertical: AppDimens.spaceXS,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 12,
                  color: contentColor,
                ),
                const SizedBox(width: AppDimens.spaceXS),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: contentColor,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceXS),
                GestureDetector(
                  onTap: onClear,
                  child: Icon(
                    Icons.close_rounded,
                    size: 13,
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
