import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/onboarding/presentation/widgets/onboarding_shared.dart';
import 'package:flutter/material.dart';

/// Slide 2 — Izin Lokasi + Notifikasi
class OnboardingSlide2 extends StatelessWidget {
  const OnboardingSlide2({
    required this.locationGranted,
    required this.notifGranted,
    required this.permissionRequested,
    required this.onRequestPermissions,
    super.key,
  });

  final bool locationGranted;
  final bool notifGranted;
  final bool permissionRequested;
  final VoidCallback onRequestPermissions;

  @override
  Widget build(BuildContext context) {
    return OnboardingSlideBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimens.radiusXL),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: AppColors.gold,
              size: 32,
            ),
          ),
          const SizedBox(height: AppDimens.spaceLG),
          Text(
            'Izinkan Akses',
            style: AppTypography.serifHeadingLarge.copyWith(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          Text(
            'Beberapa izin diperlukan agar semua fitur '
            'dapat berjalan dengan optimal.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          _PermissionItem(
            icon: Icons.location_on_rounded,
            title: 'Akses Lokasi',
            description:
                'Untuk menampilkan jadwal shalat dan imsakiyah '
                'yang akurat sesuai lokasi kamu secara otomatis.',
            isGranted: locationGranted,
            isRequested: permissionRequested,
          ),
          const SizedBox(height: AppDimens.spaceMD),
          _PermissionItem(
            icon: Icons.notifications_rounded,
            title: 'Notifikasi',
            description:
                'Untuk mengirim pengingat adzan, alarm imsak, '
                'dan reminder baca Quran harian.',
            isGranted: notifGranted,
            isRequested: permissionRequested,
          ),
          const SizedBox(height: AppDimens.spaceXL),
          if (!permissionRequested)
            GestureDetector(
              onTap: onRequestPermissions,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMD,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.gold, AppColors.goldDark],
                  ),
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Izinkan Sekarang',
                  style: TextStyle(
                    color: AppColors.onGold,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.cardPadding),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: AppDimens.iconMD,
                  ),
                  const SizedBox(width: AppDimens.spaceSM),
                  Expanded(
                    child: Text(
                      locationGranted && notifGranted
                          ? 'Semua izin diberikan. Tekan Lanjut.'
                          : 'Izin sebagian diberikan. Kamu bisa mengatur ulang di Pengaturan.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isGranted,
    required this.isRequested,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isGranted;
  final bool isRequested;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: isGranted
              ? AppColors.success.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            child: Icon(icon, color: AppColors.gold, size: 22),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (isRequested)
                      Icon(
                        isGranted
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color:
                            isGranted ? AppColors.success : AppColors.error,
                        size: 18,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
