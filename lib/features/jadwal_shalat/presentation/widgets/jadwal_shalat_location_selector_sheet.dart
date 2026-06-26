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

    final provinsiList = state.provinsiList;
    final kabkotaList = state.kabkotaList;
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
