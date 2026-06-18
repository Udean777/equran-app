import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/theme/cubit/quran_font_cubit.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoaArabicCard extends StatelessWidget {
  const DoaArabicCard({required this.ar, super.key});

  final String ar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return BlocBuilder<QuranFontCubit, QuranFontState>(
      builder: (context, fontState) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.spaceXS,
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
              // Label + copy
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSM),
                  Text(
                    l10n.arabicText,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      unawaited(Clipboard.setData(ClipboardData(text: ar)));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Teks Arab disalin'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceSM,
                        vertical: AppDimens.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.copy_rounded,
                            size: 12,
                            color: isDark
                                ? AppColors.primaryLighter
                                : AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Salin',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.primaryLighter
                                  : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimens.spaceLG),

              // Arabic text
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  ar,
                  style: AppTypography.arabicDynamic(fontState).copyWith(
                    color: isDark
                        ? AppColors.primaryLighter
                        : AppColors.primary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
