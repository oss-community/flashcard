import 'package:drift/drift.dart';

import '../domain/profile.dart';
import '../domain/srs.dart';
import '../domain/stats.dart';
import 'progress_database.dart';

/// Reads and writes the learner's progress and settings.
class ProgressRepository {
  ProgressRepository(this._db);

  final ProgressDatabase _db;

  /// Every profile, oldest first.
  Future<List<Profile>> profiles() async {
    final rows = await (_db.select(
      _db.profiles,
    )..orderBy([(t) => OrderingTerm(expression: t.id)])).get();
    return [
      for (final row in rows)
        Profile(
          id: row.id,
          name: row.name,
          native: row.native,
          target: row.target,
          level: row.level,
          dailyGoal: row.dailyGoal,
          reversed: row.reversed,
          showForms: row.showForms,
        ),
    ];
  }

  /// Adds a profile and returns it with its new id.
  Future<Profile> createProfile({
    String? name,
    required String native,
    required String target,
    String? level,
  }) async {
    final id = await _db
        .into(_db.profiles)
        .insert(
          ProfilesCompanion.insert(
            name: Value(cleanName(name)),
            native: native,
            target: target,
            level: Value(level),
          ),
        );
    return Profile(id: id, name: cleanName(name), native: native, target: target, level: level);
  }

  /// Saves everything but the languages, which never change.
  Future<void> updateProfile(Profile profile) =>
      (_db.update(_db.profiles)..where((t) => t.id.equals(profile.id))).write(
        ProfilesCompanion(
          name: Value(profile.name),
          level: Value(profile.level),
          dailyGoal: Value(profile.dailyGoal),
          reversed: Value(profile.reversed),
          showForms: Value(profile.showForms),
        ),
      );

  /// Removes a profile with all of its progress.
  Future<void> deleteProfile(int id) => _db.transaction(() async {
    await (_db.delete(_db.reviewStates)..where((t) => t.profileId.equals(id))).go();
    await (_db.delete(_db.reviewLogs)..where((t) => t.profileId.equals(id))).go();
    await (_db.delete(_db.difficultyOverrides)..where((t) => t.profileId.equals(id))).go();
    await (_db.delete(_db.profiles)..where((t) => t.id.equals(id))).go();
  });

  /// Schedules of every card studied in [profile] in one direction, by card id.
  Future<Map<String, Schedule>> schedules(int profile, {required bool reversed}) async {
    final rows = await (_db.select(
      _db.reviewStates,
    )..where((t) => t.profileId.equals(profile) & t.reversed.equals(reversed))).get();
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
    required int profile,
    required bool reversed,
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
              profileId: profile,
              cardId: cardId,
              reversed: reversed,
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
              profileId: profile,
              cardId: cardId,
              reversed: reversed,
              rating: rating.value,
              wasNew: wasNew,
              reviewedAt: at,
            ),
          );
    });
  }

  /// Answers given in [profile] since local midnight: all of them and new cards.
  Future<({int reviews, int newCards})> today(int profile, DateTime now) async {
    final logs = _db.reviewLogs;
    final count = logs.id.count();
    final newCount = logs.id.count(filter: logs.wasNew.equals(true));
    final row =
        await (_db.selectOnly(logs)
              ..addColumns([count, newCount])
              ..where(
                logs.profileId.equals(profile) & logs.reviewedAt.isBiggerOrEqualValue(dayOf(now)),
              ))
            .getSingle();
    return (reviews: row.read(count) ?? 0, newCards: row.read(newCount) ?? 0);
  }

  /// Number of answers in [profile] per local day over the last [days] days.
  Future<Map<DateTime, int>> countsByDay(int profile, DateTime now, int days) async {
    final today = dayOf(now);
    final since = DateTime(today.year, today.month, today.day - days + 1);
    final at = _db.reviewLogs.reviewedAt;
    final rows =
        await (_db.selectOnly(_db.reviewLogs)
              ..addColumns([at])
              ..where(_db.reviewLogs.profileId.equals(profile) & at.isBiggerOrEqualValue(since)))
            .get();
    final counts = <DateTime, int>{};
    for (final row in rows) {
      final day = dayOf(row.read(at)!);
      counts[day] = (counts[day] ?? 0) + 1;
    }
    return counts;
  }

  /// Every local day on which at least one answer was given in [profile].
  Future<Set<DateTime>> reviewDays(int profile) async {
    final at = _db.reviewLogs.reviewedAt;
    final rows =
        await (_db.selectOnly(_db.reviewLogs)
              ..addColumns([at])
              ..where(_db.reviewLogs.profileId.equals(profile)))
            .get();
    return {
      for (final row in rows)
        if (row.read(at) case final DateTime time) dayOf(time),
    };
  }

  /// Difficulties the learner changed in [profile], by card id.
  Future<Map<String, String>> difficultyOverrides(int profile) async {
    final rows = await (_db.select(
      _db.difficultyOverrides,
    )..where((t) => t.profileId.equals(profile))).get();
    return {for (final row in rows) row.cardId: row.difficulty};
  }

  Future<void> setDifficulty(int profile, String cardId, String difficulty) => _db
      .into(_db.difficultyOverrides)
      .insertOnConflictUpdate(
        DifficultyOverridesCompanion.insert(
          profileId: profile,
          cardId: cardId,
          difficulty: difficulty,
        ),
      );

  Future<Map<String, String>> readSettings() async {
    final rows = await _db.select(_db.settings).get();
    return {for (final row in rows) row.key: row.value};
  }

  Future<void> writeSetting(String key, String value) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
}
