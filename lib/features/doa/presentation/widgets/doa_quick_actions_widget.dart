import 'package:equran_app/core/router/app_routes.dart';
import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
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
      id1: 6,
      id2: 11,
    );
  } else if (hour >= 12 && hour < 15) {
    return const _DoaSlot(
      label: 'Doa Siang',
      icon: Icons.wb_twilight_outlined,
      id1: 135,
      id2: 139,
    );
  } else if (hour >= 15 && hour < 18) {
    return const _DoaSlot(
      label: 'Doa Sore',
      icon: Icons.nights_stay_outlined,
      id1: 15,
      id2: 48,
    );
  } else {
    return const _DoaSlot(
      label: 'Doa Malam',
      icon: Icons.bedtime_outlined,
      id1: 1,
      id2: 58,
    );
  }
}

/// Widget quick actions doa harian — tampil di atas list surat.
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
        if (!snapshot.hasData) return const SizedBox.shrink();

        final doas = snapshot.data!;
        final doa1 = doas[0];
        final doa2 = doas[1];

        if (doa1 == null && doa2 == null) return const SizedBox.shrink();

        final isDark = context.isDark;

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.pagePadding,
            AppDimens.spaceMD,
            AppDimens.pagePadding,
            AppDimens.spaceXS,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.goldDark.withValues(alpha: 0.2)
                          : AppColors.goldLighter,
                      borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                    ),
                    child: Icon(
                      _slot.icon,
                      size: 14,
                      color: AppColors.goldDark,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSM),
                  Text(
                    _slot.label,
                    style: AppTypography.serifHeadingSmall.copyWith(
                      color: isDark
                          ? AppColors.onSurfaceDark
                          : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceSM),

              // 2 card horizontal — IntrinsicHeight agar tinggi selalu sama
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (doa1 != null)
                      Expanded(
                        child: _DoaActionCard(
                          doa: doa1,
                          isDark: isDark,
                          onTap: () => context.push(AppRoutes.doa(doa1.id)),
                        ),
                      ),
                    if (doa1 != null && doa2 != null)
                      const SizedBox(width: AppDimens.spaceSM),
                    if (doa2 != null)
                      Expanded(
                        child: _DoaActionCard(
                          doa: doa2,
                          isDark: isDark,
                          onTap: () => context.push(AppRoutes.doa(doa2.id)),
                        ),
                      ),
                  ],
                ),
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
    required this.isDark,
    required this.onTap,
  });

  final Doa doa;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = isDark
        ? AppColors.surfaceDarkVariant
        : AppColors.surfaceTint;
    final borderColor = isDark
        ? AppColors.outlineDark
        : AppColors.primaryContainer;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        splashColor: AppColors.primaryContainer.withValues(alpha: 0.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusLG),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(AppDimens.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nama doa
              Text(
                doa.nama,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.primaryLighter : AppColors.primary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppDimens.spaceXS),

              // Preview arab — Expanded agar mendorong "Baca doa" ke bawah
              Expanded(
                child: Text(
                  doa.ar,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'Amiri',
                    color: isDark
                        ? AppColors.onSurfaceDarkVariant
                        : AppColors.textTertiary,
                    fontSize: 13,
                    height: 1.8,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceSM),

              // Baca label
              Row(
                children: [
                  Text(
                    'Baca doa',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.primaryLighter
                          : AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 10,
                    color: isDark
                        ? AppColors.primaryLighter
                        : AppColors.primary,
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
