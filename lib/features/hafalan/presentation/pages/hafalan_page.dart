import 'dart:async';

import 'package:equran_app/core/constants/juz_mapping.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/empty_state_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
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
    return Scaffold(
      appBar: const LuxuryAppBar(title: 'Hafalan'),
      body: BlocBuilder<HafalanCubit, HafalanState>(
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
    );
  }
}

class _HafalanContent extends StatelessWidget {
  const _HafalanContent({required this.hafalanState});

  final HafalanSuccess hafalanState;

  @override
  Widget build(BuildContext context) {
    final hafalanList = hafalanState.hafalanList;
    final stats = hafalanState.stats;

    if (hafalanList.isEmpty) {
      return const EmptyStateWidget(
        message: 'Belum ada hafalan.\nMulai dari halaman detail surah.',
      );
    }

    // Group by juz menggunakan kJuzMapping
    final juzGroups = <int, List<HafalanSurat>>{};
    for (final hafalan in hafalanList) {
      final juz = kJuzMapping[hafalan.suratNomor] ?? 1;
      juzGroups.putIfAbsent(juz, () => []).add(hafalan);
    }
    final sortedJuz = juzGroups.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
      children: [
        HafalanStatsCard(stats: stats),
        ...sortedJuz.map(
          (juz) => HafalanJuzSection(
            juzNomor: juz,
            hafalanList: juzGroups[juz]!,
            progressJuz: stats.progressPerJuz[juz] ?? 0.0,
          ),
        ),
      ],
    );
  }
}
