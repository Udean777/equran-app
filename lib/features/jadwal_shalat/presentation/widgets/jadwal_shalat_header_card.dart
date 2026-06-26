import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/theme/context_ext.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:flutter/material.dart';

class JadwalShalatHeaderCard extends StatelessWidget {
  const JadwalShalatHeaderCard({
    required this.jadwal,
    required this.onChangeLocation,
    required this.onPrevBulan,
    required this.onNextBulan,
    super.key,
  });

  final JadwalShalat jadwal;
  final VoidCallback onChangeLocation;
  final VoidCallback onPrevBulan;
  final VoidCallback onNextBulan;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = context.surfaceColor;
    final borderColor = context.borderSubtleColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceSM,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lokasi row
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: context.primaryContainerColor,
                    borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: context.primaryActionColor,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jadwal.kabkota,
                        style: context.theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.textPrimaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        jadwal.provinsi,
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: context.textTertiaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onChangeLocation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceSM + 2,
                      vertical: AppDimens.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: context.primaryContainerColor,
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      border: Border.all(
                        color: context.primaryActionColor.withValues(
                          alpha: 0.2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_location_alt_outlined,
                          size: 12,
                          color: context.primaryActionColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Ganti',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: context.primaryActionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceMD),

            const GoldDivider(verticalMargin: 0),

            const SizedBox(height: AppDimens.spaceMD),

            // Bulan navigator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavBtn(
                  icon: Icons.chevron_left_rounded,
                  onTap: onPrevBulan,
                ),
                Column(
                  children: [
                    Text(
                      jadwal.bulanNama,
                      style: AppTypography.serifHeadingSmall.copyWith(
                        color: context.textPrimaryColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      jadwal.tahun.toString(),
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: context.textTertiaryColor,
                      ),
                    ),
                  ],
                ),
                _NavBtn(
                  icon: Icons.chevron_right_rounded,
                  onTap: onNextBulan,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.primaryContainerColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: context.primaryActionColor,
          size: AppDimens.iconMD,
        ),
      ),
    );
  }
}
