import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../core/language.dart';
import '../core/vocabulary_db_schema.dart';
import '../core/vocabulary_source.dart';

/// All words and languages, loaded once from `vocabulary.db`.
///
/// The database is small (about nine thousand cards), so it is read into
/// memory at start-up and searched there.
class Vocabulary {
  Vocabulary({required this.languages, required this.cards, this.path, this.conjugated = const {}});

  final List<Language> languages;
  final List<VocabCard> cards;

  /// The database file; conjugation tables are read from it when needed.
  final String? path;

  /// Card id and language code of every verb with a conjugation table.
  final Set<(String, String)> conjugated;

  /// True when the verb of card [cardId] has a conjugation table in [lang].
  bool hasConjugation(String cardId, String lang) => conjugated.contains((cardId, lang));

  /// Every tense of the verb of card [cardId] in [lang], in the data's order.
  List<Conjugation> conjugations(String cardId, String lang) {
    if (path == null || !hasConjugation(cardId, lang)) return const [];
    final db = sqlite3.open(path!, mode: OpenMode.readOnly);
    try {
      return [
        for (final row in db.select(
          'SELECT tense, verb, forms FROM conjugations WHERE card_id = ? AND lang = ? '
          'ORDER BY position',
          [cardId, lang],
        ))
          Conjugation(
            tense: row['tense'] as String,
            verb: row['verb'] as String,
            forms: (jsonDecode(row['forms'] as String) as List).cast<String>(),
          ),
      ];
    } finally {
      db.close();
    }
  }

  Language language(String code) => languages.firstWhere((l) => l.code == code);

  /// Copies the bundled database next to the progress database and reads it.
  static Future<Vocabulary> load() async {
    final asset = await rootBundle.load('assets/vocabulary.db');
    final bytes = asset.buffer.asUint8List(asset.offsetInBytes, asset.lengthInBytes);
    final dir = await getApplicationSupportDirectory();
    await dir.create(recursive: true);
    final file = File('${dir.path}${Platform.pathSeparator}vocabulary.db');
    if (!file.existsSync() || file.lengthSync() != bytes.length) {
      await file.writeAsBytes(bytes, flush: true);
    } else {
      // Same size: only rewrite if the content changed.
      final current = await file.readAsBytes();
      if (!_sameBytes(current, bytes)) await file.writeAsBytes(bytes, flush: true);
    }
    return fromFile(file.path);
  }

  /// Reads a vocabulary database file built by `tool/build_vocabulary_db.dart`.
  static Vocabulary fromFile(String path) {
    final db = sqlite3.open(path, mode: OpenMode.readOnly);
    try {
      final version = db.select("SELECT value FROM meta WHERE key = 'schema_version'");
      if (version.isEmpty || version.first['value'] != '$vocabularySchemaVersion') {
        throw StateError('vocabulary.db has an unsupported schema version');
      }
      final languages = [
        for (final row in db.select('SELECT json FROM languages ORDER BY position'))
          Language.fromJson(jsonDecode(row['json'] as String) as Map<String, dynamic>),
      ];
      final terms = <String, Map<String, Term>>{};
      for (final row in db.select('SELECT card_id, lang, word, type, plural, forms FROM terms')) {
        final forms = row['forms'] as String?;
        (terms[row['card_id'] as String] ??= {})[row['lang'] as String] = Term(
          word: row['word'] as String,
          type: row['type'] as String,
          plural: row['plural'] as String?,
          forms: forms == null
              ? const {}
              : (jsonDecode(forms) as Map<String, dynamic>).cast<String, String>(),
        );
      }
      final conjugated = {
        for (final row in db.select('SELECT DISTINCT card_id, lang FROM conjugations'))
          (row['card_id'] as String, row['lang'] as String),
      };
      final cards = [
        for (final row in db.select('SELECT id, level, difficulty FROM cards ORDER BY position'))
          VocabCard(
            id: row['id'] as String,
            level: row['level'] as String,
            difficulty: row['difficulty'] as String,
            terms: terms[row['id'] as String] ?? const {},
          ),
      ];
      return Vocabulary(languages: languages, cards: cards, path: path, conjugated: conjugated);
    } finally {
      db.close();
    }
  }

  static bool _sameBytes(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
