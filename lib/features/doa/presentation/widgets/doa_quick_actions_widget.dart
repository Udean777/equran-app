import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_detail.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pasangan doa per slot waktu WIB.
class _DoaSlot {
  const _DoaSlot({
    required this.label,
    required this.icon,
    required this.id1,
    required this.id2,
  });

  final String label;
  final IconData icon;
  final int id1;
  final int id2;
}

/// Tentukan slot waktu berdasarkan jam WIB (UTC+7).
_DoaSlot _slotForNow() {
  final wib = DateTime.now().toUtc().add(const Duration(hours: 7));
  final hour = wib.hour;

  if (hour >= 4 && hour < 12) {
    return const _DoaSlot(
      label: 'Doa Pagi',
      icon: Icons.wb_sunny_outlined,
      id1: 6, // Doa Bangun Tidur 1
      id2: 11, // Doa Setelah Wudhu
    );
  } else if (hour >= 12 && hour < 15) {
    return const _DoaSlot(
      label: 'Doa Siang',
      icon: Icons.wb_twilight_outlined,
      id1: 135, // Doa Sebelum Makan
      id2: 139, // Doa Setelah Makan
    );
  } else if (hour >= 15 && hour < 18) {
    return const _DoaSlot(
      label: 'Doa Sore',
      icon: Icons.nights_stay_outlined,
      id1: 15, // Doa Berlindung dari keburukan
      id2: 48, // Doa Naik Kendaraan
    );
  } else {
    return const _DoaSlot(
      label: 'Doa Malam',
      icon: Icons.bedtime_outlined,
      id1: 1, // Doa Sebelum Tidur 1
      id2: 58, // Doa Berlindung dari setan
    );
  }
}

/// Widget quick actions doa harian — tampil di atas list surat.
/// Load doa dari cache/API, tap langsung ke DoaDetailPage.
class DoaQuickActionsWidget extends StatefulWidget {
  const DoaQuickActionsWidget({super.key});

  @override
  State<DoaQuickActionsWidget> createState() => _DoaQuickActionsWidgetState();
}

class _DoaQuickActionsWidgetState extends State<DoaQuickActionsWidget> {
  late final _DoaSlot _slot;
  late final Future<List<Doa?>> _future;

  @override
  void initState() {
    super.initState();
    _slot = _slotForNow();
    _future = _loadDoa();
  }

  Future<List<Doa?>> _loadDoa() async {
    final getDetail = getIt<GetDoaDetail>();
    final results = await Future.wait([
      getDetail(_slot.id1),
      getDetail(_slot.id2),
    ]);
    return results.map((r) => r.fold((_) => null, (doa) => doa)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Doa?>>(
      future: _future,
      builder: (context, snapshot) {
        // Sembunyikan jika loading atau error
        if (!snapshot.hasData) return const SizedBox.shrink();

        final doas = snapshot.data!;
        final doa1 = doas[0];
        final doa2 = doas[1];

        // Sembunyikan jika kedua doa gagal dimuat
        if (doa1 == null && doa2 == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceMD,
            AppDimens.spaceMD,
            AppDimens.spaceMD,
            AppDimens.spaceXS,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(_slot.icon, size: 16, color: AppColors.primary),
                  const SizedBox(width: AppDimens.spaceXS),
                  Text(
                    _slot.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceSM),
              // 2 card horizontal
              Row(
                children: [
                  if (doa1 != null)
                    Expanded(
                      child: _DoaActionCard(
                        doa: doa1,
                        onTap: () => context.push('/doa/${doa1.id}'),
                      ),
                    ),
                  if (doa1 != null && doa2 != null)
                    const SizedBox(width: AppDimens.spaceSM),
                  if (doa2 != null)
                    Expanded(
                      child: _DoaActionCard(
                        doa: doa2,
                        onTap: () => context.push('/doa/${doa2.id}'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DoaActionCard extends StatelessWidget {
  const _DoaActionCard({
    required this.doa,
    required this.onTap,
  });

  final Doa doa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.primary.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama doa
              Text(
                doa.nama,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimens.spaceXS),
              // Preview arab (pendek)
              Text(
                doa.ar,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'Amiri',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: AppDimens.spaceXS),
              // Label tap
              Row(
                children: [
                  Text(
                    'Baca selengkapnya',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 10,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
