import 'package:equatable/equatable.dart';

class GetJadwalShalatParams extends Equatable {
  const GetJadwalShalatParams({
    required this.provinsi,
    required this.kabkota,
    required this.bulan,
    required this.tahun,
  });
  final String provinsi;
  final String kabkota;
  final int bulan;
  final int tahun;

  @override
  List<Object?> get props => [provinsi, kabkota, bulan, tahun];
}

class SaveLastLocationShalatParams extends Equatable {
  const SaveLastLocationShalatParams({
    required this.provinsi,
    required this.kabkota,
  });
  final String provinsi;
  final String kabkota;

  @override
  List<Object?> get props => [provinsi, kabkota];
}

class GetKabkotaShalatParams extends Equatable {
  const GetKabkotaShalatParams(this.provinsi);
  final String provinsi;

  @override
  List<Object?> get props => [provinsi];
}
