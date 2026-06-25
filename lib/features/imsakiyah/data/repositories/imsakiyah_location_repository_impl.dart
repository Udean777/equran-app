import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/imsakiyah/domain/repositories/imsakiyah_location_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';

class ImsakiyahLocationRepositoryImpl implements ImsakiyahLocationRepository {
  const ImsakiyahLocationRepositoryImpl(
    this._box,
  );

  final Box<String> _box;

  static const _lastProvinsiKey = 'last_provinsi';
  static const _lastKabkotaKey = 'last_kabkota';

  @override
  Future<Either<Failure, String?>> getLastProvinsi() async {
    try {
      return right(_box.get(_lastProvinsiKey));
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLastProvinsi(String provinsi) async {
    try {
      await _box.put(_lastProvinsiKey, provinsi);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getLastKabkota() async {
    try {
      return right(_box.get(_lastKabkotaKey));
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLastKabkota(String kabkota) async {
    try {
      await _box.put(_lastKabkotaKey, kabkota);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
