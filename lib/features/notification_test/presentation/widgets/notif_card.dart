import 'dart:async';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';

class NotifCard extends StatefulWidget {
  const NotifCard({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.status,
    required this.onTest,
    super.key,
  });

  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool? status;
  final VoidCallback onTest;

  @override
  State<NotifCard> createState() => _NotifCardState();
}

class _NotifCardState extends State<NotifCard> {
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    if (widget.status == true) {
      _startCountdown();
    }
  }

  @override
  void didUpdateWidget(NotifCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status != oldWidget.status) {
      _stopCountdown();
      if (widget.status == true) {
        _startCountdown();
      }
    }
  }

  void _startCountdown() {
    _remainingSeconds = 5;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _timer?.cancel();
          }
        });
      }
    });
  }

  void _stopCountdown() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopCountdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: widget.status == true
              ? AppColors.success.withValues(alpha: 0.5)
              : widget.status == false
              ? AppColors.error.withValues(alpha: 0.5)
              : borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.cardPadding),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.color.withValues(
                  alpha: isDark ? 0.15 : 0.1,
                ),
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(
                widget.icon,
                color: widget.color,
                size: AppDimens.iconMD,
              ),
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
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark
                                ? AppColors.onSurfaceDark
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (widget.status != null)
                        Icon(
                          widget.status!
                              ? Icons.check_circle_rounded
                              : Icons.error_rounded,
                          size: 16,
                          color: widget.status!
                              ? AppColors.success
                              : AppColors.error,
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.onSurfaceDarkVariant
                          : AppColors.textTertiary,
                      height: 1.4,
                    ),
                  ),
                  if (widget.status == true) ...[
                    const SizedBox(height: AppDimens.spaceXS),
                    Text(
                      _remainingSeconds > 0
                          ? 'Dijadwalkan — tunggu $_remainingSeconds detik'
                          : 'Berhasil dijalankan',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spaceSM),
            _TestButton(
              color: widget.color,
              onTap: widget.onTest,
            ),
          ],
        ),
      ),
    );
  }
}

class _TestButton extends StatelessWidget {
  const _TestButton({
    required this.color,
    required this.onTap,
  });

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD,
          vertical: AppDimens.spaceSM,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.2 : 0.12),
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          'Test',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
