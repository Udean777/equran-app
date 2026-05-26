import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/presentation/cubit/shalat_notif_cubit.dart';
import 'package:equran_app/features/settings/presentation/widgets/notif_toggle_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section notifikasi waktu shalat — toggle per waktu + menit sebelum.
class SettingsShalatNotifSection extends StatelessWidget {
  const SettingsShalatNotifSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShalatNotifCubit, ShalatNotifPrefs>(
      builder: (context, prefs) {
        final cubit = context.read<ShalatNotifCubit>();
        return Column(
          children: [
            NotifToggleTile(
              label: 'Subuh',
              icon: Icons.wb_twilight_rounded,
              value: prefs.subuh,
              onChanged: (_) => cubit.toggleSubuh(),
            ),
            NotifToggleTile(
              label: 'Dzuhur',
              icon: Icons.wb_sunny_rounded,
              value: prefs.dzuhur,
              onChanged: (_) => cubit.toggleDzuhur(),
            ),
            NotifToggleTile(
              label: 'Ashar',
              icon: Icons.wb_sunny_outlined,
              value: prefs.ashar,
              onChanged: (_) => cubit.toggleAshar(),
            ),
            NotifToggleTile(
              label: 'Maghrib',
              icon: Icons.nights_stay_outlined,
              value: prefs.maghrib,
              onChanged: (_) => cubit.toggleMaghrib(),
            ),
            NotifToggleTile(
              label: 'Isya',
              icon: Icons.nightlight_round,
              value: prefs.isya,
              onChanged: (_) => cubit.toggleIsya(),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(
                Icons.timer_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Ingatkan sebelum'),
              trailing: DropdownButton<int>(
                value: prefs.menitSebelum,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Tepat waktu')),
                  DropdownMenuItem(
                    value: 5,
                    child: Text('5 menit sebelum'),
                  ),
                  DropdownMenuItem(
                    value: 10,
                    child: Text('10 menit sebelum'),
                  ),
                  DropdownMenuItem(
                    value: 15,
                    child: Text('15 menit sebelum'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) unawaited(cubit.setMenitSebelum(val));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
