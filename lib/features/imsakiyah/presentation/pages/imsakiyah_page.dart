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
import 'package:equran_app/features/imsakiyah/presentation/cubit/imsak_alarm_cubit.dart';
import 'package:equran_app/features/imsakiyah/presentation/cubit/imsakiyah_cubit.dart';
import 'package:equran_app/features/imsakiyah/presentation/widgets/imsak_alarm_toggle_card.dart';
import 'package:equran_app/features/imsakiyah/presentation/widgets/imsakiyah_header_card.dart';
import 'package:equran_app/features/imsakiyah/presentation/widgets/imsakiyah_table.dart';
import 'package:equran_app/features/imsakiyah/presentation/widgets/imsakiyah_today_card.dart';
import 'package:equran_app/features/imsakiyah/presentation/widgets/location_selector_sheet.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImsakiyahPage extends StatelessWidget {
  const ImsakiyahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = getIt<ImsakiyahCubit>();
            unawaited(cubit.init());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = getIt<ImsakAlarmCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: const _ImsakiyahView(),
    );
  }
}

class _ImsakiyahView extends StatelessWidget {
  const _ImsakiyahView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LuxuryAppBar(
        title: 'Imsakiyah',
        actions: [
          BlocBuilder<ImsakiyahCubit, ImsakiyahState>(
            builder: (context, state) {
              final hasLocation = state is ImsakiyahSuccess;
              if (!hasLocation) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.location_on_outlined),
                tooltip: 'Ganti lokasi',
                onPressed: () => _showLocationSheet(context),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ImsakiyahCubit, ImsakiyahState>(
        builder: (context, state) => switch (state) {
          ImsakiyahInitial() => const LoadingWidget(),
          ImsakiyahLoadingProvinsi() => const LoadingWidget(),
          ImsakiyahLoadingKabkota() => const LoadingWidget(),
          ImsakiyahLoadingJadwal() => const LoadingWidget(),
          ImsakiyahDetectingLocation() => const DetectingLocationWidget(),
          ImsakiyahProvinsiLoaded() => const LoadingWidget(),
          ImsakiyahKabkotaLoaded() => const LoadingWidget(),
          ImsakiyahFailure(:final failure) => ErrorStateWidget(
            message: failure.toUserMessage(),
            onRetry: () => unawaited(context.read<ImsakiyahCubit>().init()),
          ),
          ImsakiyahSuccess(:final jadwal) => _ImsakiyahContent(jadwal: jadwal),
        },
      ),
    );
  }

  void _showLocationSheet(BuildContext context) {
    unawaited(
      showAppBottomSheet<void>(
        context,
        builder: (_) => BlocProvider.value(
          value: context.read<ImsakiyahCubit>(),
          child: const LocationSelectorSheet(),
        ),
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
              builder: (_) => BlocProvider.value(
                value: context.read<ImsakiyahCubit>(),
                child: const LocationSelectorSheet(),
              ),
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
