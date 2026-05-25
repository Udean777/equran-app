import 'package:equran_app/features/doa/data/models/doa_dto.dart';
import 'package:equran_app/features/doa/domain/entities/doa.dart';
import 'package:equran_app/features/imsakiyah/data/models/imsakiyah_dto.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah_entry.dart';
import 'package:equran_app/features/jadwal_shalat/data/models/jadwal_shalat_dto.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat.dart';
import 'package:equran_app/features/jadwal_shalat/domain/entities/jadwal_shalat_entry.dart';
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

// ── Doa ──────────────────────────────────────────────────────────────────────

const tDoaDto1 = DoaDto(
  id: 1,
  grup: 'Doa Sebelum dan Sesudah Tidur',
  nama: 'Doa Sebelum Tidur 1',
  ar: 'بِاسْمِكَ رَبِّيْ وَضَعْتُ جَنْبِيْ',
  tr: "Bismika robbii wa dho'tu janbii.",
  idn: 'Dengan nama Engkau, wahai Tuhanku, aku meletakkan lambungku.',
  tentang: 'HR. Al-Bukhari 11/126, Muslim 4/2084.',
  tag: ['tidur', 'malam'],
);

const tDoaDto2 = DoaDto(
  id: 2,
  grup: 'Doa di Kamar Mandi',
  nama: 'Doa Masuk Kamar Mandi',
  ar: 'اَللَّهُمَّ إِنِّيْ أَعُوْذُ بِكَ',
  tr: "Allaahumma innii a'uudzu bika.",
  idn: 'Ya Allah, aku berlindung kepada-Mu.',
  tentang: 'HR. Al-Bukhari 1/45.',
  tag: ['kamar mandi'],
);

// Edge case: id 42 — tr dan idn kosong
const tDoaDto42 = DoaDto(
  id: 42,
  grup: 'Doa Saat Mendapat Kabar',
  nama: 'Bila Ada Sesuatu Yang Menggembirakan',
  ar: "Nabi Shallallahu'alaihi wasallam apabila ada sesuatu yang menggembirakan.",
  tentang: 'HR. Ashhabus Sunan.',
  tag: ['umum'],
);

const tDoa1 = Doa(
  id: 1,
  grup: 'Doa Sebelum dan Sesudah Tidur',
  nama: 'Doa Sebelum Tidur 1',
  ar: 'بِاسْمِكَ رَبِّيْ وَضَعْتُ جَنْبِيْ',
  tr: "Bismika robbii wa dho'tu janbii.",
  idn: 'Dengan nama Engkau, wahai Tuhanku, aku meletakkan lambungku.',
  tentang: 'HR. Al-Bukhari 11/126, Muslim 4/2084.',
  tag: ['tidur', 'malam'],
);

const tDoa2 = Doa(
  id: 2,
  grup: 'Doa di Kamar Mandi',
  nama: 'Doa Masuk Kamar Mandi',
  ar: 'اَللَّهُمَّ إِنِّيْ أَعُوْذُ بِكَ',
  tr: "Allaahumma innii a'uudzu bika.",
  idn: 'Ya Allah, aku berlindung kepada-Mu.',
  tentang: 'HR. Al-Bukhari 1/45.',
  tag: ['kamar mandi'],
);

const tDoa42 = Doa(
  id: 42,
  grup: 'Doa Saat Mendapat Kabar',
  nama: 'Bila Ada Sesuatu Yang Menggembirakan',
  ar: "Nabi Shallallahu'alaihi wasallam apabila ada sesuatu yang menggembirakan.",
  tr: '',
  idn: '',
  tentang: 'HR. Ashhabus Sunan.',
  tag: ['umum'],
);

final List<Doa> tDoaList = [tDoa1, tDoa2];
final List<DoaDto> tDoaDtoList = [tDoaDto1, tDoaDto2];

final tDoaListResponseDto = DoaListResponseDto(
  status: 'success',
  total: 2,
  data: tDoaDtoList,
);

const tDoaDetailResponseDto = DoaDetailResponseDto(
  status: 'success',
  data: tDoaDto1,
);

// ── Imsakiyah ────────────────────────────────────────────────────────────────

const tProvinsiList = ['Sumatera Utara', 'Jawa Barat', 'DKI Jakarta'];

const tKabkotaList = ['Kab. Deli Serdang', 'Kota Medan', 'Kota Binjai'];

const tImsakiyahEntryDto1 = ImsakiyahEntryDto(
  tanggal: 1,
  imsak: '05:12',
  subuh: '05:22',
  terbit: '06:35',
  dhuha: '07:02',
  dzuhur: '12:42',
  ashar: '16:00',
  maghrib: '18:42',
  isya: '19:51',
);

const tImsakiyahEntryDto2 = ImsakiyahEntryDto(
  tanggal: 2,
  imsak: '05:12',
  subuh: '05:22',
  terbit: '06:34',
  dhuha: '07:02',
  dzuhur: '12:42',
  ashar: '16:00',
  maghrib: '18:42',
  isya: '19:51',
);

