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
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<QuranFontCubit, QuranFontState>(
      builder: (context, fontState) => Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD,
          vertical: AppDimens.spaceXS,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label + copy button
              Row(
                children: [
                  Text(
                    l10n.arabicText,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Salin',
                    icon: const Icon(
                      Icons.copy_rounded,
                      size: AppDimens.iconSM,
                    ),
                    onPressed: () {
                      unawaited(Clipboard.setData(ClipboardData(text: ar)));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Teks Arab disalin'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceSM),
              // Arabic text — RTL, font dari QuranFontCubit
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  ar,
                  style: AppTypography.arabicDynamic(fontState).copyWith(
                    color: AppColors.primary,
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
