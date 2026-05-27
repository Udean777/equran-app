import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/controllers/card_stack_controller.dart';
import 'package:equran_app/features/surat_detail/presentation/widgets/surat_detail_app_bar.dart';
import 'package:flutter/material.dart';

/// AppBar yang update label juz sesuai ayat aktif di card stack
class JuzAwareAppBar extends StatelessWidget implements PreferredSizeWidget {
  const JuzAwareAppBar({
    required this.detail,
    required this.controller,
    super.key,
  });

  final SuratDetail detail;
  final CardStackController controller;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.appBarHeightLG);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, _) => SuratDetailAppBar(
        detail: detail,
        currentAyatNomor: controller.currentAyatNomor,
      ),
    );
  }
}
