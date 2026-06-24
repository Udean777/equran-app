import 'package:equatable/equatable.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';

class SaveHafalanParams extends Equatable {
  const SaveHafalanParams(this.hafalan);
  final HafalanSurat hafalan;

  @override
  List<Object?> get props => [hafalan];
}
