import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/widgets.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_filter.dart';
import 'package:equran_app/features/hafalan/presentation/providers.dart';
import 'package:equran_app/features/hafalan/presentation/viewmodels/hafalan_list_viewmodel.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_juz_section.dart';
import 'package:equran_app/features/hafalan/presentation/widgets/hafalan_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HafalanPage extends ConsumerWidget {
  const HafalanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listNotifier = ref.read(hafalanListViewModelProvider.notifier);
    final listState = ref.watch(hafalanListViewModelProvider);

    return Scaffold(
      appBar: const LuxuryAppBar(title: 'Hafalan Al-Quran'),
      body: switch (listState) {
        HafalanListLoading() => const LoadingWidget(),
        HafalanListFailure(:final message) => ErrorStateWidget(
          message: message,
          onRetry: listNotifier.load,
        ),
        HafalanListSuccess() => _HafalanContent(
          hafalanState: listState,
          listNotifier: listNotifier,
        ),
        _ => const LoadingWidget(),
      },
    );
  }
}

class _HafalanContent extends StatelessWidget {
  const _HafalanContent({
    required this.hafalanState,
    required this.listNotifier,
  });

  final HafalanListSuccess hafalanState;
  final HafalanListViewModel listNotifier;

  @override
  Widget build(BuildContext context) {
    final juzGroups = hafalanState.juzGroups;
    final sortedJuz = hafalanState.sortedJuz;
    final currentStatusFilter = hafalanState.filter;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceSM),
            child: HafalanStatsCard(stats: hafalanState.stats),
          ),
        ),

        SliverPersistentHeader(
          pinned: true,
          delegate: _HafalanFilterDelegate(
            searchQuery: hafalanState.searchQuery,
            selectedJuz: hafalanState.selectedJuz,
            currentStatusFilter: currentStatusFilter,
            onSearchChanged: listNotifier.setSearchQuery,
            onJuzSelected: listNotifier.setSelectedJuz,
            onStatusFilterChanged: listNotifier.setFilter,
          ),
        ),

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
    final isDark = context.isDark;
    final isPinned = shrinkOffset > 0 || overlapsContent;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.background;

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
          AppSearchBar(
            hint: 'Cari nama surat...',
            onChanged: onSearchChanged,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePadding,
            ),
            child: Row(
              children: [
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