const tImsakiyahDto = ImsakiyahDto(
  provinsi: 'Sumatera Utara',
  kabkota: 'Kab. Deli Serdang',
  hijriah: '1447',
  masehi: '2026',
  imsakiyah: [tImsakiyahEntryDto1, tImsakiyahEntryDto2],
);

const tImsakiyahResponseDto = ImsakiyahResponseDto(
  code: 200,
  message: 'Jadwal imsakiyah berhasil diambil',
  data: tImsakiyahDto,
);

const tProvinsiResponseDto = ProvinsiResponseDto(
  code: 200,
  message: 'Data retrieved successfully',
  data: tProvinsiList,
);

const tKabkotaResponseDto = KabkotaResponseDto(
  code: 200,
  message: 'Data retrieved successfully',
  data: tKabkotaList,
);

const tImsakiyahEntry1 = ImsakiyahEntry(
  tanggal: 1,
  imsak: '05:12',
  subuh: '05:22',
  terbit: '06:35',
  dhuha: '07:02',
  dzuhur: '12:42',
  ashar: '16:00',
  maghrib: '18:42',
  isya: '19:51',
);

const tImsakiyahEntry2 = ImsakiyahEntry(
  tanggal: 2,
  imsak: '05:12',
  subuh: '05:22',
  terbit: '06:34',
  dhuha: '07:02',
  dzuhur: '12:42',
  ashar: '16:00',
  maghrib: '18:42',
  isya: '19:51',
);

const tImsakiyah = Imsakiyah(
  provinsi: 'Sumatera Utara',
  kabkota: 'Kab. Deli Serdang',
  hijriah: '1447',
  masehi: '2026',
  imsakiyah: [tImsakiyahEntry1, tImsakiyahEntry2],
);

// ── Jadwal Shalat ─────────────────────────────────────────────────────────────

const tJadwalShalatEntryDto1 = JadwalShalatEntryDto(
  tanggal: 25,
  tanggalLengkap: '2026-05-25',
  hari: 'Senin',
  imsak: '04:26',
  subuh: '04:36',
  terbit: '05:50',
  dhuha: '06:18',
  dzuhur: '11:53',
  ashar: '15:14',
  maghrib: '17:50',
  isya: '19:00',
);

const tJadwalShalatEntryDto2 = JadwalShalatEntryDto(
  tanggal: 26,
  tanggalLengkap: '2026-05-26',
  hari: 'Selasa',
  imsak: '04:26',
  subuh: '04:36',
  terbit: '05:50',
  dhuha: '06:18',
  dzuhur: '11:53',
  ashar: '15:14',
  maghrib: '17:50',
  isya: '19:00',
);

const tJadwalShalatDto = JadwalShalatDto(
  provinsi: 'DKI Jakarta',
  kabkota: 'Kota Jakarta',
  bulan: 5,
  tahun: 2026,
  bulanNama: 'Mei',
  jadwal: [tJadwalShalatEntryDto1, tJadwalShalatEntryDto2],
);

const tJadwalShalatResponseDto = JadwalShalatResponseDto(
  code: 200,
  message: 'Jadwal shalat berhasil diambil',
  data: tJadwalShalatDto,
);

const tProvinsiShalatResponseDto = ProvinsiShalatResponseDto(
  code: 200,
  message: 'Daftar provinsi berhasil diambil',
  data: tProvinsiList,
);

const tKabkotaShalatResponseDto = KabkotaShalatResponseDto(
  code: 200,
  message: 'Daftar kabupaten/kota di DKI Jakarta',
  data: tKabkotaJakartaList,
);

const tKabkotaJakartaList = ['Kab. Kepulauan Seribu', 'Kota Jakarta'];

const tJadwalShalatEntry1 = JadwalShalatEntry(
  tanggal: 25,
  tanggalLengkap: '2026-05-25',
  hari: 'Senin',
  imsak: '04:26',
  subuh: '04:36',
  terbit: '05:50',
  dhuha: '06:18',
  dzuhur: '11:53',
  ashar: '15:14',
  maghrib: '17:50',
  isya: '19:00',
);

const tJadwalShalatEntry2 = JadwalShalatEntry(
  tanggal: 26,
  tanggalLengkap: '2026-05-26',
  hari: 'Selasa',
  imsak: '04:26',
  subuh: '04:36',
  terbit: '05:50',
  dhuha: '06:18',
  dzuhur: '11:53',
  ashar: '15:14',
  maghrib: '17:50',
  isya: '19:00',
);

const tJadwalShalat = JadwalShalat(
  provinsi: 'DKI Jakarta',
  kabkota: 'Kota Jakarta',
  bulan: 5,
  tahun: 2026,
  bulanNama: 'Mei',
  jadwal: [tJadwalShalatEntry1, tJadwalShalatEntry2],
);
