import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/features/qibla/presentation/cubit/qibla_cubit.dart';
import 'package:equran_app/features/qibla/presentation/cubit/qibla_state.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_compass_widget.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_error_widget.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_info_panel.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<QiblaCubit>();
        unawaited(cubit.start());
        return cubit;
      },
      child: const _QiblaView(),
    );
  }
}

class _QiblaView extends StatelessWidget {
  const _QiblaView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final iconColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimens.appBarHeightLG,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.menu_rounded, color: iconColor),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Qibla Finder',
              style: AppTypography.serifHeadingMedium.copyWith(
                color: iconColor,
                height: 1,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 20,
              height: 1.5,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<QiblaCubit, QiblaState>(
            buildWhen: (prev, next) => prev.runtimeType != next.runtimeType,
            builder: (context, state) {
              if (state is! QiblaLoaded) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: isDark ? AppColors.primaryLighter : AppColors.primary,
                ),
                tooltip: 'Refresh',
                onPressed: () => unawaited(context.read<QiblaCubit>().start()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<QiblaCubit, QiblaState>(
        builder: (context, state) => switch (state) {
          QiblaInitial() => const _LoadingView(
            message: 'Mempersiapkan kompas...',
          ),
          QiblaLoading() => const _LoadingView(
            message: 'Mendapatkan lokasi Anda...',
          ),
          QiblaLoaded(:final direction) => _QiblaContent(
            bearing: direction.bearing,
            qiblaAngle: direction.qiblaAngle,
            accuracy: direction.accuracy,
            isDark: isDark,
          ),
          QiblaNoSensor() => QiblaErrorWidget(
            message: 'Perangkat tidak memiliki sensor kompas.',
            onRetry: () => unawaited(context.read<QiblaCubit>().start()),
            isNoSensor: true,
          ),
          QiblaError(:final message) => QiblaErrorWidget(
            message: message,
            onRetry: () => unawaited(context.read<QiblaCubit>().start()),
          ),
        },
      ),
    );
  }
}

// ── Loading view ──────────────────────────────────────────────────────────────

class _LoadingView extends StatefulWidget {
  const _LoadingView({required this.message});

  final String message;

  @override
  State<_LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<_LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    unawaited(_controller.repeat());
    _rotateAnim = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animasi kompas berputar
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ring luar berputar
                  RotationTransition(
                    turns: _rotateAnim,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: CustomPaint(
                        painter: _DashedCirclePainter(
                          color: AppColors.gold.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  // Icon kompas statis
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.primaryDark.withValues(alpha: 0.4)
                          : AppColors.primaryContainer.withValues(alpha: 0.5),
                    ),
                    child: Icon(
                      Icons.explore_rounded,
                      size: 32,
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.spaceLG),

            Text(
              widget.message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimens.spaceSM),

            Text(
              'Pastikan GPS dan izin lokasi aktif',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.onSurfaceDarkVariant.withValues(alpha: 0.6)
                    : AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    const dashCount = 12;
    const dashAngle = 0.2;
    const gapAngle = (2 * 3.14159 / dashCount) - dashAngle;

    for (var i = 0; i < dashCount; i++) {
      final startAngle = i * (dashAngle + gapAngle);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter old) => old.color != color;
}

// ── Main content ──────────────────────────────────────────────────────────────

class _QiblaContent extends StatelessWidget {
  const _QiblaContent({
    required this.bearing,
    required this.qiblaAngle,
    required this.isDark,
    this.accuracy,
  });

  final double bearing;
  final double qiblaAngle;
  final double? accuracy;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePadding,
        vertical: AppDimens.spaceLG,
      ),
      child: Column(
        children: [
          // Subtitle
          Text(
            'Hadapkan diri Anda ke arah jarum kompas',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.onSurfaceDarkVariant
                  : AppColors.textTertiary,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimens.spaceLG),

          // Kompas
          QiblaCompassWidget(
            qiblaAngle: qiblaAngle,
            accuracy: accuracy,
          ),

          const SizedBox(height: AppDimens.spaceLG),

          // Info panel
          QiblaInfoPanel(
            bearing: bearing,
            qiblaAngle: qiblaAngle,
          ),

          const SizedBox(height: AppDimens.spaceMD),

          // Cara pakai — onboarding untuk user awam
          _HowToCard(isDark: isDark),

          const SizedBox(height: AppDimens.spaceMD),

          // Tip card
          _TipCard(isDark: isDark),
        ],
      ),
    );
  }
}

// ── How to card ───────────────────────────────────────────────────────────────

class _HowToCard extends StatelessWidget {
  const _HowToCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    const steps = [
      (
        icon: Icons.stay_current_portrait_rounded,
        text: 'Pegang HP tegak lurus, layar menghadap ke atas',
      ),
      (
        icon: Icons.rotate_right_rounded,
        text: 'Putar badan perlahan hingga jarum menunjuk lurus ke atas',
      ),
      (
        icon: Icons.check_circle_outline_rounded,
        text: 'Saat muncul "Menghadap Kiblat!", Anda sudah di arah yang benar',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDark
                      : AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  size: 15,
                  color: isDark ? AppColors.primaryLighter : AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDimens.spaceSM),
              Text(
                'Cara Menggunakan',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.onSurfaceDark
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMD),
          ...steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: i < steps.length - 1 ? AppDimens.spaceSM : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nomor step
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.primaryLighter
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSM),
                  Expanded(
                    child: Text(
                      step.text,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Tip card ──────────────────────────────────────────────────────────────────

class _TipCard extends StatelessWidget {
  const _TipCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.outlineVariant;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.goldDark.withValues(alpha: 0.2)
                  : AppColors.goldLighter,
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
            ),
            child: const Icon(
              Icons.tips_and_updates_outlined,
              size: 16,
              color: AppColors.goldDark,
            ),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          Expanded(
            child: Text(
              'Jauhkan dari benda logam, magnet, dan elektronik untuk hasil yang lebih akurat.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.onSurfaceDarkVariant
                    : AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
