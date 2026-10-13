import 'dart:collection';
import 'dart:math';

import '../core/language.dart';
import 'pair.dart';
import 'srs.dart';

/// A card waiting in a study session, with its current schedule.
class StudyItem {
  StudyItem({required this.card, required this.schedule, required this.isNew});

  final PairCard card;
  Schedule schedule;

  /// True until the card has been answered for the first time.
  bool isNew;
}

/// When nothing else is left, a card due within this window is shown early.
const learnAhead = Duration(minutes: 20);

/// Studied cards that come due within this time join the session when they
/// come due, so a long session brings back words as their time arrives.
const sessionHorizon = Duration(hours: 12);

/// The cards of a pair for one study session, with no daily limit.
///
/// [reviews] are cards already studied that are due now or within
/// [sessionHorizon], sorted by due time. [fresh] are all cards never studied,
/// from [level], or, when [level] is null, from every level in order: all of
/// A1 first, then A2, and so on. Within a level their order is shuffled with a
/// fixed seed per pair, so it is random but the same every day.
({List<StudyItem> reviews, List<StudyItem> fresh}) sessionCards({
  required List<PairCard> cards,
  required Map<String, Schedule> schedules,
  required String? level,
  required DateTime now,
  required int seed,
}) {
  final reviews = <StudyItem>[];
  final freshByLevel = {for (final l in levels) l: <PairCard>[]};
  final horizon = now.toUtc().add(sessionHorizon);
  for (final card in cards) {
    final schedule = schedules[card.id];
    if (schedule == null) {
      if (level == null || card.level == level) freshByLevel[card.level]?.add(card);
    } else if (!schedule.due.isAfter(horizon)) {
      reviews.add(StudyItem(card: card, schedule: schedule, isNew: false));
    }
  }
  reviews.sort((a, b) => a.schedule.due.compareTo(b.schedule.due));
  final random = Random(seed);
  return (
    reviews: reviews,
    fresh: [
      for (final l in levels)
        for (final card in freshByLevel[l]!..shuffle(random))
          StudyItem(card: card, schedule: Schedule.fresh(now), isNew: true),
    ],
  );
}

/// A stable seed for shuffling new cards of a pair.
int pairSeed(LanguagePair pair) =>
    pair.target.codeUnits.fold(17, (h, c) => h * 31 + c) * 7 +
    pair.native.codeUnits.fold(19, (h, c) => h * 37 + c);

/// One study session. It goes on as long as the learner wants: due reviews
/// come first, then new cards one after another. A card answered in the
/// session comes back when it is due again.
class StudySession {
  StudySession({
    required List<StudyItem> reviews,
    required Iterable<StudyItem> fresh,
    required this.clock,
  }) : _reviews = [...reviews],
       _fresh = Queue.of(fresh);

  /// Studied cards, sorted by due time.
  final List<StudyItem> _reviews;
  final Queue<StudyItem> _fresh;
  final DateTime Function() clock;
  StudyItem? _current;

  /// Cards answered in this session.
  int answered = 0;

  /// New cards answered for the first time in this session.
  int newAnswered = 0;

  /// The card to show, or null when nothing is due and no new card is left.
  /// It stays the same until it is answered.
  StudyItem? get current => _current ??= _pick();

  bool get isFinished => current == null;

  /// Studied cards due now.
  int get dueCount {
    final now = clock().toUtc();
    return _reviews.where((i) => !i.schedule.due.isAfter(now)).length;
  }

  /// New cards not yet shown.
  int get freshCount => _fresh.length;

  StudyItem? _pick() {
    final now = clock().toUtc();
    final next = _reviews.isEmpty ? null : _reviews.first;
    if (next != null && !next.schedule.due.isAfter(now)) return next;
    if (_fresh.isNotEmpty) return _fresh.first;
    if (next != null && !next.schedule.due.isAfter(now.add(learnAhead))) return next;
    return null;
  }

  /// Answers the current card, a word labelled [wordDifficulty].
  ({StudyItem item, bool wasNew, Schedule schedule}) answer(
    Srs srs,
    Rating rating,
    DateTime now, {
    String? wordDifficulty,
  }) {
    final item = current!;
    _current = null;
    if (item.isNew) {
      _fresh.remove(item);
    } else {
      _reviews.remove(item);
    }
    final wasNew = item.isNew;
    item.schedule = srs.review(item.schedule, rating, now, wordDifficulty: wordDifficulty);
    item.isNew = false;
    answered++;
    if (wasNew) newAnswered++;
    if (!item.schedule.due.isAfter(now.toUtc().add(sessionHorizon))) {
      final index = _reviews.indexWhere((i) => i.schedule.due.isAfter(item.schedule.due));
      _reviews.insert(index < 0 ? _reviews.length : index, item);
    }
    return (item: item, wasNew: wasNew, schedule: item.schedule);
  }
}
