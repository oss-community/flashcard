import 'package:drift/drift.dart';

import '../domain/pair.dart';
import '../domain/srs.dart';
import '../domain/stats.dart';
import 'progress_database.dart';

/// Reads and writes the learner's progress and settings.
class ProgressRepository {
  ProgressRepository(this._db);

  final ProgressDatabase _db;

  Expression<bool> _isPair($ReviewStatesTable t, LanguagePair pair) =>
      t.target.equals(pair.target) &
      t.native.equals(pair.native) &
      t.reversed.equals(pair.reversed);

  /// Schedules of every card studied in [pair], by card id.
  Future<Map<String, Schedule>> schedules(LanguagePair pair) async {
    final rows = await (_db.select(_db.reviewStates)..where((t) => _isPair(t, pair))).get();
    return {
      for (final row in rows)
        row.cardId: Schedule(
          state: State.fromValue(row.state),
          step: row.step,
          stability: row.stability,
          difficulty: row.difficulty,
          due: row.due.toUtc(),
          lastReview: row.lastReview?.toUtc(),
          reps: row.reps,
          lapses: row.lapses,
        ),
    };
  }

  /// Stores an answer: the card's new schedule and a log entry.
  Future<void> saveReview({
    required LanguagePair pair,
    required String cardId,
    required Schedule schedule,
    required Rating rating,
    required bool wasNew,
    required DateTime at,
  }) {
    return _db.transaction(() async {
      await _db
          .into(_db.reviewStates)
          .insertOnConflictUpdate(
            ReviewStatesCompanion.insert(
              cardId: cardId,
              target: pair.target,
              native: pair.native,
              reversed: pair.reversed,
              state: schedule.state.value,
              step: Value(schedule.step),
              stability: Value(schedule.stability),
              difficulty: Value(schedule.difficulty),
              due: schedule.due,
              lastReview: Value(schedule.lastReview),
              reps: Value(schedule.reps),
              lapses: Value(schedule.lapses),
            ),
          );
      await _db
          .into(_db.reviewLogs)
          .insert(
            ReviewLogsCompanion.insert(
              cardId: cardId,
              target: pair.target,
              native: pair.native,
              reversed: pair.reversed,
              rating: rating.value,
              wasNew: wasNew,
              reviewedAt: at,
            ),
          );
    });
  }

  /// Answers given since local midnight in [pair]: all of them and new cards.
  Future<({int reviews, int newCards})> today(LanguagePair pair, DateTime now) async {
    final logs = _db.reviewLogs;
    final count = logs.id.count();
    final newCount = logs.id.count(filter: logs.wasNew.equals(true));
    final row =
        await (_db.selectOnly(logs)
              ..addColumns([count, newCount])
              ..where(
                logs.target.equals(pair.target) &
                    logs.native.equals(pair.native) &
                    logs.reversed.equals(pair.reversed) &
                    logs.reviewedAt.isBiggerOrEqualValue(dayOf(now)),
              ))
            .getSingle();
    return (reviews: row.read(count) ?? 0, newCards: row.read(newCount) ?? 0);
  }

  /// Number of answers per local day over the last [days] days, all pairs.
  Future<Map<DateTime, int>> countsByDay(DateTime now, int days) async {
    final today = dayOf(now);
    final since = DateTime(today.year, today.month, today.day - days + 1);
    final rows = await (_db.select(
      _db.reviewLogs,
    )..where((t) => t.reviewedAt.isBiggerOrEqualValue(since))).get();
    final counts = <DateTime, int>{};
    for (final row in rows) {
      final day = dayOf(row.reviewedAt);
      counts[day] = (counts[day] ?? 0) + 1;
    }
    return counts;
  }

  /// Every local day on which at least one answer was given.
  Future<Set<DateTime>> reviewDays() async {
    final at = _db.reviewLogs.reviewedAt;
    final rows = await (_db.selectOnly(_db.reviewLogs)..addColumns([at])).get();
    return {
      for (final row in rows)
        if (row.read(at) case final DateTime time) dayOf(time),
    };
  }

  /// Difficulties the learner changed for words of [target], by card id.
  Future<Map<String, String>> difficultyOverrides(String target) async {
    final rows = await (_db.select(
      _db.difficultyOverrides,
    )..where((t) => t.target.equals(target))).get();
    return {for (final row in rows) row.cardId: row.difficulty};
  }

  Future<void> setDifficulty(String cardId, String target, String difficulty) => _db
      .into(_db.difficultyOverrides)
      .insertOnConflictUpdate(
        DifficultyOverridesCompanion.insert(cardId: cardId, target: target, difficulty: difficulty),
      );

  Future<Map<String, String>> readSettings() async {
    final rows = await _db.select(_db.settings).get();
    return {for (final row in rows) row.key: row.value};
  }

  Future<void> writeSetting(String key, String value) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
}
