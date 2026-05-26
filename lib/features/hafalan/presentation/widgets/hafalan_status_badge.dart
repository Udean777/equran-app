import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:flutter/material.dart';

/// Badge warna untuk status hafalan.
class HafalanStatusBadge extends StatelessWidget {
  const HafalanStatusBadge({required this.status, super.key});

  final HafalanStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color, bg) = _config(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSM,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static (String, Color, Color) _config(HafalanStatus status) {
    switch (status) {
      case HafalanStatus.belum:
        return ('Belum', Colors.grey[600]!, Colors.grey[100]!);
      case HafalanStatus.sedangDihafal:
        return (
          'Sedang',
          AppColors.warning,
          AppColors.warning.withValues(alpha: 0.12),
        );
      case HafalanStatus.sudahHafal:
        return (
          'Hafal ✓',
          AppColors.success,
          AppColors.success.withValues(alpha: 0.12),
        );
      case HafalanStatus.perluMurajaah:
        return (
          'Murajaah!',
          AppColors.error,
          AppColors.error.withValues(alpha: 0.12),
        );
    }
  }
}
