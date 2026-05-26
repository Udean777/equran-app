import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Qibla Finder'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            tooltip: 'Menu',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          // Tombol refresh manual
          BlocBuilder<QiblaCubit, QiblaState>(
            builder: (context, state) {
              if (state is QiblaError) {
                return IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () => context.read<QiblaCubit>().start(),
                  tooltip: 'Coba Lagi',
                );
              }
              return const SizedBox.shrink();
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
            message: 'Mendeteksi lokasi...',
          ),
          QiblaLoaded(:final direction) => _LoadedView(
            qiblaAngle: direction.qiblaAngle,
            bearing: direction.bearing,
            accuracy: direction.accuracy,
          ),
          QiblaError(:final message) => QiblaErrorWidget(
            message: message,
            onRetry: () => context.read<QiblaCubit>().start(),
          ),
          QiblaNoSensor() => QiblaErrorWidget(
            message:
                'Perangkat ini tidak memiliki sensor kompas yang diperlukan untuk menentukan arah kiblat.',
            onRetry: () => context.read<QiblaCubit>().start(),
            isNoSensor: true,
          ),
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: AppDimens.spaceMD),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({
    required this.qiblaAngle,
    required this.bearing,
    this.accuracy,
  });

  final double qiblaAngle;
  final double bearing;
  final double? accuracy;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMD),
        child: Column(
          children: [
            const SizedBox(height: AppDimens.spaceLG),

            // Label atas
            Text(
              'Arahkan perangkat ke jarum hijau',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: AppDimens.spaceXL),

            // Kompas
            QiblaCompassWidget(
              qiblaAngle: qiblaAngle,
              accuracy: accuracy,
            ),

            const SizedBox(height: AppDimens.spaceXL),

            // Info panel
            QiblaInfoPanel(
              bearing: bearing,
              qiblaAngle: qiblaAngle,
            ),

            const SizedBox(height: AppDimens.spaceLG),

            // Label Kabah
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: AppDimens.spaceXS),
                Text(
                  'Kabah, Mekah Al-Mukarramah',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
