import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'progress_database.g.dart';

/// Scheduling state of one card for one language pair and direction.
///
/// Progress is kept per pair, so German-from-Persian and Dutch-from-English
/// never share state.
class ReviewStates extends Table {
  TextColumn get cardId => text()();
  TextColumn get target => text()();
  TextColumn get native => text()();
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
  Set<Column> get primaryKey => {cardId, target, native, reversed};
}

/// One answer given on a card.
class ReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cardId => text()();
  TextColumn get target => text()();
  TextColumn get native => text()();
  BoolColumn get reversed => boolean()();

  /// 1 again, 2 hard, 3 good, 4 easy.
  IntColumn get rating => integer()();

  /// True when this was the first time the card was seen.
  BoolColumn get wasNew => boolean()();
  DateTimeColumn get reviewedAt => dateTime()();
}

/// Difficulty the learner chose for a word, replacing the one from the data.
/// Kept per language being learned.
class DifficultyOverrides extends Table {
  TextColumn get cardId => text()();
  TextColumn get target => text()();

  /// `easy`, `medium` or `advanced`.
  TextColumn get difficulty => text()();

  @override
  Set<Column> get primaryKey => {cardId, target};
}

/// Simple key/value settings.
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [ReviewStates, ReviewLogs, Settings, DifficultyOverrides])
class ProgressDatabase extends _$ProgressDatabase {
  ProgressDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX review_states_due ON review_states (target, native, reversed, due)',
      );
      await customStatement('CREATE INDEX review_logs_time ON review_logs (reviewed_at)');
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(difficultyOverrides);
    },
  );

  static QueryExecutor _openConnection() => driftDatabase(
    name: 'progress',
    native: const DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory),
  );
}
