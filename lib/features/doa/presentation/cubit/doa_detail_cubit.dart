import 'dart:async';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'doa_detail_cubit.freezed.dart';
part 'doa_detail_state.dart';

@injectable
class DoaDetailCubit extends Cubit<DoaDetailState> {
  DoaDetailCubit(this._getDoaDetail) : super(const DoaDetailState.initial());

  final GetDoaDetail _getDoaDetail;

  int? _lastId;

  Future<void> load(int id) async {
    _lastId = id;
    emit(const DoaDetailState.loading());
    final result = await _getDoaDetail(id);
    result.fold(
      (failure) => emit(DoaDetailState.failure(failure: failure)),
      (doa) => emit(DoaDetailState.success(doa: doa)),
    );
  }

  void retry() {
    if (_lastId != null) unawaited(load(_lastId!));
  }
}
