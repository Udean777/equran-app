import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Halaman 404 — ditampilkan saat route tidak ditemukan.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textPrimary = isDark
        ? AppColors.onSurfaceDark
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textTertiary;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.heroPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ornamen arabesque
                _ArabesqueOrnament(isDark: isDark),

                const SizedBox(height: AppDimens.spaceXL),

                // Kode 404
                Text(
                  '٤٠٤',
                  style: AppTypography.serifDisplayLarge.copyWith(
                    color: isDark
                        ? AppColors.primaryLighter
                        : AppColors.primary,
                    fontSize: 56,
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: AppDimens.spaceMD),

                // Gold divider
                Container(
                  width: 48,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                ),

                const SizedBox(height: AppDimens.spaceMD),

                // Judul
                Text(
                  'Halaman Tidak Ditemukan',
                  style: AppTypography.serifHeadingMedium.copyWith(
                    color: textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimens.spaceSM),

                // Deskripsi
                Text(
                  'Halaman yang Anda cari tidak tersedia\natau telah dipindahkan.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimens.spaceXXL),

                // Tombol kembali
                _BackToHomeButton(isDark: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ornamen arabesque — dekoratif, konsisten dengan visual language app
// ---------------------------------------------------------------------------

class _ArabesqueOrnament extends StatelessWidget {
  const _ArabesqueOrnament({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran luar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.2),
              ),
            ),
          ),
          // Lingkaran tengah
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.primaryDark.withValues(alpha: 0.4)
                  : AppColors.primaryContainer.withValues(alpha: 0.5),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.35),
                width: AppDimens.goldBorderWidth,
              ),
            ),
          ),
          // Icon
          Icon(
            Icons.explore_off_rounded,
            size: 40,
            color: isDark ? AppColors.primaryLighter : AppColors.primary,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tombol kembali ke beranda
// ---------------------------------------------------------------------------

class _BackToHomeButton extends StatelessWidget {
  const _BackToHomeButton({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.primaryDark, AppColors.primary]
                : [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.3),
              blurRadius: AppDimens.blurRadiusMD,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          child: InkWell(
            onTap: () => context.go(AppRoutes.home),
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppDimens.spaceMD,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_rounded,
                    color: AppColors.onPrimary,
                    size: AppDimens.iconMD,
                  ),
                  SizedBox(width: AppDimens.spaceSM),
                  Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
