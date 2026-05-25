import 'dart:async';

import 'package:equran_app/features/imsakiyah/presentation/cubit/imsakiyah_cubit.dart';
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
    return BlocProvider(
      create: (_) {
        final cubit = getIt<ImsakiyahCubit>();
        unawaited(cubit.init());
        return cubit;
      },
      child: const _ImsakiyahView(),
    );
  }
}

class _ImsakiyahView extends StatelessWidget {
  const _ImsakiyahView();

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
            ImsakiyahFailure() => _buildFailure(context, state),
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
          const Icon(Icons.mosque_outlined, size: 64),
          const SizedBox(height: 16),
          const Text('Pilih lokasi untuk melihat jadwal imsakiyah'),
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
    final state = context.read<ImsakiyahCubit>().state;
    final isLoading =
        state is ImsakiyahLoadingKabkota || state is ImsakiyahLoadingJadwal;

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
            const Text('Pilih lokasi untuk melihat jadwal imsakiyah'),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Jadwal Bulan Ini',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ImsakiyahTable(
            entries: state.jadwal.imsakiyah,
            todayTanggal: todayTanggal,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFailure(BuildContext context, ImsakiyahFailure state) {
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
              onPressed: () => context.read<ImsakiyahCubit>().retry(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
