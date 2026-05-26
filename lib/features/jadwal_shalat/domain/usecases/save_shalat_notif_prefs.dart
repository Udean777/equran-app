import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/jadwal_shalat/data/datasources/shalat_notif_prefs_data_source.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/shalat_notif_prefs.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveShalatNotifPrefs {
  const SaveShalatNotifPrefs(this._dataSource);

  final ShalatNotifPrefsDataSource _dataSource;

  Future<Either<Failure, Unit>> call(ShalatNotifPrefs prefs) async {
    try {
      await _dataSource.savePrefs(prefs);
      return right(unit);
    } on Object catch (e) {
      return left(Failure.unknown(message: e.toString()));
    }
  }
}
