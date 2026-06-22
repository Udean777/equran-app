import 'package:equran_app/features/audio/data/utils/audio_url_builder.dart';
import 'package:equran_app/features/audio/domain/entities/qari.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AudioUrlBuilder', () {
    group('toGlobalAyatNumber', () {
      test('Al-Fatihah ayat 1 → global 1', () {
        expect(
          AudioUrlBuilder.toGlobalAyatNumber(suratNomor: 1, ayatNomor: 1),
          equals(1),
        );
      });

      test('Al-Fatihah ayat 7 → global 7', () {
        expect(
          AudioUrlBuilder.toGlobalAyatNumber(suratNomor: 1, ayatNomor: 7),
          equals(7),
        );
      });

      test('Al-Baqarah ayat 1 → global 8', () {
        expect(
          AudioUrlBuilder.toGlobalAyatNumber(suratNomor: 2, ayatNomor: 1),
          equals(8),
        );
      });

      test('Al-Baqarah ayat 286 → global 293', () {
        expect(
          AudioUrlBuilder.toGlobalAyatNumber(suratNomor: 2, ayatNomor: 286),
          equals(293),
        );
      });

      test('An-Nas ayat 6 → global 6236', () {
        expect(
          AudioUrlBuilder.toGlobalAyatNumber(suratNomor: 114, ayatNomor: 6),
          equals(6236),
        );
      });

      test('Al-Ikhlas ayat 1 → global 6222', () {
        expect(
          AudioUrlBuilder.toGlobalAyatNumber(suratNomor: 112, ayatNomor: 1),
          equals(6222),
        );
      });
    });

    group('buildAyatUrl', () {
      test('build URL dengan bitrate default (128)', () {
        final url = AudioUrlBuilder.buildAyatUrl(
          suratNomor: 1,
          ayatNomor: 1,
          qari: Qari.misyariRasyidAlAfasi,
        );
        expect(
          url,
          equals(
            'https://cdn.islamic.network/quran/audio/128/05/1.mp3',
          ),
        );
      });

      test('build URL dengan bitrate low (32)', () {
        final url = AudioUrlBuilder.buildAyatUrl(
          suratNomor: 1,
          ayatNomor: 1,
          qari: Qari.misyariRasyidAlAfasi,
          bitrate: AudioBitrate.low,
        );
        expect(
          url,
          equals(
            'https://cdn.islamic.network/quran/audio/32/05/1.mp3',
          ),
        );
      });

      test('build URL Al-Baqarah ayat 1 qari 01', () {
        final url = AudioUrlBuilder.buildAyatUrl(
          suratNomor: 2,
          ayatNomor: 1,
          qari: Qari.abdullahAlMatrood,
        );
        expect(
          url,
          equals(
            'https://cdn.islamic.network/quran/audio/128/01/8.mp3',
          ),
        );
      });

      test('URL mengandung nomor ayat global yang benar', () {
        // An-Nas ayat 6 = global 6236
        final url = AudioUrlBuilder.buildAyatUrl(
          suratNomor: 114,
          ayatNomor: 6,
          qari: Qari.abdurrahmanAsSudais,
        );
        expect(url, contains('/6236.mp3'));
        expect(url, contains('/02/'));
      });
    });
  });

  group('Qari', () {
    test('fromId return qari yang benar', () {
      expect(Qari.fromId('01'), equals(Qari.abdullahAlMatrood));
      expect(Qari.fromId('05'), equals(Qari.misyariRasyidAlAfasi));
    });

    test('fromId fallback ke misyari jika id tidak dikenal', () {
      expect(Qari.fromId('99'), equals(Qari.misyariRasyidAlAfasi));
    });

    test('semua qari punya id dan name', () {
      for (final qari in Qari.values) {
        expect(qari.id, isNotEmpty);
        expect(qari.name, isNotEmpty);
      }
    });

    test('ada 5 qari', () {
      expect(Qari.values.length, equals(5));
    });
  });
}
