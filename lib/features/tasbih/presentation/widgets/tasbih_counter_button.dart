import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/tasbih/presentation/constants/tasbih_constants.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Tombol besar di tengah layar untuk tap tasbih.
class TasbihCounterButton extends StatefulWidget {
  const TasbihCounterButton({
    required this.count,
    required this.progress,
    required this.isCompleted,
    required this.onTap,
    super.key,
  });

  final int count;
  final double progress;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  State<TasbihCounterButton> createState() => _TasbihCounterButtonState();
}

class _TasbihCounterButtonState extends State<TasbihCounterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: TasbihConstants.tapAnimationDuration,
    );
    _scaleAnimation =
        Tween<double>(
          begin: TasbihConstants.tapScaleBegin,
          end: TasbihConstants.tapScaleEnd,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = widget.isCompleted
        ? AppColors.gold
        : context.primaryActionColor;
    final ringBg = widget.isCompleted
        ? AppColors.gold.withValues(alpha: 0.15)
        : context.primaryActionColor.withValues(alpha: 0.12);

    return GestureDetector(
      onTap: widget.isCompleted ? null : _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: TasbihConstants.counterButtonSize,
          height: TasbihConstants.counterButtonSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress ring
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: widget.progress,
                  strokeWidth: 6,
                  backgroundColor: ringBg,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),

              // Gold outer ring (completed)
              if (widget.isCompleted)
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 2,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.gold.withValues(alpha: 0.3),
                    ),
                  ),
                ),

              // Inner circle
              Container(
                width: TasbihConstants.counterInnerCircleSize,
                height: TasbihConstants.counterInnerCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.07),
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isCompleted) ...[
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.gold,
                        size: 44,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.tasbihCompleted,
                        style: AppTypography.serifHeadingSmall.copyWith(
                          color: AppColors.gold,
                          fontSize: TasbihConstants.completedTextSize,
                        ),
                      ),
                    ] else
                      Text(
                        '${widget.count}',
                        style: TextStyle(
                          fontSize: TasbihConstants.counterNumberSize,
                          fontWeight: FontWeight.w700,
                          color: color,
                          height: 1,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
