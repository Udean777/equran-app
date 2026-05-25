import 'package:equran_app/features/doa/presentation/widgets/doa_card.dart';
import 'package:equran_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_data.dart';

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  group('DoaCard', () {
    testWidgets('menampilkan nama doa', (tester) async {
      await tester.pumpWidget(
        _wrap(DoaCard(doa: tDoa1, onTap: () {})),
      );
      expect(find.text('Doa Sebelum Tidur 1'), findsOneWidget);
    });

    testWidgets('menampilkan nama grup', (tester) async {
      await tester.pumpWidget(
        _wrap(DoaCard(doa: tDoa1, onTap: () {})),
      );
      expect(find.text('Doa Sebelum dan Sesudah Tidur'), findsOneWidget);
    });

    testWidgets('menampilkan preview idn jika tidak kosong', (tester) async {
      await tester.pumpWidget(
        _wrap(DoaCard(doa: tDoa1, onTap: () {})),
      );
      expect(
        find.textContaining('Dengan nama Engkau'),
        findsOneWidget,
      );
    });

    testWidgets('tidak menampilkan preview idn jika kosong (id 42)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(DoaCard(doa: tDoa42, onTap: () {})),
      );
      // idn kosong — tidak ada text preview terjemahan
      expect(find.textContaining('Dengan nama'), findsNothing);
    });

    testWidgets('menampilkan tag chips', (tester) async {
      await tester.pumpWidget(
        _wrap(DoaCard(doa: tDoa1, onTap: () {})),
      );
      expect(find.textContaining('#tidur'), findsOneWidget);
      expect(find.textContaining('#malam'), findsOneWidget);
    });

    testWidgets('memanggil onTap saat card ditekan', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(DoaCard(doa: tDoa1, onTap: () => tapped = true)),
      );
      await tester.tap(find.byType(DoaCard));
      expect(tapped, isTrue);
    });

    testWidgets('menampilkan overflow chip jika tag lebih dari 3',
        (tester) async {
      final doaBanyakTag = tDoa1.copyWith(
        tag: ['tidur', 'malam', 'pagi', 'siang', 'sore'],
      );
      await tester.pumpWidget(
        _wrap(DoaCard(doa: doaBanyakTag, onTap: () {})),
      );
      // Max 3 visible + 1 overflow chip (+2)
      expect(find.textContaining('#+2'), findsOneWidget);
    });
  });
}
