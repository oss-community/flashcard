import 'language.dart';

/// One word of a card in one language.
class Term {
  const Term({required this.word, required this.type, this.plural});

  /// The word or phrase; nouns carry their article (e.g. `die Frau`).
  final String word;

  /// Word type such as `noun`, `verb` or `phrasal verb`.
  final String type;

  /// Full plural form, `-` when the noun has no plural, null for non-nouns
  /// and languages without a plural column.
  final String? plural;
}

/// One row of the vocabulary: the same meaning in every language.
class VocabCard {
  const VocabCard({required this.id, required this.level, required this.terms});

  final String id;
  final String level;
  final Map<String, Term> terms;
}

/// Word types allowed in the data.
const wordTypes = {
  'noun',
  'verb',
  'adj',
  'adv',
  'prep',
  'pron',
  'conj',
  'det',
  'particle',
  'interj',
  'num',
  'phrasal verb',
  'phrase',
  'idiom',
};

class VocabularyFormatException implements Exception {
  VocabularyFormatException(this.problems);
  final List<String> problems;

  @override
  String toString() =>
      'Vocabulary data has ${problems.length} problem(s):\n${problems.take(20).join('\n')}';
}

/// Parses CSV text (RFC 4180: quoted fields, doubled quotes, CRLF or LF).
List<List<String>> parseCsv(String text) {
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var inQuotes = false;
  var i = 0;
  if (text.startsWith('﻿')) i = 1;
  while (i < text.length) {
    final c = text[i];
    if (inQuotes) {
      if (c == '"') {
        if (i + 1 < text.length && text[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field.write(c);
      }
    } else if (c == '"') {
      inQuotes = true;
    } else if (c == ',') {
      row.add(field.toString());
      field.clear();
    } else if (c == '\n' || c == '\r') {
      if (c == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
      row.add(field.toString());
      field.clear();
      rows.add(row);
      row = <String>[];
    } else {
      field.write(c);
    }
    i++;
  }
  if (field.isNotEmpty || row.isNotEmpty) {
    row.add(field.toString());
    rows.add(row);
  }
  return rows;
}

/// Reads and validates the vocabulary CSV against the language list.
///
/// Each language needs a `<column>` and `<column>_type` column; a
/// `<column>_plural` column is optional. Throws [VocabularyFormatException]
/// listing every problem found.
List<VocabCard> readVocabulary(String csvText, List<Language> languages) {
  final rows = parseCsv(csvText);
  if (rows.isEmpty) throw VocabularyFormatException(['file is empty']);
  final header = rows.first;
  final index = {for (var i = 0; i < header.length; i++) header[i]: i};
  final problems = <String>[];

  for (final name in ['id', 'level']) {
    if (!index.containsKey(name)) problems.add('missing column "$name"');
  }
  for (final lang in languages) {
    for (final name in [lang.column, '${lang.column}_type']) {
      if (!index.containsKey(name)) {
        problems.add('missing column "$name" for language ${lang.code}');
      }
    }
  }
  if (problems.isNotEmpty) throw VocabularyFormatException(problems);

  final cards = <VocabCard>[];
  final seenIds = <String>{};
  for (var r = 1; r < rows.length; r++) {
    final row = rows[r];
    if (row.length == 1 && row.first.isEmpty) continue;
    final line = r + 1;
    if (row.length != header.length) {
      problems.add('line $line: ${row.length} fields, expected ${header.length}');
      continue;
    }
    String cell(String name) => row[index[name]!].trim();

    final id = cell('id');
    final level = cell('level');
    if (id.isEmpty || !seenIds.add(id)) problems.add('line $line: empty or duplicate id "$id"');
    if (!levels.contains(level)) problems.add('line $line: unknown level "$level"');

    final terms = <String, Term>{};
    for (final lang in languages) {
      final word = cell(lang.column);
      final type = cell('${lang.column}_type');
      final pluralColumn = '${lang.column}_plural';
      final plural = index.containsKey(pluralColumn) ? cell(pluralColumn) : '';
      if (word.isEmpty) problems.add('line $line: empty ${lang.column}');
      if (!wordTypes.contains(type)) {
        problems.add('line $line: unknown ${lang.column}_type "$type"');
      }
      terms[lang.code] = Term(
        word: word,
        type: type,
        plural: plural.isEmpty ? null : plural,
      );
    }
    cards.add(VocabCard(id: id, level: level, terms: terms));
  }
  if (problems.isNotEmpty) throw VocabularyFormatException(problems);
  return cards;
}
