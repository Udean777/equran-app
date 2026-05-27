import 'package:equran_app/core/constants/juz_mapping.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/hafalan/data/datasources/hafalan_local_datasource.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_stats.dart';
import 'package:equran_app/features/hafalan/domain/entities/hafalan_surat.dart';
import 'package:equran_app/features/hafalan/domain/repositories/hafalan_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HafalanRepository)
class HafalanRepositoryImpl implements HafalanRepository {
  const HafalanRepositoryImpl(this._datasource);

  final HafalanLocalDatasource _datasource;

  @override
  Future<Either<Failure, List<HafalanSurat>>> getAllHafalan() async {
    try {
      final list = await _datasource.getAll();
      final resolved = list.map(_resolveStatus).toList();
      return Right(resolved);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HafalanSurat?>> getHafalanBySurat(
    int suratNomor,
  ) async {
    try {
      final hafalan = await _datasource.getBySurat(suratNomor);
      if (hafalan == null) return const Right(null);
      return Right(_resolveStatus(hafalan));
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveHafalanSurat(HafalanSurat hafalan) async {
    try {
      await _datasource.save(hafalan);
      return const Right(unit);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteHafalanSurat(int suratNomor) async {
    try {
      await _datasource.delete(suratNomor);
      return const Right(unit);
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HafalanStats>> getHafalanStats() async {
    try {
      final list = (await _datasource.getAll()).map(_resolveStatus).toList();
      return Right(_computeStats(list));
    } on Object catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Compute status perluMurajaah dari data yang tersimpan.
  /// Status ini tidak disimpan di Hive — selalu di-derive saat load.
  HafalanSurat _resolveStatus(HafalanSurat hafalan) {
    if (hafalan.status == HafalanStatus.sudahHafal &&
        hafalan.isMurajaahJatuhTempo) {
      return hafalan.copyWith(status: HafalanStatus.perluMurajaah);
    }
    return hafalan;
  }

  /// Hitung statistik global dari list hafalan.
  HafalanStats _computeStats(List<HafalanSurat> list) {
    const totalAyatQuran = 6236;

    final totalAyatHafal = list.fold<int>(
      0,
      (sum, h) => sum + h.ayatHafal.length,
    );

    final totalSuratSelesai = list.where((h) => h.isSelesai).length;

    final persentaseQuran = (totalAyatHafal / totalAyatQuran).clamp(0.0, 1.0);

    final suratSedangDihafal = list
        .where((h) => h.status == HafalanStatus.sedangDihafal)
        .length;

    final suratPerluMurajaah = list
        .where((h) => h.status == HafalanStatus.perluMurajaah)
        .length;

    // Progress per juz: hitung ayat hafal per juz dibagi total ayat juz
    final progressPerJuz = <int, double>{};
    for (var juz = 1; juz <= 30; juz++) {
      final totalAyatJuz = kTotalAyatPerJuz[juz] ?? 0;
      if (totalAyatJuz == 0) {
        progressPerJuz[juz] = 0;
        continue;
      }

      final suratList = kJuzToSurahMapping[juz] ?? [];
      var ayatHafalJuz = 0;

      for (final suratNomor in suratList) {
        final matches = list.where((h) => h.suratNomor == suratNomor);
        if (matches.isEmpty) continue;
        final h = matches.first;

        final range = kJuzSurahVerseRanges['$juz:$suratNomor'];
        final start = range?.$1 ?? 1;
        final end = range?.$2 ?? h.jumlahAyat;

        for (final a in h.ayatHafal) {
          if (a >= start && a <= end) {
            ayatHafalJuz++;
          }
        }
      }

      progressPerJuz[juz] = (ayatHafalJuz / totalAyatJuz).clamp(0.0, 1.0);
    }

    return HafalanStats(
      totalAyatHafal: totalAyatHafal,
      totalSuratSelesai: totalSuratSelesai,
      persentaseQuran: persentaseQuran,
      progressPerJuz: progressPerJuz,
      suratSedangDihafal: suratSedangDihafal,
      suratPerluMurajaah: suratPerluMurajaah,
    );
  }
}
