import 'package:equran_app/core/domain/entities/surat.dart';
import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/widgets.dart';
import 'package:equran_app/features/surat_list/presentation/providers.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/surat_card.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SuratListContent extends ConsumerWidget {
  const SuratListContent({
    required this.surats,
    required this.suratProgressMap,
    super.key,
  });

  final List<Surat> surats;
  final Map<int, double> suratProgressMap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(suratListViewModelProvider);
    final notifier = ref.read(suratListViewModelProvider.notifier);
    final activeFilter = state is SuratListSuccess
        ? state.activeFilter
        : SuratCompletionFilter.all;

    final allCount = surats.length;
    final completedCount = surats
        .where((s) => suratProgressMap[s.nomor] == 1.0)
        .length;
    final incompleteCount = surats.where((s) {
      final progress = suratProgressMap[s.nomor];
      return progress != null && progress > 0.0 && progress < 1.0;
    }).length;

    final filteredSurats = surats.where((s) {
      final progress = suratProgressMap[s.nomor];
      final isCompleted = progress == 1.0;
      final isInProgress = progress != null && progress > 0.0 && progress < 1.0;
      return switch (activeFilter) {
        SuratCompletionFilter.all => true,
        SuratCompletionFilter.incomplete => isInProgress,
        SuratCompletionFilter.completed => isCompleted,
      };
    }).toList();

    final listLength = filteredSurats.isEmpty ? 2 : filteredSurats.length + 1;

    return SliverPadding(
      padding: const EdgeInsets.only(
        left: AppDimens.pagePadding,
        right: AppDimens.pagePadding,
        bottom: AppDimens.spaceLG,
      ),
      sliver: SliverList.builder(
        itemCount: listLength,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceMD),
              child: _SuratFilterRow(
                allCount: allCount,
                completedCount: completedCount,
                incompleteCount: incompleteCount,
                activeFilter: activeFilter,
                onFilterChanged: notifier.setFilter,
              ),
            );
          }

          if (filteredSurats.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXXL),
              child: EmptyStateWidget(
                message: activeFilter == SuratCompletionFilter.completed
                    ? l10n.suratCompletedEmpty
                    : (activeFilter == SuratCompletionFilter.incomplete
                          ? l10n.suratInProgressEmpty
                          : l10n.emptySearch),
              ),
            );
          }

          final surat = filteredSurats[i - 1];
          final progress = suratProgressMap[surat.nomor];
          final isCompleted = progress == 1.0;
          return SuratCard(
            key: ValueKey(surat.nomor),
            surat: surat,
            onTap: () => context.push(AppRoutes.surat(surat.nomor)),
            onPlayTap: isCompleted
                ? () => context.push(AppRoutes.suratAutoPlay(surat.nomor))
                : null,
            scrollPercent: progress,
          );
        },
      ),
    );
  }
}

class _SuratFilterRow extends StatelessWidget {
  const _SuratFilterRow({
    required this.allCount,
    required this.completedCount,
    required this.incompleteCount,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final int allCount;
  final int completedCount;
  final int incompleteCount;
  final SuratCompletionFilter activeFilter;
  final ValueChanged<SuratCompletionFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusOptions = [
      AppSelectOption<SuratCompletionFilter>(
        value: SuratCompletionFilter.all,
        label: l10n.filterAll(allCount),
        icon: Icons.layers_rounded,
      ),
      AppSelectOption<SuratCompletionFilter>(
        value: SuratCompletionFilter.incomplete,
        label: l10n.filterInProgress(incompleteCount),
        icon: Icons.play_circle_outline_rounded,
      ),
      AppSelectOption<SuratCompletionFilter>(
        value: SuratCompletionFilter.completed,
        label: l10n.filterCompleted(completedCount),
        icon: Icons.check_circle_rounded,
      ),
    ];

    return AppSelect<SuratCompletionFilter>(
      title: l10n.filterReadingStatus,
      options: statusOptions,
      selectedValue: activeFilter,
      leadingIcon: Icons.filter_list_rounded,
      onChanged: onFilterChanged,
    );
  }
}
