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
import 'package:equran_app/features/jadwal_shalat/presentation/providers.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/widgets/jadwal_shalat_header_card.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/widgets/jadwal_shalat_location_selector_sheet.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/widgets/jadwal_shalat_table.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/widgets/jadwal_shalat_today_card.dart';
import 'package:equran_app/features/quran_reminder/presentation/widgets/streak_badge_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JadwalShalatPage extends ConsumerStatefulWidget {
  const JadwalShalatPage({super.key});

  @override
  ConsumerState<JadwalShalatPage> createState() => _JadwalShalatPageState();
}

class _JadwalShalatPageState extends ConsumerState<JadwalShalatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(jadwalShalatViewModelProvider.notifier).init());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jadwalShalatViewModelProvider);

    return Scaffold(
      drawer: const AppDrawer(streakBadge: StreakBadgeSlot()),
      appBar: LuxuryAppBar(
        title: 'Jadwal Shalat',
        actions: [
          if (state is JadwalShalatSuccess)
            IconButton(
              icon: const Icon(Icons.location_on_outlined),
              tooltip: 'Ganti lokasi',
              onPressed: _showLocationSheet,
            ),
        ],
      ),
      body: JadwalShalatBody(state: state),
    );
  }

  void _showLocationSheet() {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => const JadwalShalatLocationSelectorSheet(),
      ),
    );
  }
}

class JadwalShalatBody extends ConsumerWidget {
  const JadwalShalatBody({required this.state, super.key});

  final JadwalShalatState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<JadwalShalatState>(
      jadwalShalatViewModelProvider,
      (prev, next) {
        if (next is JadwalShalatProvinsiLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              unawaited(
                showAppBottomSheet<void>(
                  context,
                  builder: (_) => const JadwalShalatLocationSelectorSheet(),
                ),
              );
            }
          });
        }
      },
    );

    return switch (state) {
      JadwalShalatInitial() => const LoadingWidget(),
      JadwalShalatLoadingProvinsi() => const LoadingWidget(),
      JadwalShalatLoadingKabkota() => const LoadingWidget(),
      JadwalShalatLoadingJadwal() => const LoadingWidget(),
      JadwalShalatDetectingLocation() => const DetectingLocationWidget(),
      JadwalShalatProvinsiLoaded() => _LocationFallbackWidget(
        message: 'Lokasi tidak terdeteksi otomatis.',
        actionLabel: 'Pilih Lokasi Manual',
        onAction: () {
          unawaited(
            showAppBottomSheet<void>(
              context,
              builder: (_) => const JadwalShalatLocationSelectorSheet(),
            ),
          );
        },
      ),
      JadwalShalatKabkotaLoaded() => const LoadingWidget(),
      JadwalShalatFailure(:final failure) => ErrorStateWidget(
        message: failure.toUserMessage(),
        onRetry: () => unawaited(
          ref.read(jadwalShalatViewModelProvider.notifier).init(),
        ),
      ),
      JadwalShalatSuccess(:final jadwal, :final bulan, :final tahun) =>
        _JadwalShalatContent(
          jadwal: jadwal,
          bulan: bulan,
          tahun: tahun,
        ),
    };
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

class _JadwalShalatContent extends ConsumerWidget {
  const _JadwalShalatContent({
    required this.jadwal,
    required this.bulan,
    required this.tahun,
  });

  final JadwalShalat jadwal;
  final int bulan;
  final int tahun;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = jadwal.entryByTanggal(DateTime.now().day);
    final vm = ref.read(jadwalShalatViewModelProvider.notifier);

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
      children: [
        JadwalShalatHeaderCard(
          jadwal: jadwal,
          onChangeLocation: () => unawaited(
            showAppBottomSheet<void>(
              context,
              builder: (_) => const JadwalShalatLocationSelectorSheet(),
            ),
          ),
          onPrevBulan: () => unawaited(vm.prevBulan()),
          onNextBulan: () => unawaited(vm.nextBulan()),
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
