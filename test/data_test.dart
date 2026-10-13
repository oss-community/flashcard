import 'dart:convert';
import 'dart:io';

import 'package:flashcard/core/language.dart';
import 'package:flashcard/core/vocabulary_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final languages = Language.listFromJson(File('data/languages.json').readAsStringSync());

  group('parseCsv', () {
    test('handles quotes, commas and CRLF', () {
      expect(parseCsv('a,"b, c","say ""hi"""\r\n1,2,3\r\n'), [
        ['a', 'b, c', 'say "hi"'],
        ['1', '2', '3'],
      ]);
    });
  });

  group('vocabulary.csv', () {
    late List<VocabCard> cards;
    setUpAll(() {
      cards = readVocabulary(File('data/vocabulary.csv').readAsStringSync(), languages);
    });

    test('is valid and complete', () {
      expect(cards.length, greaterThan(9000));
      for (final level in levels) {
        expect(cards.where((c) => c.level == level), isNotEmpty, reason: level);
      }
    });

    test('every card has every language', () {
      for (final card in cards) {
        expect(card.terms.keys.toSet(), languages.map((l) => l.code).toSet(), reason: card.id);
      }
    });

    test('rejects bad rows', () {
      final header = File('data/vocabulary.csv').readAsLinesSync().first;
      final bad = '$header\nx-1,Z9,hi,blah,Hallo,,interj,hallo,,interj,سلام,interj\n';
      expect(() => readVocabulary(bad, languages), throwsA(isA<VocabularyFormatException>()));
    });
  });

  group('languages', () {
    test('every language is named in every menu language', () {
      final codes = languages.map((l) => l.code).toSet();
      for (final lang in languages) {
        expect(lang.names.keys.toSet(), codes, reason: lang.code);
      }
    });

    test('every language has a complete menu translation file', () {
      Set<String> keys(String code) {
        final file = File('lib/l10n/app_$code.arb');
        expect(file.existsSync(), isTrue, reason: 'missing ${file.path}');
        final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        return json.keys.where((k) => !k.startsWith('@')).toSet();
      }

      final english = keys('en');
      for (final lang in languages) {
        expect(keys(lang.code), english, reason: lang.code);
      }
    });
  });
}
