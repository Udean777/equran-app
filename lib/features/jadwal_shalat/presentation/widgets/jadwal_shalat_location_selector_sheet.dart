import 'dart:async';

import 'package:equran_app/core/widgets/location/location_selector_sheet.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JadwalShalatLocationSelectorSheet extends ConsumerWidget {
  const JadwalShalatLocationSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jadwalShalatViewModelProvider);

    final provinsiList = switch (state) {
      JadwalShalatProvinsiLoaded() => state.provinsi,
      JadwalShalatKabkotaLoaded() => state.provinsi,
      JadwalShalatLoadingKabkota() => state.provinsi,
      JadwalShalatLoadingJadwal() => state.provinsi,
      JadwalShalatSuccess() => state.provinsi,
      JadwalShalatFailure() => state.provinsi ?? <String>[],
      _ => <String>[],
    };

    final kabkotaList = switch (state) {
      JadwalShalatKabkotaLoaded() => state.kabkota,
      JadwalShalatLoadingJadwal() => state.kabkota,
      JadwalShalatSuccess() => state.kabkota,
      JadwalShalatFailure() => state.kabkota ?? <String>[],
      _ => <String>[],
    };

    final isLoadingKabkota = state is JadwalShalatLoadingKabkota;

    final vm = ref.read(jadwalShalatViewModelProvider.notifier);

    return LocationSelectorSheet(
      provinsiList: provinsiList,
      kabkotaList: kabkotaList,
      isLoadingKabkota: isLoadingKabkota,
      onProvinsiSelected: (provinsi) => unawaited(vm.selectProvinsi(provinsi)),
      onKabkotaSelected: (kabkota) {
        unawaited(vm.selectKabkota(kabkota));
        Navigator.of(context).pop();
      },
    );
  }
}
