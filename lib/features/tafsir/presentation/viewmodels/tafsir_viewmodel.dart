import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/tafsir/domain/entities/tafsir_surat.dart';
import 'package:equran_app/features/tafsir/domain/usecases/get_tafsir.dart';
import 'package:equran_app/features/tafsir/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tafsir_state.dart';
part 'tafsir_viewmodel.freezed.dart';

class TafsirViewModel extends AutoDisposeNotifier<TafsirState> {
  @override
  TafsirState build() => const TafsirState.initial();

  GetTafsir get _getTafsir => ref.read(getTafsirProvider);

  Future<void> load(int nomor) async {
    state = const TafsirState.loading();
    final result = await _getTafsir(TafsirParams(nomor: nomor));
    result.fold(
      (failure) {
        state = TafsirState.failure(failure: failure);
      },
      (tafsir) {
        state = TafsirState.success(tafsir: tafsir);
      },
    );
  }

  void retry(int nomor) => load(nomor);
}
