import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Toggle tile untuk notifikasi waktu shalat di SettingsPage.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.cardPadding,
        vertical: AppDimens.spaceXS,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: value
                  ? (isDark
                        ? AppColors.primaryLight.withValues(alpha: 0.2)
                        : AppColors.primaryContainer)
                  : (isDark
                        ? AppColors.surfaceDarkVariant
                        : AppColors.surfaceVariant),
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            child: Icon(
              icon,
              size: AppDimens.iconSM,
              color: value
                  ? (isDark ? AppColors.primaryLighter : AppColors.primary)
                  : (isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textTertiary),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isDark ? AppColors.onSurfaceDark : AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.onPrimary,
            activeTrackColor: isDark
                ? AppColors.primaryLighter
                : AppColors.primary,
            inactiveThumbColor: isDark
                ? AppColors.onSurfaceDarkVariant
                : AppColors.textTertiary,
            inactiveTrackColor: isDark
                ? AppColors.surfaceDarkVariant
                : AppColors.surfaceVariant,
          ),
        ],
      ),
    );
  }
}
