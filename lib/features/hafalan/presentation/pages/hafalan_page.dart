import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/app_search_bar.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
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
                  progressJuz:
                      hafalanState.stats.progressPerJuz[juz] ?? 0.0,
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

  // Search bar + status chips + juz chips + padding
  static const double _height = 180;

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
    final chipBgColor = isDark ? AppColors.surfaceDarkVariant : Colors.grey[100]!;
    final chipBorderColor = isDark ? AppColors.outlineDark : Colors.grey[300]!;
    final chipLabelColor = isDark ? AppColors.onSurfaceDark : Colors.grey[700]!;

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

          // Status chips
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePadding,
              ),
              children: HafalanFilter.values.map((filter) {
                final isSelected = filter == currentStatusFilter;
                final label = switch (filter) {
                  HafalanFilter.semua => 'Semua',
                  HafalanFilter.sedangDihafal => 'Sedang Dihafal',
                  HafalanFilter.sudahHafal => 'Sudah Hafal',
                  HafalanFilter.perluMurajaah => "Perlu Muraja'ah",
                };
                return Padding(
                  padding: const EdgeInsets.only(right: AppDimens.spaceXS),
                  child: _FilterChip(
                    label: label,
                    isSelected: isSelected,
                    isDark: isDark,
                    chipBgColor: chipBgColor,
                    chipBorderColor: chipBorderColor,
                    chipLabelColor: chipLabelColor,
                    onSelected: () => onStatusFilterChanged(filter),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppDimens.spaceXS),

          // Juz chips
          SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePadding,
              ),
              itemCount: 31, // "Semua Juz" + Juz 1–30
              itemBuilder: (context, index) {
                final isSemua = index == 0;
                final juzNum = isSemua ? null : index;
                final isSelected = selectedJuz == juzNum;
                final label = isSemua ? 'Semua Juz' : 'Juz $index';

                return Padding(
                  padding: const EdgeInsets.only(right: AppDimens.spaceXS),
                  child: _FilterChip(
                    label: label,
                    isSelected: isSelected,
                    isDark: isDark,
                    chipBgColor: chipBgColor,
                    chipBorderColor: chipBorderColor,
                    chipLabelColor: chipLabelColor,
                    onSelected: () => onJuzSelected(juzNum),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppDimens.spaceXS),
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

// ---------------------------------------------------------------------------
// Reusable filter chip
// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.chipBgColor,
    required this.chipBorderColor,
    required this.chipLabelColor,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final bool isDark;
  final Color chipBgColor;
  final Color chipBorderColor;
  final Color chipLabelColor;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final selectedColor = isDark ? AppColors.primaryLighter : AppColors.primary;
    final selectedLabelColor = isDark ? AppColors.backgroundDark : AppColors.onPrimary;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? selectedLabelColor : chipLabelColor,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: selectedColor,
      backgroundColor: chipBgColor,
      checkmarkColor: selectedLabelColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        side: BorderSide(
          color: isSelected ? selectedColor : chipBorderColor,
        ),
      ),
      onSelected: (_) => onSelected(),
    );
  }
}
