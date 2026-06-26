import 'dart:async';

import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/shalat_location_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';

class ShalatLocationRepositoryImpl implements ShalatLocationRepository {
  const ShalatLocationRepositoryImpl(
    this._box,
  );

  final Box<String> _box;

  static const _lastProvinsiKey = 'last_provinsi';
  static const _lastKabkotaKey = 'last_kabkota';

  @override
  Future<Either<Failure, String?>> getLastProvinsi() =>
      _safeCall(() => _box.get(_lastProvinsiKey));

  @override
  Future<Either<Failure, Unit>> saveLastProvinsi(String provinsi) =>
      _safeCall(() async {
        await _box.put(_lastProvinsiKey, provinsi);
        return unit;
      });

  @override
  Future<Either<Failure, String?>> getLastKabkota() =>
      _safeCall(() => _box.get(_lastKabkotaKey));

  @override
  Future<Either<Failure, Unit>> saveLastKabkota(String kabkota) =>
      _safeCall(() async {
        await _box.put(_lastKabkotaKey, kabkota);
        return unit;
      });

  static Future<Either<Failure, T>> _safeCall<T>(
    FutureOr<T> Function() fn,
  ) async {
    try {
      return right(await fn());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
