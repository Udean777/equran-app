import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/viewmodels/auto_read_notifier.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_detail_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AppBar yang update label juz sesuai ayat aktif di card stack
class JuzAwareAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const JuzAwareAppBar({
    required this.detail,
    required this.totalAyat,
    super.key,
  });

  final SuratDetail detail;
  final int totalAyat;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.appBarHeightLG);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardState = ref.watch(cardStackProvider(totalAyat));
    return SuratDetailAppBar(
      detail: detail,
      currentAyatNomor: cardState.currentAyatNomor,
    );
  }
}
