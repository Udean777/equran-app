import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/presentation/viewmodels/hafalan_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HafalanReminderSheet extends StatefulWidget {
  const HafalanReminderSheet({
    required this.hafalan,
    required this.detailNotifier,
    super.key,
  });

  final HafalanSurat hafalan;
  final HafalanDetailViewModel detailNotifier;

  @override
  State<HafalanReminderSheet> createState() => _HafalanReminderSheetState();
}

class _HafalanReminderSheetState extends State<HafalanReminderSheet> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate =
        widget.hafalan.tanggalMurajaahBerikutnya ??
        DateTime.now().add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hafalan = widget.hafalan;
    final dateStr = DateFormat('EEEE, d MMMM yyyy', 'id').format(_selectedDate);
    final levelStr = hafalan.isMurajaahSelesai
        ? 'Hafalan kuat ✓'
        : 'Level ${hafalan.murajaahLevel + 1}/5';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceMD),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BottomSheetHandle(),
            const SizedBox(height: AppDimens.spaceMD),

            Row(
              children: [
                const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppDimens.spaceSM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jadwal Muraja'ah",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${hafalan.namaLatin} · $levelStr',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceLG),

            if (!hafalan.isMurajaahSelesai) ...[
              _ActionTile(
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.success,
                title: "Tandai Sudah Muraja'ah",
                subtitle: 'Naik ke level berikutnya secara otomatis',
                onTap: () async {
                  await widget.detailNotifier.tandaiSudahMurajaah(
                    hafalan.suratNomor,
                  );
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              const SizedBox(height: AppDimens.spaceSM),
            ],

            _ActionTile(
              icon: Icons.calendar_today_rounded,
              iconColor: AppColors.primary,
              title: "Ubah Tanggal Muraja'ah",
              subtitle: dateStr,
              onTap: () => _pickDate(context),
            ),

            const SizedBox(height: AppDimens.spaceMD),

            FilledButton(
              onPressed: () async {
                await widget.detailNotifier.setMurajaahDate(
                  suratNomor: hafalan.suratNomor,
                  tanggal: _selectedDate,
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Simpan Jadwal'),
            ),

            const SizedBox(height: AppDimens.spaceSM),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: "Pilih Tanggal Muraja'ah",
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceMD),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceSM),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              ),
              child: Icon(icon, color: iconColor, size: AppDimens.iconMD),
            ),
            const SizedBox(width: AppDimens.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
