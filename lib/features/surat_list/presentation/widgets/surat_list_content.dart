import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/widgets.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart';
import 'package:equran_app/features/surat_list/presentation/widgets/surat_card.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Sliver content untuk daftar surat — filter chips + list surat.
class SuratListContent extends StatelessWidget {
  const SuratListContent({
    required this.surats,
    required this.suratProgressMap,
    required this.activeFilter,
    required this.onFilterChanged,
    super.key,
  });

  final List<Surat> surats;
  final Map<int, double> suratProgressMap;
  final SuratCompletionFilter activeFilter;
  final ValueChanged<SuratCompletionFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                onFilterChanged: onFilterChanged,
                isDark: isDark,
              ),
            );
          }

          if (filteredSurats.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXXL),
              child: EmptyStateWidget(
                message: activeFilter == SuratCompletionFilter.completed
                    ? 'Belum ada surat yang selesai dibaca'
                    : (activeFilter == SuratCompletionFilter.incomplete
                          ? 'Belum ada surat yang sedang dibaca'
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
            // Tombol play hanya muncul jika semua ayat sudah dibaca
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

// ---------------------------------------------------------------------------
// Filter row — custom select selector
// ---------------------------------------------------------------------------

class _SuratFilterRow extends StatelessWidget {
  const _SuratFilterRow({
    required this.allCount,
    required this.completedCount,
    required this.incompleteCount,
    required this.activeFilter,
    required this.onFilterChanged,
    required this.isDark,
  });

  final int allCount;
  final int completedCount;
  final int incompleteCount;
  final SuratCompletionFilter activeFilter;
  final ValueChanged<SuratCompletionFilter> onFilterChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final statusOptions = [
      AppSelectOption<SuratCompletionFilter>(
        value: SuratCompletionFilter.all,
        label: 'Semua ($allCount)',
        icon: Icons.layers_rounded,
      ),
      AppSelectOption<SuratCompletionFilter>(
        value: SuratCompletionFilter.incomplete,
        label: 'Sedang Dibaca ($incompleteCount)',
        icon: Icons.play_circle_outline_rounded,
      ),
      AppSelectOption<SuratCompletionFilter>(
        value: SuratCompletionFilter.completed,
        label: 'Selesai ($completedCount)',
        icon: Icons.check_circle_rounded,
      ),
    ];

    return AppSelect<SuratCompletionFilter>(
      title: 'Filter Status Membaca',
      options: statusOptions,
      selectedValue: activeFilter,
      leadingIcon: Icons.filter_list_rounded,
      onChanged: onFilterChanged,
    );
  }
}
