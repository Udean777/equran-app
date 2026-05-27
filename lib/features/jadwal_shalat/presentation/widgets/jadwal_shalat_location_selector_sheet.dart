import 'dart:async';

import 'package:equran_app/core/widgets/location/location_selector_sheet.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/jadwal_shalat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Thin wrapper [LocationSelectorSheet] untuk feature jadwal shalat.
/// Bertanggung jawab mengekstrak data dari [JadwalShalatState]
/// dan meneruskan callback ke [JadwalShalatCubit].
class JadwalShalatLocationSelectorSheet extends StatelessWidget {
  const JadwalShalatLocationSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JadwalShalatCubit, JadwalShalatState>(
      builder: (context, state) {
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

        return LocationSelectorSheet(
          provinsiList: provinsiList,
          kabkotaList: kabkotaList,
          isLoadingKabkota: isLoadingKabkota,
          onProvinsiSelected: (provinsi) => unawaited(
            context.read<JadwalShalatCubit>().selectProvinsi(provinsi),
          ),
          onKabkotaSelected: (kabkota) {
            unawaited(
              context.read<JadwalShalatCubit>().selectKabkota(kabkota),
            );
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
