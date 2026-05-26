import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_reminder_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Section muraja'ah — level, tanggal berikutnya, tombol atur jadwal.
class HafalanMurajaahSection extends StatelessWidget {
  const HafalanMurajaahSection({required this.hafalan, super.key});

  final HafalanSurat hafalan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nextDate = hafalan.tanggalMurajaahBerikutnya;
    final dateStr = nextDate != null
        ? DateFormat('d MMMM yyyy', 'id').format(nextDate)
        : '-';
    final levelStr = hafalan.isMurajaahSelesai
        ? 'Hafalan kuat ✓'
        : 'Level ${hafalan.murajaahLevel + 1}/5';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceXS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceMD),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.timeline_rounded,
                  color: AppColors.primary,
                  size: AppDimens.iconMD,
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        levelStr,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!hafalan.isMurajaahSelesai)
                        Text(
                          'Berikutnya: $dateStr',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: hafalan.isMurajaahJatuhTempo
                                ? AppColors.error
                                : Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          OutlinedButton.icon(
            onPressed: () => unawaited(
              showAppBottomSheet<void>(
                context,
                builder: (_) => BlocProvider.value(
                  value: context.read<HafalanCubit>(),
                  child: HafalanReminderSheet(hafalan: hafalan),
                ),
              ),
            ),
            icon: const Icon(Icons.edit_calendar_rounded),
            label: const Text("Atur Jadwal Muraja'ah"),
          ),
        ],
      ),
    );
  }
}
