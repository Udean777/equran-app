import 'package:equran_app/features/surat_detail/data/models/surat_detail_dto.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_list/data/models/surat_dto.dart';
import 'package:equran_app/features/surat_list/domain/entities/surat.dart';
import 'package:equran_app/features/tafsir/data/models/tafsir_dto.dart';
import 'package:equran_app/features/tafsir/domain/entities/tafsir_surat.dart';

// ── Surat List ──────────────────────────────────────────────────────────────

const tSuratDto = SuratDto(
  nomor: 1,
  nama: 'الفاتحة',
  namaLatin: 'Al-Fatihah',
  jumlahAyat: 7,
  tempatTurun: 'Mekah',
  arti: 'Pembukaan',
);

const tSuratDto2 = SuratDto(
  nomor: 2,
  nama: 'البقرة',
  namaLatin: 'Al-Baqarah',
  jumlahAyat: 286,
  tempatTurun: 'Madinah',
  arti: 'Sapi Betina',
);

const tSurat = Surat(
  nomor: 1,
  nama: 'الفاتحة',
  namaLatin: 'Al-Fatihah',
  jumlahAyat: 7,
  tempatTurun: TempatTurun.mekah,
  arti: 'Pembukaan',
);

const tSurat2 = Surat(
  nomor: 2,
  nama: 'البقرة',
  namaLatin: 'Al-Baqarah',
  jumlahAyat: 286,
  tempatTurun: TempatTurun.madinah,
  arti: 'Sapi Betina',
);

final List<Surat> tSuratList = [tSurat, tSurat2];
final List<SuratDto> tSuratDtoList = [tSuratDto, tSuratDto2];

final tSuratListResponseDto = SuratListResponseDto(
  code: 200,
  message: 'success',
  data: tSuratDtoList,
);

// ── Surat Detail ─────────────────────────────────────────────────────────────

const tAyatDto = AyatDto(
  nomorAyat: 1,
  teksArab: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
  teksLatin: 'bismillāhir-raḥmānir-raḥīm',
  teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
  audio: {'01': 'https://cdn.equran.id/audio/01/001001.mp3'},
);

const tAyat = Ayat(
  nomorAyat: 1,
  teksArab: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
  teksLatin: 'bismillāhir-raḥmānir-raḥīm',
  teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
  audio: {'01': 'https://cdn.equran.id/audio/01/001001.mp3'},
);

const tSuratDetailDto = SuratDetailDto(
  nomor: 1,
  nama: 'الفاتحة',
  namaLatin: 'Al-Fatihah',
  jumlahAyat: 7,
  tempatTurun: 'Mekah',
  arti: 'Pembukaan',
  deskripsi: '<p>Surat Al-Fatihah adalah surat pertama.</p>',
  audioFull: {'01': 'https://cdn.equran.id/audio/01/001.mp3'},
  ayat: [tAyatDto],
  suratSelanjutnya: SuratNavDto(
    nomor: 2,
    namaLatin: 'Al-Baqarah',
    jumlahAyat: 286,
  ),
);

const tSuratDetail = SuratDetail(
  info: tSurat,
  deskripsi: 'Surat Al-Fatihah adalah surat pertama.',
  audioFull: {'01': 'https://cdn.equran.id/audio/01/001.mp3'},
  ayatList: [tAyat],
  suratSelanjutnya: SuratNavigation(
    nomor: 2,
    namaLatin: 'Al-Baqarah',
    jumlahAyat: 286,
  ),
);

const tSuratDetailResponseDto = SuratDetailResponseDto(
  code: 200,
  message: 'success',
  data: tSuratDetailDto,
);

// ── Tafsir ───────────────────────────────────────────────────────────────────

const tTafsirAyatDto = TafsirAyatDto(
  ayat: 1,
  teks: '<p>Tafsir ayat pertama Al-Fatihah.</p>',
);

const tTafsirAyat = TafsirAyat(
  nomorAyat: 1,
  teks: 'Tafsir ayat pertama Al-Fatihah.',
);

const tTafsirDataDto = TafsirDataDto(
  nomor: 1,
  nama: 'الفاتحة',
  namaLatin: 'Al-Fatihah',
  jumlahAyat: 7,
  tempatTurun: 'Mekah',
  arti: 'Pembukaan',
  tafsir: [tTafsirAyatDto],
);

const tTafsirSurat = TafsirSurat(
  info: tSurat,
  tafsirList: [tTafsirAyat],
);

const tTafsirResponseDto = TafsirResponseDto(
  code: 200,
  message: 'success',
  data: tTafsirDataDto,
);
