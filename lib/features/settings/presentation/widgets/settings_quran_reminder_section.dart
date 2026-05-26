import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:equran_app/features/quran_reminder/presentation/cubit/quran_reminder_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section reminder baca Quran — toggle + jam reminder.
class SettingsQuranReminderSection extends StatelessWidget {
  const SettingsQuranReminderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranReminderCubit, QuranReminderPrefs>(
      builder: (context, prefs) {
        final cubit = context.read<QuranReminderCubit>();
        final timeLabel =
            '${prefs.hour.toString().padLeft(2, '0')}:'
            '${prefs.minute.toString().padLeft(2, '0')}';
        return Column(
          children: [
            SwitchListTile(
              secondary: const Icon(
                Icons.auto_stories_rounded,
                color: AppColors.primary,
              ),
              title: const Text('Aktifkan Reminder'),
              subtitle: const Text('Pengingat harian membaca Al-Quran'),
              value: prefs.enabled,
              activeThumbColor: AppColors.primary,
              onChanged: (_) => unawaited(cubit.toggleEnabled()),
            ),
            if (prefs.enabled) ...[
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.primary,
                ),
                title: const Text('Jam Reminder'),
                trailing: Text(
                  'Setiap hari pukul $timeLabel',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: prefs.hour,
                      minute: prefs.minute,
                    ),
                  );
                  if (picked != null && context.mounted) {
                    unawaited(
                      cubit.setTime(
                        hour: picked.hour,
                        minute: picked.minute,
                      ),
                    );
                  }
                },
              ),
            ],
          ],
        );
      },
    );
  }
}
