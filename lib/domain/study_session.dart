import 'dart:collection';
import 'dart:math';

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

/// Cards due within this window are shown again in the same session.
const learnAhead = Duration(minutes: 20);

/// Picks the cards for one session: every due review, plus up to
/// [newLimit] cards from [level] that have never been studied.
///
/// New cards are spread evenly between reviews. Their order is shuffled with a
/// fixed seed per pair, so it is random but the same every day.
List<StudyItem> buildSessionItems({
  required List<PairCard> cards,
  required Map<String, Schedule> schedules,
  required String level,
  required int newLimit,
  required DateTime now,
  required int seed,
}) {
  final due = <StudyItem>[];
  final fresh = <PairCard>[];
  for (final card in cards) {
    final schedule = schedules[card.id];
    if (schedule == null) {
      if (card.level == level) fresh.add(card);
    } else if (!schedule.due.isAfter(now.toUtc().add(learnAhead))) {
      due.add(StudyItem(card: card, schedule: schedule, isNew: false));
    }
  }
  due.sort((a, b) => a.schedule.due.compareTo(b.schedule.due));
  fresh.shuffle(Random(seed));
  final newItems = fresh
      .take(max(0, newLimit))
      .map((c) => StudyItem(card: c, schedule: Schedule.fresh(now), isNew: true))
      .toList();

  if (newItems.isEmpty) return due;
  if (due.isEmpty) return newItems;
  final result = <StudyItem>[];
  final gap = (due.length + newItems.length) / newItems.length;
  var dueIndex = 0;
  for (var i = 0; i < newItems.length; i++) {
    final until = ((i + 1) * gap).floor() - 1;
    while (result.length < until && dueIndex < due.length) {
      result.add(due[dueIndex++]);
    }
    result.add(newItems[i]);
  }
  result.addAll(due.skip(dueIndex));
  return result;
}

/// A stable seed for shuffling new cards of a pair.
int pairSeed(LanguagePair pair) =>
    pair.target.codeUnits.fold(17, (h, c) => h * 31 + c) * 7 +
    pair.native.codeUnits.fold(19, (h, c) => h * 37 + c);

/// The queue of one study session.
class StudySession {
  StudySession(Iterable<StudyItem> items) : _queue = Queue.of(items) {
    total = _queue.length;
  }

  final Queue<StudyItem> _queue;
  late final int total;
  int answered = 0;

  StudyItem? get current => _queue.isEmpty ? null : _queue.first;
  int get remaining => _queue.length;
  bool get isFinished => _queue.isEmpty;

  /// Answers the current card. Cards that come due again within
  /// [learnAhead] go to the back of the queue.
  ({StudyItem item, bool wasNew, Schedule schedule}) answer(
      Srs srs, Rating rating, DateTime now) {
    final item = _queue.removeFirst();
    final wasNew = item.isNew;
    item.schedule = srs.review(item.schedule, rating, now);
    item.isNew = false;
    answered++;
    if (!item.schedule.due.isAfter(now.toUtc().add(learnAhead))) {
      _queue.addLast(item);
    }
    return (item: item, wasNew: wasNew, schedule: item.schedule);
  }
}
