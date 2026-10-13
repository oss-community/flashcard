import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../core/language.dart';

part 'progress_database.g.dart';

/// A learner's study setup: the two languages and how they study them.
///
/// Every profile keeps its own progress, so German-from-Persian and
/// Dutch-from-English never share state.
@DataClassName('ProfileRow')
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Chosen by the learner; null shows a name made from the two languages.
  TextColumn get name => text().nullable()();
  TextColumn get native => text()();
  TextColumn get target => text()();

  /// Level new cards come from; null means every level in order.
  TextColumn get level => text().nullable()();
  IntColumn get dailyGoal => integer().withDefault(const Constant(0))();
  BoolColumn get reversed => boolean().withDefault(const Constant(false))();

  /// Show plurals, verb forms and comparisons on the back of the card.
  BoolColumn get showForms => boolean().withDefault(const Constant(true))();
}

/// Scheduling state of one card for one profile and direction.
class ReviewStates extends Table {
  IntColumn get profileId => integer()();
  TextColumn get cardId => text()();
  BoolColumn get reversed => boolean()();

  /// FSRS state: 1 learning, 2 review, 3 relearning.
  IntColumn get state => integer()();
  IntColumn get step => integer().nullable()();
  RealColumn get stability => real().nullable()();
  RealColumn get difficulty => real().nullable()();
  DateTimeColumn get due => dateTime()();
  DateTimeColumn get lastReview => dateTime().nullable()();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {profileId, cardId, reversed};
}

/// One answer given on a card.
class ReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer()();
  TextColumn get cardId => text()();
  BoolColumn get reversed => boolean()();

  /// 1 again, 2 hard, 3 good, 4 easy.
  IntColumn get rating => integer()();

  /// True when this was the first time the card was seen.
  BoolColumn get wasNew => boolean()();
  DateTimeColumn get reviewedAt => dateTime()();
}

/// Difficulty the learner chose for a word, replacing the one from the data.
/// Kept per profile.
class DifficultyOverrides extends Table {
  IntColumn get profileId => integer()();
  TextColumn get cardId => text()();

  /// `easy`, `medium` or `advanced`.
  TextColumn get difficulty => text()();

  @override
  Set<Column> get primaryKey => {profileId, cardId};
}

/// Simple key/value settings shared by every profile.
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [Profiles, ReviewStates, ReviewLogs, Settings, DifficultyOverrides])
class ProgressDatabase extends _$ProgressDatabase {
  ProgressDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Shape of version 2; moved into profiles right below.
        await customStatement(
          'CREATE TABLE difficulty_overrides (card_id TEXT NOT NULL, target TEXT NOT NULL, '
          'difficulty TEXT NOT NULL, PRIMARY KEY (card_id, target))',
        );
      }
      if (from < 3) await _moveIntoProfiles(m);
    },
  );

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX review_states_due ON review_states (profile_id, reversed, due)',
    );
    await customStatement('CREATE INDEX review_logs_time ON review_logs (profile_id, reviewed_at)');
  }

  /// Version 3 keeps progress per profile instead of per language pair: one
  /// profile is made for every pair that has progress, the chosen pair first.
  Future<void> _moveIntoProfiles(Migrator m) async {
    final old = {
      for (final row in await customSelect('SELECT key, value FROM settings').get())
        row.read<String>('key'): row.read<String>('value'),
    };
    final pairs = <(String, String)>[];
    final (target, native) = (old['target'], old['native']);
    if (target != null && native != null && target != native) pairs.add((target, native));
    final studied = await customSelect(
      'SELECT target, native FROM review_states UNION SELECT target, native FROM review_logs',
    ).get();
    for (final row in studied) {
      final pair = (row.read<String>('target'), row.read<String>('native'));
      if (pair.$1 != pair.$2 && !pairs.contains(pair)) pairs.add(pair);
    }

    for (final table in ['review_states', 'review_logs', 'difficulty_overrides']) {
      await customStatement('ALTER TABLE $table RENAME TO ${table}_old');
    }
    await customStatement('DROP INDEX IF EXISTS review_states_due');
    await customStatement('DROP INDEX IF EXISTS review_logs_time');
    await m.createTable(profiles);
    await m.createTable(reviewStates);
    await m.createTable(reviewLogs);
    await m.createTable(difficultyOverrides);
    await _createIndexes();

    int? first;
    for (final (i, (target, native)) in pairs.indexed) {
      final chosen = i == 0 && target == old['target'] && native == old['native'];
      final id = await into(profiles).insert(
        ProfilesCompanion.insert(
          native: native,
          target: target,
          level: Value(chosen && levels.contains(old['level']) ? old['level'] : null),
          dailyGoal: Value(chosen ? (int.tryParse(old['dailyGoal'] ?? '') ?? 0) : 0),
          reversed: Value(chosen && old['reversed'] == 'true'),
        ),
      );
      first ??= id;
      final args = [id, target, native];
      await customStatement(
        'INSERT INTO review_states (profile_id, card_id, reversed, state, step, stability, '
        'difficulty, due, last_review, reps, lapses) SELECT ?1, card_id, reversed, state, step, '
        'stability, difficulty, due, last_review, reps, lapses FROM review_states_old '
        'WHERE target = ?2 AND native = ?3',
        args,
      );
      await customStatement(
        'INSERT INTO review_logs (profile_id, card_id, reversed, rating, was_new, reviewed_at) '
        'SELECT ?1, card_id, reversed, rating, was_new, reviewed_at FROM review_logs_old '
        'WHERE target = ?2 AND native = ?3 ORDER BY id',
        args,
      );
      await customStatement(
        'INSERT INTO difficulty_overrides (profile_id, card_id, difficulty) '
        'SELECT ?1, card_id, difficulty FROM difficulty_overrides_old WHERE target = ?2',
        args.sublist(0, 2),
      );
    }

    for (final table in ['review_states', 'review_logs', 'difficulty_overrides']) {
      await customStatement('DROP TABLE ${table}_old');
    }
    await customStatement(
      "DELETE FROM settings WHERE key IN ('native', 'target', 'level', 'dailyGoal', 'reversed')",
    );
    if (first != null) {
      await into(settings)
          .insertOnConflictUpdate(SettingsCompanion.insert(key: 'activeProfile', value: '$first'));
    }
  }

  static QueryExecutor _openConnection() => driftDatabase(
    name: 'progress',
    native: const DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory),
  );
}
