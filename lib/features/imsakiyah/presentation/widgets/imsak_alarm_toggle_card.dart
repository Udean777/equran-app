import 'dart:async';

import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:equran_app/features/imsakiyah/presentation/cubit/imsak_alarm_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImsakAlarmToggleCard extends StatelessWidget {
  const ImsakAlarmToggleCard({
    required this.todayEntry,
    super.key,
  });

  final ImsakiyahEntry todayEntry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImsakAlarmCubit, ImsakAlarmState>(
      builder: (context, state) {
        final prefs = switch (state) {
          ImsakAlarmLoaded(:final prefs) => prefs,
          _ => const ImsakAlarmPrefs(),
        };

        return _AlarmCard(
          prefs: prefs,
          todayEntry: todayEntry,
        );
      },
    );
  }
}

class _AlarmCard extends StatelessWidget {
  const _AlarmCard({
    required this.prefs,
    required this.todayEntry,
  });

  final ImsakAlarmPrefs prefs;
  final ImsakiyahEntry todayEntry;

  static const _menitOptions = [30, 45, 60, 90];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.alarm_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Alarm Sahur & Imsak',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Toggle alarm imsak
            _AlarmToggleRow(
              icon: Icons.nightlight_round,
              label: 'Alarm Imsak',
              subtitle: 'Berbunyi tepat pukul ${todayEntry.imsak}',
              value: prefs.imsakEnabled,
              onChanged: (_) => context.read<ImsakAlarmCubit>().toggleImsak(
                entry: todayEntry,
              ),
            ),

            const SizedBox(height: 4),

            // Toggle alarm sahur
            _AlarmToggleRow(
              icon: Icons.restaurant_rounded,
              label: 'Alarm Sahur',
              subtitle:
                  '${prefs.menitSebelumImsak} menit sebelum imsak (${_sahurTime(todayEntry.imsak, prefs.menitSebelumImsak)})',
              value: prefs.sahurEnabled,
              onChanged: (_) => context.read<ImsakAlarmCubit>().toggleSahur(
                entry: todayEntry,
              ),
            ),

            // Dropdown menit — hanya tampil jika alarm sahur aktif
            if (prefs.sahurEnabled) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    'Berapa menit sebelum imsak:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: prefs.menitSebelumImsak,
                    isDense: true,
                    underline: const SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(8),
                    items: _menitOptions
                        .map(
                          (m) => DropdownMenuItem(
                            value: m,
                            child: Text(
                              '$m menit',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      unawaited(
                        context.read<ImsakAlarmCubit>().setMenitSebelum(
                          val,
                          entry: todayEntry,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Hitung waktu sahur = imsak − menit.
  String _sahurTime(String imsak, int menit) {
    try {
      final parts = imsak.trim().split(':');
      if (parts.length != 2) return '--:--';
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final total = h * 60 + m - menit;
      final hh = (total ~/ 60) % 24;
      final mm = total % 60;
      return '${hh.toString().padLeft(2, '0')}:${mm.abs().toString().padLeft(2, '0')}';
    } on Object catch (_) {
      return '--:--';
    }
  }
}

class _AlarmToggleRow extends StatelessWidget {
  const _AlarmToggleRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
