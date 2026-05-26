import 'dart:async';

import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/detecting_location_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/location/location_change_prompt_widget.dart';
import 'package:equran_app/core/widgets/location/location_initial_prompt_widget.dart';
import 'package:equran_app/core/widgets/section_header.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imsakiyah'),
        centerTitle: false,
      ),
      body: BlocBuilder<ImsakiyahCubit, ImsakiyahState>(
        builder: (context, state) {
          return switch (state) {
            ImsakiyahInitial() => _buildInitialPrompt(context),
            ImsakiyahLoadingProvinsi() => const Center(
              child: CircularProgressIndicator(),
            ),
            ImsakiyahDetectingLocation() => _buildDetectingLocation(),
            ImsakiyahProvinsiLoaded() => _buildLocationPrompt(context),
            ImsakiyahLoadingKabkota() => _buildLocationPrompt(context),
            ImsakiyahKabkotaLoaded() => _buildLocationPrompt(context),
            ImsakiyahLoadingJadwal() => const Center(
              child: CircularProgressIndicator(),
            ),
            ImsakiyahSuccess() => _buildSuccess(context, state),
            ImsakiyahFailure() => ErrorStateWidget(
              message: state.failure.toUserMessage(),
              onRetry: () => context.read<ImsakiyahCubit>().retry(),
            ),
          };
        },
      ),
    );
  }

  Widget _buildDetectingLocation() => const DetectingLocationWidget();

  Widget _buildInitialPrompt(BuildContext context) =>
      LocationInitialPromptWidget(
        icon: Icons.mosque_outlined,
        message: 'Pilih lokasi untuk melihat jadwal imsakiyah',
        onSelectLocation: () => _showLocationSheet(context),
      );

  Widget _buildLocationPrompt(BuildContext context) {
    final state = context.read<ImsakiyahCubit>().state;
    final isLoading =
        state is ImsakiyahLoadingKabkota || state is ImsakiyahLoadingJadwal;
    return LocationChangePromptWidget(
      message: 'Pilih lokasi untuk melihat jadwal imsakiyah',
      onSelectLocation: () => _showLocationSheet(context),
      isLoading: isLoading,
    );
  }

  Widget _buildSuccess(BuildContext context, ImsakiyahSuccess state) {
    // Tentukan tanggal hari ini (UTC+7)
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final todayTanggal = now.day;

    // Cari entry hari ini, fallback ke entry pertama
    final todayEntry =
        state.jadwal.imsakiyah
            .where(
              (e) => e.tanggal == todayTanggal,
            )
            .firstOrNull ??
        state.jadwal.imsakiyah.first;

    return RefreshIndicator(
      onRefresh: () async => context.read<ImsakiyahCubit>().selectKabkota(
        state.selectedKabkota,
      ),
      child: ListView(
        children: [
          ImsakiyahHeaderCard(
            jadwal: state.jadwal,
            onChangeLocation: () => _showLocationSheet(context),
          ),
          ImsakiyahTodayCard(
            entry: todayEntry,
            tanggal: todayEntry.tanggal,
          ),
          ImsakAlarmToggleCard(todayEntry: todayEntry),
          const SectionHeader(label: 'Jadwal Bulan Ini'),
          ImsakiyahTable(
            entries: state.jadwal.imsakiyah,
            todayTanggal: todayTanggal,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
