import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:flutter/material.dart';

class ImsakiyahTodayCard extends StatelessWidget {
  const ImsakiyahTodayCard({
    required this.entry,
    required this.tanggal,
    super.key,
  });

  final ImsakiyahEntry entry;
  final int tanggal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.today_rounded,
                  size: 18,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  'Hari Ini — Tanggal $tanggal',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _TodayGrid(entry: entry, colorScheme: colorScheme, theme: theme),
          ],
        ),
      ),
    );
  }
}

class _TodayGrid extends StatelessWidget {
  const _TodayGrid({
    required this.entry,
    required this.colorScheme,
    required this.theme,
  });

  final ImsakiyahEntry entry;
  final ColorScheme colorScheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Imsak', entry.imsak, Icons.nightlight_round),
      ('Subuh', entry.subuh, Icons.wb_twilight_rounded),
      ('Terbit', entry.terbit, Icons.wb_sunny_outlined),
      ('Dhuha', entry.dhuha, Icons.sunny_snowing),
      ('Dzuhur', entry.dzuhur, Icons.light_mode_rounded),
      ('Ashar', entry.ashar, Icons.wb_cloudy_outlined),
      ('Maghrib', entry.maghrib, Icons.wb_twilight_outlined),
      ('Isya', entry.isya, Icons.nights_stay_rounded),
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.1,
      children: items
          .map(
            (item) => _TodayItem(
              label: item.$1,
              time: item.$2,
              icon: item.$3,
              colorScheme: colorScheme,
              theme: theme,
            ),
          )
          .toList(),
    );
  }
}

class _TodayItem extends StatelessWidget {
  const _TodayItem({
    required this.label,
    required this.time,
    required this.icon,
    required this.colorScheme,
    required this.theme,
  });

  final String label;
  final String time;
  final IconData icon;
  final ColorScheme colorScheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onPrimaryContainer.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: colorScheme.onPrimaryContainer),
          const SizedBox(height: 3),
          Text(
            time,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
