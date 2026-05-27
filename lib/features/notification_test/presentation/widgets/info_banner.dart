import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({required this.isDark, super.key});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primaryDark.withValues(alpha: 0.5)
            : AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: isDark
              ? AppColors.primaryLight.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: isDark ? AppColors.primaryLighter : AppColors.primary,
            size: AppDimens.iconMD,
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Expanded(
            child: Text(
              'Setiap notif akan muncul 5 detik setelah tombol ditekan. '
              'Pastikan app di-minimize atau layar mati agar notif terlihat.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.primaryLighter : AppColors.primary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
