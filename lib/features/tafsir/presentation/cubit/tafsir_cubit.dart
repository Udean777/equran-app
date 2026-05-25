import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/tafsir/domain/entities/tafsir_surat.dart';
import 'package:equran_app/features/tafsir/domain/usecases/get_tafsir.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'tafsir_cubit.freezed.dart';
part 'tafsir_state.dart';

@injectable
class TafsirCubit extends Cubit<TafsirState> {
  TafsirCubit(this._getTafsir) : super(const TafsirState.initial());

  final GetTafsir _getTafsir;

  Future<void> load(int nomor) async {
    emit(const TafsirState.loading());
    final result = await _getTafsir(TafsirParams(nomor: nomor));
    result.fold(
      (failure) => emit(TafsirState.failure(failure: failure)),
      (tafsir) => emit(TafsirState.success(tafsir: tafsir)),
    );
  }

  void retry(int nomor) => load(nomor);
}
