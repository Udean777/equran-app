import 'dart:async';

import 'package:equran_app/core/theme/app_colors.dart';
import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/utils/failure_extension.dart';
import 'package:equran_app/core/widgets/bottom_sheet_handle.dart';
import 'package:equran_app/core/widgets/error_state_widget.dart';
import 'package:equran_app/core/widgets/loading_widget.dart';
import 'package:equran_app/features/tafsir/presentation/cubit/tafsir_cubit.dart';
import 'package:equran_app/features/tafsir/presentation/widgets/tafsir_ayat_card.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TafsirBottomSheet extends StatelessWidget {
  const TafsirBottomSheet({required this.nomor, super.key});

  final int nomor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<TafsirCubit>();
        unawaited(cubit.load(nomor));
        return cubit;
      },
      child: _TafsirBottomSheetContent(nomor: nomor),
    );
  }
}

class _TafsirBottomSheetContent extends StatelessWidget {
  const _TafsirBottomSheetContent({required this.nomor});

  final int nomor;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: AppDimens.bottomSheetInitialChildSize,
      minChildSize: AppDimens.bottomSheetMinChildSize,
      maxChildSize: AppDimens.bottomSheetMaxChildSize,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle bar
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimens.spaceSM),
            child: BottomSheetHandle(),
          ),
          // Header
          _TafsirHeader(),
          // Content
          Expanded(
            child: BlocBuilder<TafsirCubit, TafsirState>(
              builder: (context, state) => switch (state) {
                TafsirInitial() => const SizedBox.shrink(),
                TafsirLoading() => const LoadingWidget(),
                TafsirSuccess(:final tafsir) => ListView.builder(
                  controller: scrollController,
                  itemCount: tafsir.tafsirList.length,
                  itemBuilder: (_, i) => TafsirAyatCard(
                    key: ValueKey(tafsir.tafsirList[i].nomorAyat),
                    tafsirAyat: tafsir.tafsirList[i],
                  ),
                ),
                TafsirFailure(:final failure) => ErrorStateWidget(
                  message: failure.toUserMessage(),
                  onRetry: () => context.read<TafsirCubit>().retry(nomor),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TafsirHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<TafsirCubit, TafsirState>(
      builder: (context, state) {
        final namaLatin = state.mapOrNull(
          success: (s) => s.tafsir.info.namaLatin,
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceMD,
            AppDimens.spaceXS,
            AppDimens.spaceMD,
            AppDimens.spaceMD,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.borderVariantColor,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.tafsir,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              if (namaLatin != null)
                Text(
                  namaLatin,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
