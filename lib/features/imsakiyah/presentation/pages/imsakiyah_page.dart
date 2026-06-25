import 'dart:async';

import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/detecting_location_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/core/widgets/luxury_app_bar.dart';
import 'package:equran_app/core/widgets/section_header.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/presentation/providers.dart';
import 'package:equran_app/features/imsakiyah/presentation/widgets/imsak_alarm_toggle_card.dart';
import 'package:equran_app/features/imsakiyah/presentation/widgets/imsakiyah_header_card.dart';
import 'package:equran_app/features/imsakiyah/presentation/widgets/imsakiyah_table.dart';
import 'package:equran_app/features/imsakiyah/presentation/widgets/imsakiyah_today_card.dart';
import 'package:equran_app/features/imsakiyah/presentation/widgets/location_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImsakiyahPage extends ConsumerStatefulWidget {
  const ImsakiyahPage({super.key});

  @override
  ConsumerState<ImsakiyahPage> createState() => _ImsakiyahPageState();
}

class _ImsakiyahPageState extends ConsumerState<ImsakiyahPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(imsakiyahViewModelProvider.notifier).init());
      unawaited(ref.read(imsakAlarmViewModelProvider.notifier).load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(imsakiyahViewModelProvider);

    return Scaffold(
      appBar: LuxuryAppBar(
        title: 'Imsakiyah',
        actions: [
          if (state is ImsakiyahSuccess)
            IconButton(
              icon: const Icon(Icons.location_on_outlined),
              tooltip: 'Ganti lokasi',
              onPressed: _showLocationSheet,
            ),
        ],
      ),
      body: switch (state) {
        ImsakiyahInitial() => const LoadingWidget(),
        ImsakiyahLoadingProvinsi() => const LoadingWidget(),
        ImsakiyahLoadingKabkota() => const LoadingWidget(),
        ImsakiyahLoadingJadwal() => const LoadingWidget(),
        ImsakiyahDetectingLocation() => const DetectingLocationWidget(),
        ImsakiyahProvinsiLoaded() => const LoadingWidget(),
        ImsakiyahKabkotaLoaded() => const LoadingWidget(),
        ImsakiyahFailure(:final failure) => ErrorStateWidget(
          message: failure.toUserMessage(),
          onRetry: () =>
              unawaited(ref.read(imsakiyahViewModelProvider.notifier).retry()),
        ),
        ImsakiyahSuccess(:final jadwal) => _ImsakiyahContent(jadwal: jadwal),
      },
    );
  }

  void _showLocationSheet() {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => const ImsakiyahLocationSelectorSheet(),
      ),
    );
  }
}

class _ImsakiyahContent extends StatelessWidget {
  const _ImsakiyahContent({required this.jadwal});

  final Imsakiyah jadwal;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayTanggal = today.day;
    final todayEntry = jadwal.imsakiyah.where(
      (e) => e.tanggal == todayTanggal,
    );
    final entry = todayEntry.isNotEmpty ? todayEntry.first : null;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
      children: [
        ImsakiyahHeaderCard(
          jadwal: jadwal,
          onChangeLocation: () => unawaited(
            showAppBottomSheet<void>(
              context,
              builder: (_) => const ImsakiyahLocationSelectorSheet(),
            ),
          ),
        ),
        if (entry != null)
          ImsakiyahTodayCard(entry: entry, tanggal: todayTanggal),
        if (entry != null) ...[
          const SectionHeader(
            label: 'Alarm Imsak',
            icon: Icons.alarm_rounded,
          ),
          ImsakAlarmToggleCard(todayEntry: entry),
        ],
        const SectionHeader(
          label: 'Jadwal Lengkap',
          icon: Icons.table_rows_rounded,
        ),
        ImsakiyahTable(
          entries: jadwal.imsakiyah,
          todayTanggal: todayTanggal,
        ),
      ],
    );
  }
}
