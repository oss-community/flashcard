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
/// [difficulty]: easy words come back later, advanced words sooner.
fsrs.Rating rememberedRating(String difficulty) => switch (difficulty) {
  'easy' => fsrs.Rating.easy,
  'advanced' => fsrs.Rating.hard,
  _ => fsrs.Rating.good,
};

/// Spaced repetition with the FSRS algorithm.
class Srs {
  Srs({bool fuzz = true})
    : _scheduler = fsrs.Scheduler(enableFuzzing: fuzz),
      _preview = fsrs.Scheduler(enableFuzzing: false);

  final fsrs.Scheduler _scheduler;
  final fsrs.Scheduler _preview;

  /// Applies an answer and returns the card's new schedule.
  Schedule review(Schedule schedule, fsrs.Rating rating, DateTime now) {
    final result = _scheduler.reviewCard(schedule._toCard(), rating, reviewDateTime: now.toUtc());
    final card = result.card;
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
  Duration preview(Schedule schedule, fsrs.Rating rating, DateTime now) {
    final card = _preview.reviewCard(schedule._toCard(), rating, reviewDateTime: now.toUtc()).card;
    return card.due.difference(now.toUtc());
  }
}
