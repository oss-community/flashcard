import 'package:flashcard/core/vocabulary_source.dart';
import 'package:flashcard/domain/pair.dart';
import 'package:flashcard/domain/srs.dart';
import 'package:flashcard/domain/stats.dart';
import 'package:flashcard/domain/study_session.dart';
import 'package:flutter_test/flutter_test.dart';

VocabCard card(String id, String level, String en, String de, String fa) => VocabCard(
      id: id,
      level: level,
      terms: {
        'en': Term(word: en, type: 'noun'),
        'de': Term(word: de, type: 'noun', plural: '-'),
        'fa': Term(word: fa, type: 'noun'),
      },
    );

void main() {
  final now = DateTime.utc(2026, 10, 13, 9);
  const pair = LanguagePair(target: 'de', native: 'fa');

  group('cardsForPair', () {
    test('keeps only the two languages and drops look-alike cards', () {
      final cards = cardsForPair([
        card('1', 'A1', 'student', 'der Student', 'دانشجو'),
        card('2', 'A1', 'student', 'die Studentin', 'دانشجو'),
        card('3', 'A1', 'pupil', 'der Student', 'دانشجو'),
      ], pair);
      expect(cards.map((c) => c.id), ['1', '2']);
      expect(cards.first.target.word, 'der Student');
      expect(cards.first.native.word, 'دانشجو');
    });

    test('search looks in both languages', () {
      final c = cardsForPair([card('1', 'A1', 'woman', 'die Frau', 'زن')], pair).single;
      expect(matchesQuery(c, 'frau'), isTrue);
      expect(matchesQuery(c, 'زن'), isTrue);
      expect(matchesQuery(c, 'mann'), isFalse);
    });
  });

  group('buildSessionItems', () {
    final cards = cardsForPair([
      for (var i = 0; i < 10; i++) card('a$i', 'A1', 'en$i', 'de$i', 'fa$i'),
      for (var i = 0; i < 5; i++) card('b$i', 'A2', 'x$i', 'y$i', 'z$i'),
    ], pair);

    test('takes new cards only from the chosen level, up to the limit', () {
      final items = buildSessionItems(
          cards: cards, schedules: {}, level: 'A2', newLimit: 3, now: now, seed: 1);
      expect(items.length, 3);
      expect(items.every((i) => i.isNew && i.card.level == 'A2'), isTrue);
    });

    test('includes due reviews from any level and spreads new cards between them', () {
      final schedules = {
        for (var i = 0; i < 4; i++)
          'b$i': Schedule(state: State.review, due: now.subtract(Duration(days: i))),
        'b4': Schedule(state: State.review, due: now.add(const Duration(days: 3))),
      };
      final items = buildSessionItems(
          cards: cards, schedules: schedules, level: 'A1', newLimit: 2, now: now, seed: 1);
      expect(items.length, 6);
      expect(items.where((i) => i.isNew).length, 2);
      expect(items.where((i) => !i.isNew).map((i) => i.card.id), ['b3', 'b2', 'b1', 'b0']);
      expect(items.first.isNew, isFalse);
    });

    test('new card order is shuffled but stable', () {
      List<String> ids() => buildSessionItems(
              cards: cards, schedules: {}, level: 'A1', newLimit: 10, now: now, seed: 42)
          .map((i) => i.card.id)
          .toList();
      expect(ids(), ids());
      expect(ids(), isNot([for (var i = 0; i < 10; i++) 'a$i']));
    });
  });

  group('StudySession', () {
    final srs = Srs(fuzz: false);
    final cards = cardsForPair([card('1', 'A1', 'a', 'b', 'c'), card('2', 'A1', 'd', 'e', 'f')], pair);

    test('a forgotten card comes back in the same session', () {
      final session = StudySession(buildSessionItems(
          cards: cards, schedules: {}, level: 'A1', newLimit: 2, now: now, seed: 1));
      final first = session.current!.card.id;
      final result = session.answer(srs, Rating.again, now);
      expect(result.wasNew, isTrue);
      expect(session.remaining, 2);
      expect(session.current!.card.id, isNot(first));
      session.answer(srs, Rating.easy, now);
      expect(session.current!.card.id, first);
      expect(session.current!.isNew, isFalse);
    });

    test('easy schedules further out than good, good further than again', () {
      final fresh = Schedule.fresh(now);
      final again = srs.preview(fresh, Rating.again, now);
      final good = srs.preview(fresh, Rating.good, now);
      final easy = srs.preview(fresh, Rating.easy, now);
      expect(again < good, isTrue);
      expect(good < easy, isTrue);
      expect(easy.inDays, greaterThanOrEqualTo(1));
    });

    test('a lapse is counted when a learned card is forgotten', () {
      final learned = Schedule(
          state: State.review, stability: 10, difficulty: 5, due: now, lastReview: now.subtract(const Duration(days: 10)), reps: 3);
      final after = srs.review(learned, Rating.again, now);
      expect(after.lapses, 1);
      expect(after.reps, 4);
      expect(after.state, State.relearning);
    });
  });

  group('stats', () {
    test('streak counts back from today or yesterday', () {
      final today = dayOf(DateTime(2026, 10, 13, 15));
      DateTime d(int back) => DateTime(today.year, today.month, today.day - back);
      expect(streakDays({d(0), d(1), d(2), d(4)}, DateTime(2026, 10, 13, 15)), 3);
      expect(streakDays({d(1), d(2)}, DateTime(2026, 10, 13, 15)), 2);
      expect(streakDays({d(2)}, DateTime(2026, 10, 13, 15)), 0);
    });

    test('daily counts fill missing days with zero', () {
      final counts = dailyCounts({DateTime(2026, 10, 12): 5}, DateTime(2026, 10, 13, 8), 3);
      expect(counts.map((e) => e.count), [0, 5, 0]);
      expect(counts.last.day, DateTime(2026, 10, 13));
    });
  });
}
