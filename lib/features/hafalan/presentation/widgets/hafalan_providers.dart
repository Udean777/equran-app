import 'dart:async';

import 'package:equran_app/features/hafalan/presentation/cubit/hafalan_cubit.dart';
import 'package:equran_app/features/surat_list/presentation/cubit/surat_list_cubit.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shared provider wrapper untuk semua halaman hafalan.
///
/// - [HafalanCubit] adalah @lazySingleton — pakai `.value` agar tidak di-close.
///   Load tidak dipanggil di sini karena cubit sudah di-load di root App.
/// - [SuratListCubit] di-create fresh per halaman dan langsung di-load.
class HafalanProviders extends StatelessWidget {
  const HafalanProviders({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<HafalanCubit>()),
        BlocProvider(
          create: (_) {
            final cubit = getIt<SuratListCubit>();
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: child,
    );
  }
}
