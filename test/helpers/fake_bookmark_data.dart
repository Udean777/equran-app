import 'package:equran_app/features/bookmark/domain/entities/bookmark.dart';
import 'package:equran_app/features/bookmark/domain/entities/last_read.dart';

final tBookmark = Bookmark(
  suratNomor: 1,
  ayatNomor: 1,
  namaLatin: 'Al-Fatihah',
  teksArab: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
  teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
  savedAt: DateTime(2025, 1, 1, 12),
);

final tBookmark2 = Bookmark(
  suratNomor: 2,
  ayatNomor: 5,
  namaLatin: 'Al-Baqarah',
  teksArab: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
  teksIndonesia: 'Tunjukilah kami jalan yang lurus.',
  savedAt: DateTime(2025, 1, 2, 10),
);

final tLastRead = LastRead(
  suratNomor: 1,
  ayatNomor: 3,
  namaLatin: 'Al-Fatihah',
  readAt: DateTime(2025, 1, 1, 15),
);
