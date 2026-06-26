import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/context_ext.dart';
import 'package:equran_app/core/utils/time_parsing.dart';
import 'package:equran_app/core/widgets/luxury_divider.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsak_alarm_prefs.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:equran_app/features/imsakiyah/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImsakAlarmToggleCard extends ConsumerWidget {
  const ImsakAlarmToggleCard({
    required this.todayEntry,
    super.key,
  });

  final ImsakiyahEntry todayEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefState = ref.watch(imsakAlarmViewModelProvider);
    final prefs = switch (prefState) {
      ImsakAlarmLoaded(:final prefs) => prefs,
      _ => const ImsakAlarmPrefs(),
    };
    final notifier = ref.read(imsakAlarmViewModelProvider.notifier);

    return _AlarmCard(
      prefs: prefs,
      todayEntry: todayEntry,
      onToggleImsak: () => notifier.toggleImsak(entry: todayEntry),
      onToggleSahur: () => notifier.toggleSahur(entry: todayEntry),
      onSetMenitSebelum: (val) =>
          notifier.setMenitSebelum(val, entry: todayEntry),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  const _AlarmCard({
    required this.prefs,
    required this.todayEntry,
    required this.onToggleImsak,
    required this.onToggleSahur,
    required this.onSetMenitSebelum,
  });

  final ImsakAlarmPrefs prefs;
  final ImsakiyahEntry todayEntry;
  final VoidCallback onToggleImsak;
  final VoidCallback onToggleSahur;
  final void Function(int menit) onSetMenitSebelum;

  static const _menitOptions = [30, 45, 60, 90];

  @override
  Widget build(BuildContext context) {
    final surfaceColor = context.surfaceColor;
    final borderColor = context.borderSubtleColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pagePadding,
        AppDimens.spaceXS,
        AppDimens.pagePadding,
        AppDimens.spaceXS,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(AppDimens.cardPaddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: context.primaryContainerColor,
                    borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                  ),
                  child: Icon(
                    Icons.alarm_rounded,
                    size: 16,
                    color: context.primaryActionColor,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Text(
                  'Alarm Sahur & Imsak',
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.textPrimaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceMD),

            const GoldDivider(verticalMargin: 0),

            const SizedBox(height: AppDimens.spaceMD),

            _AlarmToggleRow(
              icon: Icons.nightlight_round,
              label: 'Alarm Imsak',
              subtitle: 'Berbunyi tepat pukul ${todayEntry.imsak}',
              value: prefs.imsakEnabled,
              onChanged: (_) => onToggleImsak(),
            ),

            const SizedBox(height: AppDimens.spaceSM),

            _AlarmToggleRow(
              icon: Icons.restaurant_rounded,
              label: 'Alarm Sahur',
              subtitle:
                  '${prefs.menitSebelumImsak} menit sebelum imsak (${_sahurTime(todayEntry.imsak, prefs.menitSebelumImsak)})',
              value: prefs.sahurEnabled,
              onChanged: (_) => onToggleSahur(),
            ),

            if (prefs.sahurEnabled) ...[
              const SizedBox(height: AppDimens.spaceMD),
              _MinuteDropdown(
                value: prefs.menitSebelumImsak,
                options: _menitOptions,
                onChanged: (val) {
                  if (val == null) return;
                  onSetMenitSebelum(val);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _sahurTime(String imsak, int menit) {
    final parsed = parseWaktu(
      date: DateTime.now(),
      waktuStr: imsak,
      offsetMinutes: -menit,
    );
    if (parsed == null) return '--:--';
    return '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
  }
}

class _MinuteDropdown extends StatelessWidget {
  const _MinuteDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final int value;
  final List<int> options;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Berapa menit sebelum imsak:',
          style: context.theme.textTheme.bodySmall?.copyWith(
            color: context.textTertiaryColor,
          ),
        ),
        const SizedBox(width: AppDimens.spaceSM),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceSM,
            vertical: AppDimens.spaceXS,
          ),
          decoration: BoxDecoration(
            color: context.primaryContainerColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusSM),
          ),
          child: DropdownButton<int>(
            value: value,
            isDense: true,
            underline: const SizedBox.shrink(),
            dropdownColor: context.surfaceColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            items: options
                .map(
                  (m) => DropdownMenuItem(
                    value: m,
                    child: Text(
                      '$m menit',
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.primaryActionColor,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
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
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: value
                ? context.primaryContainerColor
                : context.surfaceVariantColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusSM),
          ),
          child: Icon(
            icon,
            size: 14,
            color: value
                ? context.primaryActionColor
                : context.textTertiaryColor,
          ),
        ),
        const SizedBox(width: AppDimens.spaceSM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.textPrimaryColor,
                ),
              ),
              Text(
                subtitle,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: context.textTertiaryColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: context.primaryActionColor,
          activeTrackColor: context.primaryContainerColor,
          inactiveThumbColor: context.textTertiaryColor,
          inactiveTrackColor: context.borderSubtleColor,
        ),
      ],
    );
  }
}
