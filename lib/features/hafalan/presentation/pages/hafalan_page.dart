import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/widgets.dart';
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
        BlocProvider.value(value: getIt<HafalanCubit>()),
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
    return Scaffold(
      appBar: const LuxuryAppBar(title: 'Hafalan Al-Quran'),
      body: BlocListener<SuratListCubit, SuratListState>(
        listenWhen: (prev, next) =>
            prev is! SuratListSuccess && next is SuratListSuccess,
        listener: (context, state) {
          if (state is SuratListSuccess) {
            context.read<HafalanCubit>().setAllSurat(state.surats);
          }
        },
        child: BlocBuilder<HafalanCubit, HafalanState>(
          builder: (context, hafalanState) =>
              BlocBuilder<SuratListCubit, SuratListState>(
                builder: (context, suratState) {
                  if (hafalanState is HafalanLoading ||
                      suratState is SuratListLoading) {
                    return const LoadingWidget();
                  }
                  if (hafalanState is HafalanFailure) {
                    return ErrorStateWidget(
                      message: hafalanState.message,
                      onRetry: context.read<HafalanCubit>().load,
                    );
                  }
                  if (suratState is SuratListFailure) {
                    return ErrorStateWidget(
                      message: suratState.failure.toString(),
                      onRetry: context.read<SuratListCubit>().retry,
                    );
                  }
                  if (hafalanState is! HafalanSuccess ||
                      suratState is! SuratListSuccess) {
                    return const LoadingWidget();
                  }

                  return _HafalanContent(hafalanState: hafalanState);
                },
              ),
        ),
      ),
    );
  }
}

class _HafalanContent extends StatelessWidget {
  const _HafalanContent({required this.hafalanState});

  final HafalanSuccess hafalanState;

  @override
  Widget build(BuildContext context) {
    final juzGroups = hafalanState.juzGroups;
    final sortedJuz = hafalanState.sortedJuz;
    final currentStatusFilter = hafalanState.filter;

    return CustomScrollView(
      slivers: [
        // Stats card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceSM),
            child: HafalanStatsCard(stats: hafalanState.stats),
          ),
        ),

        // Sticky filter panel
        SliverPersistentHeader(
          pinned: true,
          delegate: _HafalanFilterDelegate(
            searchQuery: hafalanState.searchQuery,
            selectedJuz: hafalanState.selectedJuz,
            currentStatusFilter: currentStatusFilter,
            onSearchChanged: (val) =>
                context.read<HafalanCubit>().setSearchQuery(val),
            onJuzSelected: (juz) =>
                context.read<HafalanCubit>().setSelectedJuz(juz),
            onStatusFilterChanged: (filter) =>
                context.read<HafalanCubit>().setFilter(filter),
          ),
        ),

        // Content
        if (sortedJuz.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMD,
                vertical: AppDimens.spaceXL,
              ),
              child: EmptyStateWidget(
                message: 'Tidak ada surat yang sesuai.',
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == sortedJuz.length) {
                  return const SizedBox(height: AppDimens.spaceXL);
                }
                final juz = sortedJuz[index];
                return HafalanJuzSection(
                  juzNomor: juz,
                  hafalanList: juzGroups[juz]!,
                  progressJuz: hafalanState.stats.progressPerJuz[juz] ?? 0.0,
                );
              },
              childCount: sortedJuz.length + 1,
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sticky filter panel delegate
// ---------------------------------------------------------------------------

class _HafalanFilterDelegate extends SliverPersistentHeaderDelegate {
  const _HafalanFilterDelegate({
    required this.searchQuery,
    required this.selectedJuz,
    required this.currentStatusFilter,
    required this.onSearchChanged,
    required this.onJuzSelected,
    required this.onStatusFilterChanged,
  });

  final String searchQuery;
  final int? selectedJuz;
  final HafalanFilter currentStatusFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int?> onJuzSelected;
  final ValueChanged<HafalanFilter> onStatusFilterChanged;

  // Search bar + select dropdowns Row + padding
  static const double _height = 136;

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPinned = shrinkOffset > 0 || overlapsContent;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;

    // Options list for status hafalan filter
    final statusOptions = HafalanFilter.values.map((filter) {
      final label = switch (filter) {
        HafalanFilter.semua => 'Semua Status',
        HafalanFilter.sedangDihafal => 'Sedang Dihafal',
        HafalanFilter.sudahHafal => 'Sudah Hafal',
        HafalanFilter.perluMurajaah => "Perlu Muraja'ah",
      };
      final icon = switch (filter) {
        HafalanFilter.semua => Icons.layers_rounded,
        HafalanFilter.sedangDihafal => Icons.menu_book_rounded,
        HafalanFilter.sudahHafal => Icons.check_circle_rounded,
        HafalanFilter.perluMurajaah => Icons.alarm_rounded,
      };
      return AppSelectOption<HafalanFilter>(
        value: filter,
        label: label,
        icon: icon,
      );
    }).toList();

    // Options list for juz filter
    final juzOptions = <AppSelectOption<int?>>[
      const AppSelectOption<int?>(
        value: null,
        label: 'Semua Juz',
        icon: Icons.auto_stories_rounded,
      ),
      ...List.generate(30, (index) {
        final juzNum = index + 1;
        return AppSelectOption<int?>(
          value: juzNum,
          label: 'Juz $juzNum',
          icon: Icons.book_rounded,
        );
      }),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isPinned ? surfaceColor : bgColor,
        boxShadow: isPinned
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search bar — pakai AppSearchBar
          AppSearchBar(
            hint: 'Cari nama surat...',
            onChanged: onSearchChanged,
          ),

          // Custom Select dropdowns in a Row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePadding,
            ),
            child: Row(
              children: [
                // Filter status select
                Expanded(
                  child: AppSelect<HafalanFilter>(
                    title: 'Status Hafalan',
                    options: statusOptions,
                    selectedValue: currentStatusFilter,
                    leadingIcon: Icons.filter_list_rounded,
                    onChanged: onStatusFilterChanged,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSM),
                // Filter juz select
                Expanded(
                  child: AppSelect<int?>(
                    title: 'Pilih Juz',
                    options: juzOptions,
                    selectedValue: selectedJuz,
                    leadingIcon: Icons.auto_stories_rounded,
                    onChanged: onJuzSelected,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HafalanFilterDelegate oldDelegate) =>
      oldDelegate.searchQuery != searchQuery ||
      oldDelegate.selectedJuz != selectedJuz ||
      oldDelegate.currentStatusFilter != currentStatusFilter;
}
