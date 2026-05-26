import 'dart:async';

import 'package:equran_app/core/constants/juz_mapping.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_juz_section.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_stats_card.dart';
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HafalanPage extends StatelessWidget {
  const HafalanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // HafalanCubit adalah @lazySingleton — pakai .value agar tidak di-close
        BlocProvider.value(
          value: () {
            final cubit = getIt<HafalanCubit>();
            unawaited(cubit.load());
            return cubit;
          }(),
        ),
        BlocProvider(
          create: (_) {
            final cubit = getIt<SuratListCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: const _HafalanView(),
    );
  }
}

class _HafalanView extends StatelessWidget {
  const _HafalanView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final iconColor = isDark ? AppColors.onSurfaceDark : AppColors.textPrimary;

    return Scaffold(
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
              'Hafalan Quran',
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
      body: BlocBuilder<SuratListCubit, SuratListState>(
        builder: (context, suratState) {
          if (suratState is SuratListSuccess) {
            context.read<HafalanCubit>().setAllSurat(suratState.surats);
          }

          return BlocBuilder<HafalanCubit, HafalanState>(
            builder: (context, hafalanState) => switch (hafalanState) {
              HafalanInitial() => const LoadingWidget(),
              HafalanLoading() => const LoadingWidget(),
              HafalanFailure(:final message) => ErrorStateWidget(
                message: message,
                onRetry: () => context.read<HafalanCubit>().load(),
              ),
              HafalanSuccess() => _HafalanContent(state: hafalanState),
            },
          );
        },
      ),
    );
  }
}

class _HafalanContent extends StatelessWidget {
  const _HafalanContent({required this.state});

  final HafalanSuccess state;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = state.filteredList;

    return Column(
      children: [
        HafalanStatsCard(stats: state.stats),

        // Filter chips
        _FilterChips(currentFilter: state.filter, isDark: isDark),

        // Error inline
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.pagePadding,
              AppDimens.spaceXS,
              AppDimens.pagePadding,
              AppDimens.spaceXS,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppDimens.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 16,
                  ),
                  const SizedBox(width: AppDimens.spaceXS),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // List per juz
        Expanded(
          child: filtered.isEmpty
              ? const EmptyStateWidget(
                  message: 'Belum ada hafalan dengan filter ini.',
                )
              : _HafalanJuzList(
                  hafalanList: filtered,
                  progressPerJuz: state.stats.progressPerJuz,
                ),
        ),
      ],
    );
  }
}

class _HafalanJuzList extends StatelessWidget {
  const _HafalanJuzList({
    required this.hafalanList,
    required this.progressPerJuz,
  });

  final List<HafalanSurat> hafalanList;
  final Map<int, double> progressPerJuz;

  @override
  Widget build(BuildContext context) {
    final byJuz = <int, List<HafalanSurat>>{};
    for (final h in hafalanList) {
      final juz = kJuzMapping[h.suratNomor] ?? 1;
      byJuz.putIfAbsent(juz, () => []).add(h);
    }
    final juzKeys = byJuz.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLG),
      itemCount: juzKeys.length,
      itemBuilder: (context, index) {
        final juz = juzKeys[index];
        final suratDiJuz = byJuz[juz]!;
        final progressJuz = progressPerJuz[juz] ?? 0.0;
        return HafalanJuzSection(
          juzNomor: juz,
          hafalanList: suratDiJuz,
          progressJuz: progressJuz,
        );
      },
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.currentFilter,
    required this.isDark,
  });

  final HafalanFilter currentFilter;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceSM,
        AppDimens.pagePadding,
        AppDimens.spaceSM,
      ),
      child: Row(
        children: HafalanFilter.values.map((filter) {
          final isSelected = filter == currentFilter;
          return Padding(
            padding: const EdgeInsets.only(right: AppDimens.spaceXS),
            child: GestureDetector(
              onTap: () =>
                  context.read<HafalanCubit>().setFilter(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMD,
                  vertical: AppDimens.spaceXS + 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.primaryLight : AppColors.primary)
                      : (isDark
                          ? AppColors.surfaceDarkVariant
                          : AppColors.surfaceVariant),
                  borderRadius:
                      BorderRadius.circular(AppDimens.radiusFull),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark
                            ? AppColors.outlineDark
                            : AppColors.outline),
                  ),
                ),
                child: Text(
                  _filterLabel(filter),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: isSelected
                        ? AppColors.onPrimary
                        : (isDark
                            ? AppColors.onSurfaceDarkVariant
                            : AppColors.textSecondary),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _filterLabel(HafalanFilter filter) => switch (filter) {
    HafalanFilter.semua => 'Semua',
    HafalanFilter.sedangDihafal => 'Sedang Dihafal',
    HafalanFilter.sudahHafal => 'Sudah Hafal',
    HafalanFilter.perluMurajaah => "Perlu Muraja'ah",
  };
}
