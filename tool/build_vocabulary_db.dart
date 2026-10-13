// Builds assets/vocabulary.db from data/vocabulary.csv, data/conjugations.csv and
// data/languages.json.
//
// Run from the repository root before `flutter run` or `flutter build`:
//   dart run tool/build_vocabulary_db.dart
import 'dart:convert';
import 'dart:io';

import 'package:flashcard/core/language.dart';
import 'package:flashcard/core/vocabulary_db_schema.dart';
import 'package:flashcard/core/vocabulary_source.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final languages = Language.listFromJson(File('data/languages.json').readAsStringSync());
  final List<VocabCard> cards;
  final Map<(String, String), List<Conjugation>> conjugations;
  try {
    cards = readVocabulary(File('data/vocabulary.csv').readAsStringSync(), languages);
    conjugations = readConjugations(
      File('data/conjugations.csv').readAsStringSync(),
      languages,
      {for (final card in cards) card.id},
    );
  } on VocabularyFormatException catch (e) {
    stderr.writeln(e);
    exit(1);
  }

  final out = File('assets/vocabulary.db');
  out.parent.createSync(recursive: true);
  if (out.existsSync()) out.deleteSync();

  final db = sqlite3.open(out.path);
  for (final statement in vocabularySchema) {
    db.execute(statement);
  }
  db.execute('BEGIN');
  db.execute('INSERT INTO meta VALUES (?, ?)', ['schema_version', '$vocabularySchemaVersion']);
  db.execute('INSERT INTO meta VALUES (?, ?)', ['card_count', '${cards.length}']);

  final insertLanguage = db.prepare('INSERT INTO languages VALUES (?, ?, ?)');
  for (var i = 0; i < languages.length; i++) {
    insertLanguage.execute([languages[i].code, i, jsonEncode(languages[i].toJson())]);
  }
  insertLanguage.close();

  final insertCard = db.prepare('INSERT INTO cards VALUES (?, ?, ?, ?)');
  final insertTerm = db.prepare('INSERT INTO terms VALUES (?, ?, ?, ?, ?, ?)');
  for (var i = 0; i < cards.length; i++) {
    final card = cards[i];
    insertCard.execute([card.id, card.level, card.difficulty, i]);
    for (final entry in card.terms.entries) {
      final term = entry.value;
      insertTerm.execute([
        card.id,
        entry.key,
        term.word,
        term.type,
        term.plural,
        term.forms.isEmpty ? null : jsonEncode(term.forms),
      ]);
    }
  }
  insertCard.close();
  insertTerm.close();

  final insertConjugation = db.prepare('INSERT INTO conjugations VALUES (?, ?, ?, ?, ?, ?)');
  for (final MapEntry(key: (id, lang), value: tenses) in conjugations.entries) {
    for (final (i, c) in tenses.indexed) {
      insertConjugation.execute([id, lang, i, c.tense, c.verb, jsonEncode(c.forms)]);
    }
  }
  insertConjugation.close();
  db.execute('COMMIT');
  db.execute('VACUUM');
  db.close();

  stdout.writeln(
    'Wrote ${out.path}: ${cards.length} cards, ${conjugations.length} conjugated verbs, '
    '${languages.map((l) => l.code).join(', ')}',
  );
}
