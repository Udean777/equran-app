import 'dart:async';

import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/detecting_location_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/core/widgets/section_header.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/jadwal_shalat_cubit.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/widgets/jadwal_shalat_header_card.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/widgets/jadwal_shalat_location_selector_sheet.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/widgets/jadwal_shalat_table.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/widgets/jadwal_shalat_today_card.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JadwalShalatPage extends StatelessWidget {
  const JadwalShalatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<JadwalShalatCubit>();
        unawaited(cubit.init());
        return cubit;
      },
      child: const _JadwalShalatView(),
    );
  }
}

class _JadwalShalatView extends StatelessWidget {
  const _JadwalShalatView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: LuxuryAppBar(
        title: 'Jadwal Shalat',
        actions: [
          BlocBuilder<JadwalShalatCubit, JadwalShalatState>(
            builder: (context, state) {
              if (state is! JadwalShalatSuccess) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.location_on_outlined),
                tooltip: 'Ganti lokasi',
                onPressed: () => _showLocationSheet(context),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<JadwalShalatCubit, JadwalShalatState>(
        listener: (context, state) {
          // Auto-show location selector jika GPS gagal detect lokasi
          if (state is JadwalShalatProvinsiLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) _showLocationSheet(context);
            });
          }
        },
        builder: (context, state) => switch (state) {
          JadwalShalatInitial() => const LoadingWidget(),
          JadwalShalatLoadingProvinsi() => const LoadingWidget(),
          JadwalShalatLoadingKabkota() => const LoadingWidget(),
          JadwalShalatLoadingJadwal() => const LoadingWidget(),
          JadwalShalatDetectingLocation() => const DetectingLocationWidget(),
          JadwalShalatProvinsiLoaded() => _LocationFallbackWidget(
            message: 'Lokasi tidak terdeteksi otomatis.',
            actionLabel: 'Pilih Lokasi Manual',
            onAction: () => _showLocationSheet(context),
          ),
          JadwalShalatKabkotaLoaded() => const LoadingWidget(),
          JadwalShalatFailure(:final failure) => ErrorStateWidget(
            message: failure.toUserMessage(),
            onRetry: () => unawaited(context.read<JadwalShalatCubit>().init()),
          ),
          JadwalShalatSuccess(:final jadwal, :final bulan, :final tahun) =>
            _JadwalShalatContent(
              jadwal: jadwal,
              bulan: bulan,
              tahun: tahun,
            ),
        },
      ),
    );
  }

  void _showLocationSheet(BuildContext context) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => BlocProvider.value(
          value: context.read<JadwalShalatCubit>(),
          child: const JadwalShalatLocationSelectorSheet(),
        ),
      ),
    );
  }
}

class _LocationFallbackWidget extends StatelessWidget {
  const _LocationFallbackWidget({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off_rounded,
              size: 56,
              color: Colors.grey,
            ),
            const SizedBox(height: AppDimens.spaceMD),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimens.spaceLG),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.location_on_rounded),
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _JadwalShalatContent extends StatelessWidget {
  const _JadwalShalatContent({
    required this.jadwal,
    required this.bulan,
    required this.tahun,
  });

  final JadwalShalat jadwal;
  final int bulan;
  final int tahun;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayEntry = jadwal.jadwal.where(
      (e) => e.tanggal == today.day,
    );
    final entry = todayEntry.isNotEmpty ? todayEntry.first : null;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
      children: [
        JadwalShalatHeaderCard(
          jadwal: jadwal,
          onChangeLocation: () => unawaited(
            showAppBottomSheet<void>(
              context,
              builder: (_) => BlocProvider.value(
                value: context.read<JadwalShalatCubit>(),
                child: const JadwalShalatLocationSelectorSheet(),
              ),
            ),
          ),
          onPrevBulan: () {
            final prevBulan = bulan == 1 ? 12 : bulan - 1;
            final prevTahun = bulan == 1 ? tahun - 1 : tahun;
            unawaited(
              context.read<JadwalShalatCubit>().changeBulan(
                prevBulan,
                prevTahun,
              ),
            );
          },
          onNextBulan: () {
            final nextBulan = bulan == 12 ? 1 : bulan + 1;
            final nextTahun = bulan == 12 ? tahun + 1 : tahun;
            unawaited(
              context.read<JadwalShalatCubit>().changeBulan(
                nextBulan,
                nextTahun,
              ),
            );
          },
        ),
        if (entry != null) JadwalShalatTodayCard(entry: entry),
        const SectionHeader(
          label: 'Jadwal Lengkap',
          icon: Icons.table_rows_rounded,
        ),
        JadwalShalatTable(
          entries: jadwal.jadwal,
          todayTanggalLengkap: entry?.tanggalLengkap ?? '',
        ),
      ],
    );
  }
}
