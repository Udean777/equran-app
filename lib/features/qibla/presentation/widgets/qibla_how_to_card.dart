import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/luxury_card.dart';
import 'package:flutter/material.dart';

/// Card "Cara Menggunakan" — panduan langkah-langkah penggunaan Qibla Finder.
class QiblaHowToCard extends StatelessWidget {
  const QiblaHowToCard({super.key});

  static const List<({IconData icon, String text})> _steps = [
    (
      icon: Icons.stay_current_portrait_rounded,
      text: 'Pegang HP tegak lurus, layar menghadap ke atas',
    ),
    (
      icon: Icons.rotate_right_rounded,
      text: 'Putar badan perlahan hingga jarum menunjuk lurus ke atas',
    ),
    (
      icon: Icons.check_circle_outline_rounded,
      text: 'Saat muncul "Menghadap Kiblat!", Anda sudah di arah yang benar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LuxuryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: context.primaryContainerColor,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  size: 15,
                  color: context.primaryActionColor,
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                'Cara Menggunakan',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),

          // Steps
          ..._steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: i < _steps.length - 1 ? AppDimens.spaceSM : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: context.primaryContainerColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: context.primaryActionColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSM),
                  Expanded(
                    child: Text(
                      step.text,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.textSecondaryColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
