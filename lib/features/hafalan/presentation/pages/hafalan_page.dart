import 'dart:async';

import 'package:equran_app/core/constants/juz_mapping.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
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
        BlocProvider(
          create: (_) {
            final cubit = getIt<HafalanCubit>();
            unawaited(cubit.load());
            return cubit;
          },
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hafalan Quran'),
      ),
      body: BlocBuilder<SuratListCubit, SuratListState>(
        builder: (context, suratState) {
          // Saat allSurat tersedia, kirim ke HafalanCubit untuk merge
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
    // filteredList sudah dihitung di cubit — tidak ada komputasi di build()
    final filtered = state.filteredList;

    return Column(
      children: [
        // Stats card
        HafalanStatsCard(stats: state.stats),

        // Filter chips
        _FilterChips(currentFilter: state.filter),

        // Error snackbar inline
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMD,
              vertical: AppDimens.spaceXS,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppDimens.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusSM),
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
    // Kelompokkan per juz
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
  const _FilterChips({required this.currentFilter});

  final HafalanFilter currentFilter;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical: AppDimens.spaceSM,
      ),
      child: Row(
        children: HafalanFilter.values.map((filter) {
          final isSelected = filter == currentFilter;
          return Padding(
            padding: const EdgeInsets.only(right: AppDimens.spaceXS),
            child: FilterChip(
              label: Text(_filterLabel(filter)),
              selected: isSelected,
              onSelected: (_) =>
                  context.read<HafalanCubit>().setFilter(filter),
              selectedColor: AppColors.primary.withValues(alpha: 0.15),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : null,
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _filterLabel(HafalanFilter filter) {
    switch (filter) {
      case HafalanFilter.semua:
        return 'Semua';
      case HafalanFilter.sedangDihafal:
        return 'Sedang Dihafal';
      case HafalanFilter.sudahHafal:
        return 'Sudah Hafal';
      case HafalanFilter.perluMurajaah:
        return "Perlu Muraja'ah";
    }
  }
}
