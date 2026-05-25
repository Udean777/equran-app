import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_session.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Card untuk menampilkan satu sesi tasbih di riwayat.
class TasbihSessionCard extends StatelessWidget {
  const TasbihSessionCard({
    required this.session,
    required this.onDelete,
    super.key,
  });

  final TasbihSession session;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy, HH:mm', 'id').format(
      session.createdAt.toLocal(),
    );
    final isComplete = session.count >= session.target;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMD),
        child: Row(
          children: [
            // Icon status
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isComplete
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.warning.withValues(alpha: 0.1),
              ),
              child: Icon(
                isComplete
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isComplete ? AppColors.success : AppColors.warning,
                size: 24,
              ),
            ),
            const SizedBox(width: AppDimens.spaceMD),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.presetName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${session.count} / ${session.target}x',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // Delete button
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              color: Colors.red[400],
              tooltip: 'Hapus',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
