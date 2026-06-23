import 'package:equatable/equatable.dart';

class GetImsakiyahParams extends Equatable {
  const GetImsakiyahParams({
    required this.provinsi,
    required this.kabkota,
  });

  final String provinsi;
  final String kabkota;

  @override
  List<Object?> get props => [provinsi, kabkota];
}

class GetKabkotaParams extends Equatable {
  const GetKabkotaParams(this.provinsi);

  final String provinsi;

  @override
  List<Object?> get props => [provinsi];
}

class SaveLastLocationParams extends Equatable {
  const SaveLastLocationParams({
    required this.provinsi,
    required this.kabkota,
  });

  final String provinsi;
  final String kabkota;

  @override
  List<Object?> get props => [provinsi, kabkota];
}
