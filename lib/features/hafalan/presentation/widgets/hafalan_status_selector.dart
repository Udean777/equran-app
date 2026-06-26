import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/viewmodels/hafalan_detail_viewmodel.dart';
import 'package:flutter/material.dart';

class HafalanStatusSelector extends StatelessWidget {
  const HafalanStatusSelector({
    required this.suratNomor,
    required this.currentStatus,
    required this.detailNotifier,
    super.key,
  });

  final int suratNomor;
  final HafalanStatus currentStatus;
  final HafalanDetailViewModel detailNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = [
      HafalanStatus.belum,
      HafalanStatus.sedangDihafal,
      HafalanStatus.sudahHafal,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMD),
      child: Row(
        children: [
          Text(
            'Status:',
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: AppDimens.spaceSM),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: options.map((s) {
                  final isSelected =
                      currentStatus == s ||
                      (currentStatus == HafalanStatus.perluMurajaah &&
                          s == HafalanStatus.sudahHafal);
                  return Padding(
                    padding: const EdgeInsets.only(right: AppDimens.spaceXS),
                    child: ChoiceChip(
                      label: Text(_statusLabel(s)),
                      selected: isSelected,
                      onSelected: (_) => unawaited(
                        detailNotifier.setStatus(
                          suratNomor: suratNomor,
                          status: s,
                        ),
                      ),
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : null,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(HafalanStatus status) {
    switch (status) {
      case HafalanStatus.belum:
        return 'Belum';
      case HafalanStatus.sedangDihafal:
        return 'Sedang';
      case HafalanStatus.sudahHafal:
        return 'Hafal';
      case HafalanStatus.perluMurajaah:
        return 'Murajaah';
    }
  }
}
