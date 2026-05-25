import 'package:equran_app/features/doa/data/models/doa_dto.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';

extension DoaDtoMapper on DoaDto {
  Doa toEntity() => Doa(
    id: id,
    grup: grup,
    nama: nama,
    ar: ar,
    tr: tr,
    idn: idn,
    tentang: tentang,
    tag: tag,
  );
}
