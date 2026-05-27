import 'dart:async';

import 'package:equran_app/core/widgets/location/location_selector_sheet.dart';
import 'package:equran_app/features/imsakiyah/presentation/cubit/imsakiyah_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Thin wrapper [LocationSelectorSheet] untuk feature imsakiyah.
/// Bertanggung jawab mengekstrak data dari [ImsakiyahState]
/// dan meneruskan callback ke [ImsakiyahCubit].
class ImsakiyahLocationSelectorSheet extends StatelessWidget {
  const ImsakiyahLocationSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImsakiyahCubit, ImsakiyahState>(
      builder: (context, state) {
        final provinsiList = switch (state) {
          ImsakiyahProvinsiLoaded() => state.provinsi,
          ImsakiyahKabkotaLoaded() => state.provinsi,
          ImsakiyahLoadingKabkota() => state.provinsi,
          ImsakiyahLoadingJadwal() => state.provinsi,
          ImsakiyahSuccess() => state.provinsi,
          ImsakiyahFailure() => state.provinsi ?? <String>[],
          _ => <String>[],
        };

        final kabkotaList = switch (state) {
          ImsakiyahKabkotaLoaded() => state.kabkota,
          ImsakiyahLoadingJadwal() => state.kabkota,
          ImsakiyahSuccess() => state.kabkota,
          ImsakiyahFailure() => state.kabkota ?? <String>[],
          _ => <String>[],
        };

        final isLoadingKabkota = state is ImsakiyahLoadingKabkota;

        return LocationSelectorSheet(
          provinsiList: provinsiList,
          kabkotaList: kabkotaList,
          isLoadingKabkota: isLoadingKabkota,
          onProvinsiSelected: (provinsi) => unawaited(
            context.read<ImsakiyahCubit>().selectProvinsi(provinsi),
          ),
          onKabkotaSelected: (kabkota) {
            unawaited(
              context.read<ImsakiyahCubit>().selectKabkota(kabkota),
            );
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
