import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Divider tipis outline — dipakai di antara item dalam card / settings.
///
/// Otomatis menyesuaikan warna berdasarkan theme (light/dark).
///
/// Contoh:
/// ```dart
/// LuxuryCard(
///   child: Column(
///     children: [
///       LuxuryListTile(...),
///       LuxuryDivider(),
///       LuxuryListTile(...),
///     ],
///   ),
/// )
/// ```
class LuxuryDivider extends StatelessWidget {
  const LuxuryDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.cardPadding),
      color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
    );
  }
}

/// Divider gradient gold — dipakai sebagai pemisah dekoratif dalam card konten.
///
/// Contoh:
/// ```dart
/// Column(
///   children: [
///     Text(arabicText),
///     GoldDivider(),
///     Text(translation),
///   ],
/// )
/// ```
class GoldDivider extends StatelessWidget {
  const GoldDivider({
    this.verticalMargin = AppDimens.spaceSM,
    super.key,
  });

  /// Margin vertikal di atas dan bawah divider. Default [AppDimens.spaceSM].
  final double verticalMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gold.withValues(alpha: 0),
            AppColors.gold.withValues(alpha: 0.3),
            AppColors.gold.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
