import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/shalat_notif_prefs_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetShalatNotifPrefs {
  const GetShalatNotifPrefs(this._dataSource);

  final ShalatNotifPrefsDataSource _dataSource;

  Future<Either<Failure, ShalatNotifPrefs>> call() async {
    try {
      final prefs = await _dataSource.getPrefs();
      return right(prefs);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
