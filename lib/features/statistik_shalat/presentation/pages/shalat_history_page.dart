import 'dart:async';

import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/features/statistik_shalat/domain/entities/shalat_log.dart';
import 'package:equran_app/features/statistik_shalat/presentation/providers.dart';
import 'package:equran_app/features/statistik_shalat/presentation/viewmodels/statistik_shalat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ShalatHistoryPage extends ConsumerStatefulWidget {
  const ShalatHistoryPage({super.key});

  @override
  ConsumerState<ShalatHistoryPage> createState() => _ShalatHistoryPageState();
}

class _ShalatHistoryPageState extends ConsumerState<ShalatHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(statistikShalatViewModelProvider.notifier).load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statistikShalatViewModelProvider);

    return Scaffold(
      appBar: LuxuryAppBar(
        title: 'Riwayat Rekap',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
      ),
      body: state.when(
        initial: () => const LoadingWidget(),
        loading: () => const LoadingWidget(),
        failure: (message) => ErrorStateWidget(
          message: message,
          onRetry: ref.read(statistikShalatViewModelProvider.notifier).load,
        ),
        success: (today, stats) => _HistoryContent(stats: stats),
      ),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({required this.stats});

  final ShalatStats stats;

  @override
  Widget build(BuildContext context) {
    // Balik urutan agar yang terbaru di atas
    final dailyStats = stats.dailyStats.reversed.toList();

    if (dailyStats.isEmpty) {
      return const Center(
        child: Text('Belum ada riwayat rekap shalat.'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      itemCount: dailyStats.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spaceSM),
      itemBuilder: (context, index) {
        final dayStat = dailyStats[index];
        return _HistoryCard(dayStats: dayStat);
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.dayStats});

  final ShalatDayStats dayStats;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    String title;
    IconData icon;
    Color iconColor;

    if (dayStats.isSempurna) {
      title = '5 Waktu Tuntas!';
      icon = Icons.verified_rounded;
      iconColor = AppColors.success;
    } else if (dayStats.jumlahQadha > 2) {
      title = 'Banyak Qadha';
      icon = Icons.info_rounded;
      iconColor = AppColors.warning;
    } else if (dayStats.jumlahShalat == 0) {
      title = 'Tidak Ada Catatan';
      icon = Icons.warning_rounded;
      iconColor = AppColors.error;
    } else {
      title = '${dayStats.jumlahTepatWaktu} Waktu Tercatat';
      icon = Icons.stars_rounded;
      iconColor = AppColors.primary;
    }

    final dateObj = DateTime.parse(dayStats.date);
    final dateStr = DateFormat('dd MMM yyyy', 'id_ID').format(dateObj);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: isDark ? AppColors.outlineDark : AppColors.outlineVariant,
        ),
      ),
      padding: const EdgeInsets.all(AppDimens.spaceMD),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceSM),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: AppDimens.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
            child: Text(
              '${dayStats.jumlahTepatWaktu}/5',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
