import 'dart:async';

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
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
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
      appBar: AppBar(
        title: const Text('Jadwal Shalat'),
        centerTitle: false,
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
            JadwalShalatFailure() => _buildFailure(context, state),
          };
        },
      ),
    );
  }

  Widget _buildDetectingLocation() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Icon(Icons.gps_fixed_rounded, size: 40),
          SizedBox(height: 12),
          Text(
            'Mendeteksi lokasi Anda...',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            'Jadwal akan dimuat secara otomatis',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time_rounded, size: 64),
          const SizedBox(height: 16),
          const Text('Pilih lokasi untuk melihat jadwal shalat'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _showLocationSheet(context),
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Pilih Lokasi'),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPrompt(BuildContext context) {
    final state = context.read<JadwalShalatCubit>().state;
    final isLoading =
        state is JadwalShalatLoadingKabkota ||
        state is JadwalShalatLoadingJadwal;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Memuat data...'),
          ] else ...[
            const Icon(Icons.location_searching_rounded, size: 64),
            const SizedBox(height: 16),
            const Text('Pilih lokasi untuk melihat jadwal shalat'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _showLocationSheet(context),
              icon: const Icon(Icons.location_on_outlined),
              label: const Text('Pilih Lokasi'),
            ),
          ],
        ],
      ),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Jadwal ${state.jadwal.bulanNama} ${state.jadwal.tahun}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
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

  Widget _buildFailure(BuildContext context, JadwalShalatFailure state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.failure.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.read<JadwalShalatCubit>().retry(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
