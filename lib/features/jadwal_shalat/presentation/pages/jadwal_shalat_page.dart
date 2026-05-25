import 'dart:async';

import 'package:equran_app/core/utils/bottom_sheet_utils.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/app_drawer.dart';
import 'package:equran_app/core/widgets/app_menu_button.dart';
import 'package:equran_app/core/widgets/detecting_location_widget.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/location/location_change_prompt_widget.dart';
import 'package:equran_app/core/widgets/location/location_initial_prompt_widget.dart';
import 'package:equran_app/core/widgets/section_header.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Jadwal Shalat'),
        centerTitle: false,
        leading: const AppMenuButton(),
      ),
      body: BlocBuilder<JadwalShalatCubit, JadwalShalatState>(
        builder: (context, state) {
          return switch (state) {
            JadwalShalatInitial() => _buildInitialPrompt(context),
            JadwalShalatLoadingProvinsi() => const Center(
              child: CircularProgressIndicator(),
            ),
            JadwalShalatDetectingLocation() => _buildDetectingLocation(),
            JadwalShalatProvinsiLoaded() => _buildLocationPrompt(context),
            JadwalShalatLoadingKabkota() => _buildLocationPrompt(context),
            JadwalShalatKabkotaLoaded() => _buildLocationPrompt(context),
            JadwalShalatLoadingJadwal() => const Center(
              child: CircularProgressIndicator(),
            ),
            JadwalShalatSuccess() => _buildSuccess(context, state),
            JadwalShalatFailure() => ErrorStateWidget(
              message: state.failure.toUserMessage(),
              onRetry: () => context.read<JadwalShalatCubit>().retry(),
            ),
          };
        },
      ),
    );
  }

  Widget _buildDetectingLocation() => const DetectingLocationWidget();

  Widget _buildInitialPrompt(BuildContext context) =>
      LocationInitialPromptWidget(
        icon: Icons.access_time_rounded,
        message: 'Pilih lokasi untuk melihat jadwal shalat',
        onSelectLocation: () => _showLocationSheet(context),
      );

  Widget _buildLocationPrompt(BuildContext context) {
    final state = context.read<JadwalShalatCubit>().state;
    final isLoading =
        state is JadwalShalatLoadingKabkota ||
        state is JadwalShalatLoadingJadwal;
    return LocationChangePromptWidget(
      message: 'Pilih lokasi untuk melihat jadwal shalat',
      onSelectLocation: () => _showLocationSheet(context),
      isLoading: isLoading,
    );
  }

  Widget _buildSuccess(BuildContext context, JadwalShalatSuccess state) {
    // Tanggal hari ini UTC+7
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Cari entry hari ini via tanggal_lengkap, fallback ke entry pertama
    final todayEntry =
        state.jadwal.jadwal
            .where((e) => e.tanggalLengkap == todayStr)
            .firstOrNull ??
        state.jadwal.jadwal.first;

    // Hitung bulan prev/next
    final currentBulan = state.bulan;
    final currentTahun = state.tahun;
    final prevDate = DateTime(currentTahun, currentBulan - 1);
    final nextDate = DateTime(currentTahun, currentBulan + 1);

    return RefreshIndicator(
      onRefresh: () async => context.read<JadwalShalatCubit>().selectKabkota(
        state.selectedKabkota,
      ),
      child: ListView(
        children: [
          JadwalShalatHeaderCard(
            jadwal: state.jadwal,
            onChangeLocation: () => _showLocationSheet(context),
            onPrevBulan: () => context.read<JadwalShalatCubit>().changeBulan(
              prevDate.month,
              prevDate.year,
            ),
            onNextBulan: () => context.read<JadwalShalatCubit>().changeBulan(
              nextDate.month,
              nextDate.year,
            ),
          ),
          // Today card hanya tampil jika bulan sekarang
          if (state.jadwal.jadwal.any((e) => e.tanggalLengkap == todayStr))
            JadwalShalatTodayCard(entry: todayEntry),
          SectionHeader(
            label: 'Jadwal ${state.jadwal.bulanNama} ${state.jadwal.tahun}',
          ),
          JadwalShalatTable(
            entries: state.jadwal.jadwal,
            todayTanggalLengkap: todayStr,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
