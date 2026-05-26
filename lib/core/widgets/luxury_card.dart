import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Card luxury dengan border outline tipis + optional shadow + optional tap.
///
/// Otomatis menyesuaikan warna surface dan border berdasarkan theme
/// (light/dark) — tidak perlu pass `isDark` dari luar.
///
/// Contoh:
/// ```dart
/// // Card sederhana
/// LuxuryCard(child: Text('Isi card'))
///
/// // Card tappable
/// LuxuryCard(
///   onTap: () => doSomething(),
///   child: Text('Tap me'),
/// )
///
/// // Card dengan shadow
/// LuxuryCard(
///   hasShadow: true,
///   child: Text('Elevated card'),
/// )
/// ```
class LuxuryCard extends StatelessWidget {
  const LuxuryCard({
    required this.child,
    this.padding,
    this.radius,
    this.onTap,
    this.hasShadow = false,
    this.color,
    super.key,
  });

  /// Konten card.
  final Widget child;

  /// Padding internal. Default: [AppDimens.cardPaddingLG] semua sisi.
  final EdgeInsetsGeometry? padding;

  /// Border radius. Default: [AppDimens.radiusLG].
  final double? radius;

  /// Callback tap. Jika null, card tidak tappable.
  final VoidCallback? onTap;

  /// Tampilkan box shadow primary alpha kecil. Default false.
  final bool hasShadow;

  /// Override warna background. Jika null, pakai surface dari theme.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveRadius = radius ?? AppDimens.radiusLG;
    final effectiveColor =
        color ?? (isDark ? AppColors.surfaceDark : AppColors.surface);
    final borderColor =
        isDark ? AppColors.outlineDark : AppColors.outlineVariant;

    final decoration = BoxDecoration(
      color: effectiveColor,
      borderRadius: BorderRadius.circular(effectiveRadius),
      border: Border.all(color: borderColor),
      boxShadow: hasShadow
          ? [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: isDark ? 0.04 : 0.06,
                ),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ]
          : null,
    );

    final content = Padding(
      padding: padding ??
          const EdgeInsets.all(AppDimens.cardPaddingLG),
      child: child,
    );

    if (onTap == null) {
      return Container(decoration: decoration, child: content);
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: Container(decoration: decoration, child: content),
      ),
    );
  }
}
