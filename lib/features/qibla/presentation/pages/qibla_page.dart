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
                onPressed: () => unawaited(
                  context.read<QiblaCubit>().start(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<QiblaCubit, QiblaState>(
        builder: (context, state) => switch (state) {
          QiblaInitial() => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          QiblaLoading() => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
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
            'Hadapkan perangkat ke arah kiblat',
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

          // Tip card
          _TipCard(isDark: isDark),
        ],
      ),
    );
  }
}

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
              'Jauhkan dari benda logam dan elektronik untuk hasil yang lebih akurat.',
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
