import 'dart:async';

import 'package:equran_app/core/widgets/location/location_selector_sheet.dart';
import 'package:equran_app/features/imsakiyah/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImsakiyahLocationSelectorSheet extends ConsumerWidget {
  const ImsakiyahLocationSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imsakiyahViewModelProvider);

    final provinsiList = state.provinsiList;
    final kabkotaList = state.kabkotaList;
    final isLoadingKabkota = state is ImsakiyahLoadingKabkota;

    final notifier = ref.read(imsakiyahViewModelProvider.notifier);

    return LocationSelectorSheet(
      provinsiList: provinsiList,
      kabkotaList: kabkotaList,
      isLoadingKabkota: isLoadingKabkota,
      onProvinsiSelected: (provinsi) => unawaited(
        notifier.selectProvinsi(provinsi),
      ),
      onKabkotaSelected: (kabkota) {
        unawaited(notifier.selectKabkota(kabkota));
        Navigator.of(context).pop();
      },
    );
  }
}
