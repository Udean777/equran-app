import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

/// Widget fallback untuk state error dan noSensor.
class QiblaErrorWidget extends StatelessWidget {
  const QiblaErrorWidget({
    required this.message,
    required this.onRetry,
    this.isNoSensor = false,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;
  final bool isNoSensor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceLG),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNoSensor
                    ? Icons.sensors_off_rounded
                    : Icons.location_off_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimens.spaceMD),
            Text(
              isNoSensor ? 'Sensor Tidak Tersedia' : 'Tidak Dapat Memuat',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimens.spaceSM),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
            if (!isNoSensor) ...[
              const SizedBox(height: AppDimens.spaceLG),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
