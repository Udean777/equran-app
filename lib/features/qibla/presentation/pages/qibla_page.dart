import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/qibla/presentation/cubit/qibla_cubit.dart';
import 'package:equran_app/features/qibla/presentation/cubit/qibla_state.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_compass_widget.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_error_widget.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_how_to_card.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_info_panel.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_loading_view.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_tip_card.dart';
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
    final isDark = context.isDark;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: LuxuryAppBar(
        title: 'Qibla Finder',
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
          QiblaInitial() => const QiblaLoadingView(
            message: 'Mempersiapkan kompas...',
          ),
          QiblaLoading() => const QiblaLoadingView(
            message: 'Mendapatkan lokasi Anda...',
          ),
          QiblaLoaded(:final direction) => _QiblaContent(
            bearing: direction.bearing,
            qiblaAngle: direction.qiblaAngle,
            accuracy: direction.accuracy,
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
    this.accuracy,
  });

  final double bearing;
  final double qiblaAngle;
  final double? accuracy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePadding,
        vertical: AppDimens.spaceLG,
      ),
      child: Column(
        children: [
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
          QiblaCompassWidget(qiblaAngle: qiblaAngle, accuracy: accuracy),
          const SizedBox(height: AppDimens.spaceLG),
          QiblaInfoPanel(bearing: bearing, qiblaAngle: qiblaAngle),
          const SizedBox(height: AppDimens.spaceMD),
          const QiblaHowToCard(),
          const SizedBox(height: AppDimens.spaceMD),
          const QiblaTipCard(),
        ],
      ),
    );
  }
}
