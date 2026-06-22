import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/core/network/repository_helper.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_local_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/jadwal_shalat_remote_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/shalat_notif_prefs_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/data/mappers/jadwal_shalat_mapper.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:equran_app/features/jadwal_shalat/domain/repositories/jadwal_shalat_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: JadwalShalatRepository)
class JadwalShalatRepositoryImpl implements JadwalShalatRepository {
  const JadwalShalatRepositoryImpl(
    this._remote,
    this._local,
    this._notifPrefs,
  );

  final JadwalShalatRemoteDataSource _remote;
  final JadwalShalatLocalDataSource _local;
  final ShalatNotifPrefsDataSource _notifPrefs;

  @override
  Future<Either<Failure, List<String>>> getProvinsi() async {
    final cached = await _local.getCachedProvinsi();
    if (cached != null && cached.isNotEmpty) return right(cached);

    return executeRequest(() async {
      final dto = await _remote.fetchProvinsi();
      await _local.cacheProvinsi(dto.data);
      return dto.data;
    });
  }

  @override
  Future<Either<Failure, List<String>>> getKabkota(String provinsi) async {
    final cached = await _local.getCachedKabkota(provinsi);
    if (cached != null && cached.isNotEmpty) return right(cached);

    return executeRequest(() async {
      final dto = await _remote.fetchKabkota(provinsi);
      await _local.cacheKabkota(provinsi, dto.data);
      return dto.data;
    });
  }

  @override
  Future<Either<Failure, JadwalShalat>> getJadwalShalat({
    required String provinsi,
    required String kabkota,
    required int bulan,
    required int tahun,
  }) async {
    final cached = await _local.getCachedJadwalShalat(
      provinsi,
      kabkota,
      bulan,
      tahun,
    );
    if (cached != null) return right(cached.toEntity());

    return executeRequest(() async {
      final dto = await _remote.fetchJadwalShalat(
        provinsi: provinsi,
        kabkota: kabkota,
        bulan: bulan,
        tahun: tahun,
      );
      await _local.cacheJadwalShalat(dto.data);
      return dto.data.toEntity();
    });
  }

  @override
  Future<Either<Failure, String?>> getLastProvinsi() async {
    try {
      return right(await _local.getLastProvinsi());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLastProvinsi(String provinsi) async {
    try {
      await _local.saveLastProvinsi(provinsi);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getLastKabkota() async {
    try {
      return right(await _local.getLastKabkota());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLastKabkota(String kabkota) async {
    try {
      await _local.saveLastKabkota(kabkota);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShalatNotifPrefs>> getNotifPrefs() async {
    try {
      return right(await _notifPrefs.getPrefs());
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveNotifPrefs(ShalatNotifPrefs prefs) async {
    try {
      await _notifPrefs.savePrefs(prefs);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
