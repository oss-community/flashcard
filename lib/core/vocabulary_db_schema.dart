/// Schema of `vocabulary.db`, the read-only word database built from
/// `data/vocabulary.csv` by `tool/build_vocabulary_db.dart`.
///
/// Languages are rows, not columns, so a new language needs no schema change.
const vocabularySchemaVersion = 2;

const vocabularySchema = [
  'CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
  'CREATE TABLE languages (code TEXT PRIMARY KEY, position INTEGER NOT NULL, '
      'json TEXT NOT NULL)',
  'CREATE TABLE cards (id TEXT PRIMARY KEY, level TEXT NOT NULL, '
      'difficulty TEXT NOT NULL, position INTEGER NOT NULL)',
  'CREATE TABLE terms (card_id TEXT NOT NULL REFERENCES cards (id), '
      'lang TEXT NOT NULL REFERENCES languages (code), word TEXT NOT NULL, '
      'type TEXT NOT NULL, plural TEXT, PRIMARY KEY (card_id, lang))',
];
