import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:flutter/material.dart';

/// Card reminder muraja'ah harian — menampilkan daftar surat yang perlu
/// dimuraja'ah hari ini.
///
/// Menerima [onTap] dari parent (DIP) — tidak akses router sendiri.
class MurajaahReminderCard extends StatelessWidget {
  const MurajaahReminderCard({
    required this.suratList,
    required this.onTap,
    super.key,
  });

  final List<HafalanSurat> suratList;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final names = suratList.take(3).map((s) => s.namaLatin).join(', ');
    final extra = suratList.length > 3 ? ' +${suratList.length - 3}' : '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          child: Container(
            padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.warningContainer.withValues(alpha: 0.08)
                  : AppColors.warningContainer,
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.warning,
                    size: AppDimens.iconMD,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Muraja'ah Hari Ini",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$names$extra',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.warning.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.warning.withValues(alpha: 0.6),
                  size: AppDimens.iconMD,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
