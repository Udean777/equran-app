import 'package:equatable/equatable.dart';

class HafalanSuratParams extends Equatable {
  const HafalanSuratParams(this.suratNomor);
  final int suratNomor;

  @override
  List<Object?> get props => [suratNomor];
}
