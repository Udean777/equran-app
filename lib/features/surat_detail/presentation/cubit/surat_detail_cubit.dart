import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/domain/usecases/get_surat_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'surat_detail_cubit.freezed.dart';
part 'surat_detail_state.dart';

@injectable
class SuratDetailCubit extends Cubit<SuratDetailState> {
  SuratDetailCubit(this._getSuratDetail)
    : super(const SuratDetailState.initial());

  final GetSuratDetail _getSuratDetail;

  Future<void> load(int nomor) async {
    emit(const SuratDetailState.loading());
    final result = await _getSuratDetail(SuratDetailParams(nomor: nomor));
    result.fold(
      (failure) => emit(SuratDetailState.failure(failure: failure)),
      (detail) => emit(SuratDetailState.success(detail: detail)),
    );
  }

  void retry(int nomor) => load(nomor);
}
