import 'dart:async';

import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/context_ext.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/qibla/presentation/providers.dart';
import 'package:equran_app/features/qibla/presentation/viewmodels/qibla_state.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_compass_widget.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_error_widget.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_how_to_card.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_info_panel.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_loading_view.dart';
import 'package:equran_app/features/qibla/presentation/widgets/qibla_tip_card.dart';
import 'package:equran_app/features/quran_reminder/presentation/widgets/streak_badge_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QiblaPage extends ConsumerStatefulWidget {
  const QiblaPage({super.key});

  @override
  ConsumerState<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends ConsumerState<QiblaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(qiblaViewModelProvider.notifier).start());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(qiblaViewModelProvider);

    return Scaffold(
      drawer: const AppDrawer(streakBadge: StreakBadgeSlot()),
      appBar: LuxuryAppBar(
        title: 'Qibla Finder',
        actions: [
          if (state is QiblaLoaded)
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                color: context.primaryActionColor,
              ),
              tooltip: 'Refresh',
              onPressed: () =>
                  unawaited(ref.read(qiblaViewModelProvider.notifier).start()),
            ),
        ],
      ),
      body: switch (state) {
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
          onRetry: () =>
              unawaited(ref.read(qiblaViewModelProvider.notifier).start()),
          isNoSensor: true,
        ),
        QiblaError(:final message) => QiblaErrorWidget(
          message: message,
          onRetry: () =>
              unawaited(ref.read(qiblaViewModelProvider.notifier).start()),
        ),
      },
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePadding,
        vertical: AppDimens.spaceLG,
      ),
      child: Column(
        children: [
          Text(
            'Hadapkan diri Anda ke arah jarum kompas',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.textTertiaryColor,
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
