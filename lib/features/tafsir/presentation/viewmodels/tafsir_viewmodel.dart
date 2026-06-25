import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/tafsir/domain/entities/tafsir_surat.dart';
import 'package:equran_app/features/tafsir/domain/usecases/get_tafsir.dart';
import 'package:equran_app/features/tafsir/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tafsir_state.dart';
part 'tafsir_viewmodel.freezed.dart';

class TafsirViewModel extends StateNotifier<TafsirState> {
  TafsirViewModel(this._ref) : super(const TafsirState.initial());

  final Ref _ref;

  GetTafsir get _getTafsir => _ref.read(getTafsirProvider);

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
