import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/theme/context_ext.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:flutter/material.dart';

class ImsakiyahHeaderCard extends StatelessWidget {
  const ImsakiyahHeaderCard({
    required this.jadwal,
    required this.onChangeLocation,
    super.key,
  });

  final Imsakiyah jadwal;
  final VoidCallback onChangeLocation;

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
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.primaryContainerColor,
                borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              ),
              child: Icon(
                Icons.location_on_rounded,
                size: 18,
                color: context.primaryActionColor,
              ),
            ),
            const SizedBox(width: AppDimens.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jadwal.kabkota,
                    style: AppTypography.serifHeadingSmall.copyWith(
                      color: context.textPrimaryColor,
                      fontSize: 15,
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
                    color: context.primaryActionColor.withValues(alpha: 0.2),
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
                      'Ubah',
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
      ),
    );
  }
}
