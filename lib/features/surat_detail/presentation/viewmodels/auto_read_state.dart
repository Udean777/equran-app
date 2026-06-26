import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_read_state.freezed.dart';

/// State untuk auto-read mode di SuratDetailCardView.
@freezed
sealed class AutoReadState with _$AutoReadState {
  const factory AutoReadState({
    @Default(false) bool isActive,
  }) = _AutoReadState;
}
