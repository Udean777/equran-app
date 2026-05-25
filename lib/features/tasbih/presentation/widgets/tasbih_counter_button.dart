import 'package:equran_app/core/theme/app_colors.dart';
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
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.93).animate(
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
    final color =
        widget.isCompleted ? AppColors.secondary : AppColors.primary;

    return GestureDetector(
      onTap: widget.isCompleted ? null : _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress ring
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: widget.progress,
                  strokeWidth: 6,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Inner circle
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.08),
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isCompleted)
                      Icon(
                        Icons.check_circle_rounded,
                        color: color,
                        size: 40,
                      )
                    else
                      Text(
                        '${widget.count}',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: color,
                          height: 1,
                        ),
                      ),
                    if (widget.isCompleted)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Selesai',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
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
