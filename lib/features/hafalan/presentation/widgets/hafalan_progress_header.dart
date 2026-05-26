import 'dart:ui' as ui;

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_status_badge.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:flutter/material.dart';

/// Header progress hafalan — nama Arab, progress bar, persentase.
class HafalanProgressHeader extends StatelessWidget {
  const HafalanProgressHeader({
    required this.surat,
    required this.ayatHafalCount,
    required this.progress,
    required this.persen,
    required this.status,
    super.key,
  });

  final Surat surat;
  final int ayatHafalCount;
  final double progress;
  final String persen;
  final HafalanStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(AppDimens.spaceMD),
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Text(
                        surat.nama,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontFamily: 'KFGQPC',
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Text(
                      surat.arti,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              HafalanStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                '$ayatHafalCount/${surat.jumlahAyat} ($persen%)',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
