import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAvailableQari {
  const GetAvailableQari();

  /// Return semua qari yang tersedia.
  List<Qari> call() => Qari.values;
}
