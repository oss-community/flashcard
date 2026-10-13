import 'package:fsrs/fsrs.dart' as fsrs;

export 'package:fsrs/fsrs.dart' show Rating, State;

/// Scheduling state of one card, as stored in the progress database.
class Schedule {
  const Schedule({
    required this.state,
    required this.due,
    this.step,
    this.stability,
    this.difficulty,
    this.lastReview,
    this.reps = 0,
    this.lapses = 0,
  });

  /// A card that has never been studied, due right away.
  factory Schedule.fresh(DateTime now) =>
      Schedule(state: fsrs.State.learning, step: 0, due: now.toUtc());

  final fsrs.State state;
  final int? step;
  final double? stability;
  final double? difficulty;
  final DateTime due;
  final DateTime? lastReview;
  final int reps;
  final int lapses;

  /// True once the card has graduated from the first learning steps.
  bool get isLearned => state == fsrs.State.review;

  fsrs.Card _toCard() => fsrs.Card(
    cardId: 0,
    state: state,
    step: step,
    stability: stability,
    difficulty: difficulty,
    due: due.toUtc(),
    lastReview: lastReview?.toUtc(),
  );
}

/// The answer to give the scheduler when the learner remembered a word of
/// [difficulty]. A new easy word skips the short learning steps and first
/// comes back after a week; every other remembered answer is Good.
fsrs.Rating rememberedRating(String difficulty, Schedule schedule) =>
    difficulty == 'easy' && schedule.state != fsrs.State.review
    ? fsrs.Rating.easy
    : fsrs.Rating.good;

/// FSRS difficulty (1 to 10) given to a remembered word with this label. The
/// higher it is, the more slowly the time between reviews grows. Medium words
/// keep the difficulty FSRS works out from the answers.
const _labelDifficulty = {'easy': 4.0, 'advanced': 8.0};

/// FSRS default parameters, except that a new word answered Easy first comes
/// back after about a week instead of about 16 days.
final parameters = [...fsrs.defaultParameters]..[3] = 7.0;

/// Spaced repetition with the FSRS algorithm.
class Srs {
  Srs({bool fuzz = true}) : _scheduler = _make(fuzz), _preview = _make(false);

  static fsrs.Scheduler _make(bool fuzz) =>
      fsrs.Scheduler(parameters: parameters, maximumInterval: 365, enableFuzzing: fuzz);

  final fsrs.Scheduler _scheduler;
  final fsrs.Scheduler _preview;

  /// Applies an answer to a word labelled [wordDifficulty] and returns the
  /// card's new schedule.
  Schedule review(Schedule schedule, fsrs.Rating rating, DateTime now, {String? wordDifficulty}) {
    final card = _review(_scheduler, schedule, rating, now, wordDifficulty);
    final lapsed = rating == fsrs.Rating.again && schedule.state == fsrs.State.review;
    return Schedule(
      state: card.state,
      step: card.step,
      stability: card.stability,
      difficulty: card.difficulty,
      due: card.due,
      lastReview: card.lastReview,
      reps: schedule.reps + 1,
      lapses: schedule.lapses + (lapsed ? 1 : 0),
    );
  }

  /// How long until the card comes back if answered with [rating].
  Duration preview(Schedule schedule, fsrs.Rating rating, DateTime now, {String? wordDifficulty}) =>
      _review(_preview, schedule, rating, now, wordDifficulty).due.difference(now.toUtc());

  static fsrs.Card _review(
    fsrs.Scheduler scheduler,
    Schedule schedule,
    fsrs.Rating rating,
    DateTime now,
    String? wordDifficulty,
  ) {
    final card = schedule._toCard();
    final labelled = _labelDifficulty[wordDifficulty];
    if (labelled != null && rating != fsrs.Rating.again && card.difficulty != null) {
      card.difficulty = labelled;
    }
    return scheduler.reviewCard(card, rating, reviewDateTime: now.toUtc()).card;
  }
}
