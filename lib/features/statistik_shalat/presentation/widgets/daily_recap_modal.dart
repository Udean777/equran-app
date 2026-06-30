import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:flutter/material.dart';

class DailyRecapModal extends StatelessWidget {
  const DailyRecapModal({required this.stats, super.key});

  final ShalatDayStats stats;

  static Future<void> show(BuildContext context, ShalatDayStats stats) {
    return showDialog(
      context: context,
      builder: (context) => DailyRecapModal(stats: stats),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    String title;
    String subtitle;
    IconData icon;
    Color iconColor;

    if (stats.isSempurna) {
      title = '5 Waktu Tuntas!';
      subtitle =
          'Kerja bagus, kamu berhasil shalat 5 waktu! Teruskan sampai konsisten ya!';
      icon = Icons.verified_rounded;
      iconColor = AppColors.success;
    } else if (stats.jumlahQadha > 2) {
      title = 'Banyak Qadha';
      subtitle =
          'Hari ini kamu punya ${stats.jumlahQadha} qadha. Tetap semangat, yuk perbaiki di hari berikutnya!';
      icon = Icons.info_rounded;
      iconColor = AppColors.warning;
    } else if (stats.jumlahShalat == 0) {
      title = 'Tidak Ada Catatan';
      subtitle =
          'Belum ada shalat yang tercatat untuk hari ini. Jangan lupa untuk mengisi riwayat shalatmu.';
      icon = Icons.warning_rounded;
      iconColor = AppColors.error;
    } else {
      title = 'Sudah ${stats.jumlahTepatWaktu} Waktu Tercatat';
      subtitle =
          'Sedikit lagi sempurna! Mari perbaiki shalat yang masih bolong hari ini.';
      icon = Icons.stars_rounded;
      iconColor = AppColors.primary;
    }

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceMD),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 48,
              ),
            ),
            const SizedBox(height: AppDimens.spaceLG),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimens.spaceSM),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimens.spaceXL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spaceMD,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                  ),
                ),
                child: const Text(
                  'Siap!',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
