import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:flutter/material.dart';

/// Card terakhir di stack yang merayakan penyelesaian membaca surah.
class SuratCompletionCard extends StatelessWidget {
  const SuratCompletionCard({
    required this.detail,
    required this.onBackToHome,
    required this.onRestart,
    super.key,
  });

  final SuratDetail detail;
  final VoidCallback onBackToHome;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surat = detail;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.primaryDark, AppColors.surfaceDark]
              : [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        border: Border.all(
          color: isDark
              ? AppColors.outlineDark
              : AppColors.gold.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ornamen lingkaran latar belakang bernuansa mewah
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onPrimary.withValues(alpha: 0.03),
              ),
            ),
          ),

          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLG,
                vertical: AppDimens.spaceXL,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon badge perayaan
                  Container(
                    padding: const EdgeInsets.all(AppDimens.spaceLG),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.stars_rounded,
                      color: AppColors.goldLighter,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceLG),

                  // Congratulations
                  Text(
                    'Alhamdulillah!',
                    style: AppTypography.serifHeadingMedium.copyWith(
                      color: AppColors.goldLighter,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.spaceXS),
                  Text(
                    'Kamu telah selesai membaca',
                    style: TextStyle(
                      color: AppColors.onPrimary.withValues(alpha: 0.8),
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),

                  // Surah name
                  Text(
                    surat.namaLatin,
                    style: AppTypography.serifHeadingLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '"${surat.arti}"',
                    style: TextStyle(
                      color: AppColors.onPrimary.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.spaceMD),

                  // Progress Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceMD,
                      vertical: AppDimens.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 13,
                          color: AppColors.goldLighter,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '100% Selesai • ${surat.jumlahAyat} Ayat',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  // Primary Button: Kembali ke Halaman Utama
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: onBackToHome,
                      icon: const Icon(Icons.home_rounded, size: 18),
                      label: const Text(
                        'Kembali ke Halaman Utama',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldLighter,
                        foregroundColor: AppColors.onGold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusLG,
                          ),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceSM),

                  // Secondary Button: Baca Ulang
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: onRestart,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text(
                        'Baca Ulang Surah',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Colors.white24,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusLG,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
