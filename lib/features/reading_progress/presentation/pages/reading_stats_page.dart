import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_streak_cubit.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';
import 'package:equran_app/features/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/juz_progress_section.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/reading_heatmap.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/reading_stats_header_card.dart';
import 'package:equran_app/features/reading_progress/presentation/widgets/top_surat_section.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadingStatsPage extends StatelessWidget {
  const ReadingStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<ReadingProgressCubit>();
        unawaited(cubit.load());
        return cubit;
      },
      child: const _ReadingStatsView(),
    );
  }
}

class _ReadingStatsView extends StatelessWidget {
  const _ReadingStatsView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final iconColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: AppDimens.appBarHeightLG,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Statistik Baca',
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
      ),
      body: BlocBuilder<ReadingProgressCubit, ReadingProgressState>(
        builder: (context, state) {
          return state.when(
            initial: () => const LoadingWidget(),
            loading: () => const LoadingWidget(),
            failure: (message) => ErrorStateWidget(
              message: message,
              onRetry: () => context.read<ReadingProgressCubit>().load(),
            ),
            success: (stats) => _SuccessView(stats: stats),
          );
        },
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.stats});

  final ReadingStats stats;

  @override
  Widget build(BuildContext context) {
    final streak = context.watch<QuranStreakCubit>().state;

    if (stats.isEmpty) {
      return _EmptyView(streak: streak);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => context.read<ReadingProgressCubit>().load(),
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
        children: [
          ReadingStatsHeaderCard(stats: stats, streak: streak),
          ReadingHeatmap(last90Days: stats.last90Days),
          JuzProgressSection(progressPerJuz: stats.progressPerJuz),
          if (stats.topSurat.isNotEmpty)
            TopSuratSection(topSurat: stats.topSurat),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;
    final subColor = isDark
        ? AppColors.onSurfaceDarkVariant
        : AppColors.textSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDarkVariant
                    : AppColors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColors.outlineDark
                      : AppColors.outlineVariant,
                ),
              ),
              child: Icon(
                Icons.menu_book_outlined,
                size: 36,
                color: isDark ? AppColors.primaryLighter : AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimens.spaceLG),
            Text(
              'Belum Ada Data',
              style: AppTypography.serifHeadingSmall.copyWith(
                color: textColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: AppDimens.spaceSM),
            Text(
              'Mulai membaca Al-Quran untuk melihat statistik progress kamu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subColor,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            if (streak > 0) ...[
              const SizedBox(height: AppDimens.spaceLG),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMD,
                  vertical: AppDimens.spaceSM,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDarkVariant
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.gold,
                      size: 18,
                    ),
                    const SizedBox(width: AppDimens.spaceXS),
                    Text(
                      '$streak hari streak',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.primaryLighter
                            : AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
