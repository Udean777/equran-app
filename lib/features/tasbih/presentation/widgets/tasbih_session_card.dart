import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/tasbih/constants/tasbih_constants.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_session.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Card untuk menampilkan satu sesi tasbih di riwayat.
class TasbihSessionCard extends StatelessWidget {
  const TasbihSessionCard({
    required this.session,
    required this.onDelete,
    super.key,
  });

  final TasbihSession session;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surfaceColor = context.surfaceColor;
    final borderColor = context.borderVariantColor;
    final dateStr = DateFormat('dd MMM yyyy, HH:mm', 'id').format(
      session.createdAt.toLocal(),
    );
    final isComplete = session.count >= session.target;
    final statusColor = isComplete ? AppColors.success : AppColors.warning;

    return Material(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(
            color: isComplete
                ? AppColors.success.withValues(alpha: 0.3)
                : borderColor,
          ),
        ),
        padding: const EdgeInsets.all(AppDimens.cardPadding),
        child: Row(
          children: [
            // Status icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                isComplete
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: statusColor,
                size: 22,
              ),
            ),
            const SizedBox(width: AppDimens.spaceMD),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.presetName,
                    style: AppTypography.serifHeadingSmall.copyWith(
                      color: context.textPrimaryColor,
                      fontSize: TasbihConstants.sessionTitleSize,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceSM,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryContainerColor,
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusFull,
                          ),
                        ),
                        child: Text(
                          '${session.count} / ${session.target}x',
                          style: TextStyle(
                            color: context.primaryActionColor,
                            fontWeight: FontWeight.w600,
                            fontSize: TasbihConstants.sessionMetaSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dateStr,
                    style: TextStyle(
                      color: context.textTertiaryColor,
                      fontSize: TasbihConstants.sessionMetaSize,
                    ),
                  ),
                ],
              ),
            ),

            // Delete button
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error.withValues(alpha: 0.6),
                size: AppDimens.iconSM,
              ),
              tooltip: l10n.tasbihDelete,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
