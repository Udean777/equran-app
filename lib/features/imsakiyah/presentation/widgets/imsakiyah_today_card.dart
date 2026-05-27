import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/core/widgets/primary_gradient_card.dart';
import 'package:equran_app/core/widgets/shalat_time_grid.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:flutter/material.dart';

class ImsakiyahTodayCard extends StatelessWidget {
  const ImsakiyahTodayCard({
    required this.entry,
    required this.tanggal,
    super.key,
  });

  final ImsakiyahEntry entry;
  final int tanggal;

  @override
  Widget build(BuildContext context) {
    return PrimaryGradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.4),
                  ),
                ),
                child: const Icon(
                  Icons.today_rounded,
                  size: 16,
                  color: AppColors.onPrimary,
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                'Hari Ini — Tanggal $tanggal',
                style: AppTypography.serifHeadingSmall.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimens.spaceMD),
          const GoldDivider(verticalMargin: 0),
          const SizedBox(height: AppDimens.spaceMD),

          // Imsakiyah time grid
          ShalatTimeGrid(
            items: [
              ShalatTimeItem(label: 'Imsak',   time: entry.imsak,   icon: Icons.nightlight_round),
              ShalatTimeItem(label: 'Subuh',   time: entry.subuh,   icon: Icons.wb_twilight_outlined),
              ShalatTimeItem(label: 'Terbit',  time: entry.terbit,  icon: Icons.wb_sunny_outlined),
              ShalatTimeItem(label: 'Dhuha',   time: entry.dhuha,   icon: Icons.sunny_snowing),
              ShalatTimeItem(label: 'Dzuhur',  time: entry.dzuhur,  icon: Icons.light_mode_outlined),
              ShalatTimeItem(label: 'Ashar',   time: entry.ashar,   icon: Icons.wb_cloudy_outlined),
              ShalatTimeItem(label: 'Maghrib', time: entry.maghrib, icon: Icons.nights_stay_outlined),
              ShalatTimeItem(label: 'Isya',    time: entry.isya,    icon: Icons.bedtime_outlined),
            ],
          ),
        ],
      ),
    );
  }
}
