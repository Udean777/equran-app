import 'package:equran_app/core/utils/html_stripper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringHtmlStripper', () {
    test('strip tag HTML sederhana', () {
      expect('<p>Hello</p>'.stripHtml(), 'Hello');
    });

    test('strip tag HTML nested', () {
      expect('<p><b>Hello</b> World</p>'.stripHtml(), 'Hello World');
    });

    test('decode &nbsp;', () {
      expect('Hello&nbsp;World'.stripHtml(), 'Hello World');
    });

    test('decode &amp;', () {
      expect('A &amp; B'.stripHtml(), 'A & B');
    });

    test('decode &lt; dan &gt;', () {
      expect('&lt;tag&gt;'.stripHtml(), '<tag>');
    });

    test('trim whitespace', () {
      expect('  Hello  '.stripHtml(), 'Hello');
    });

    test('string tanpa HTML tidak berubah', () {
      expect('Plain text'.stripHtml(), 'Plain text');
    });

    test('string kosong tetap kosong', () {
      expect(''.stripHtml(), '');
    });
  });
}
