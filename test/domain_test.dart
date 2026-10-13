import 'package:flashcard/core/vocabulary_source.dart';
import 'package:flashcard/domain/pair.dart';
import 'package:flashcard/domain/srs.dart';
import 'package:flashcard/domain/stats.dart';
import 'package:flashcard/domain/study_session.dart';
import 'package:flutter_test/flutter_test.dart';

VocabCard card(String id, String level, String en, String de, String fa) => VocabCard(
  id: id,
  level: level,
  difficulty: 'medium',
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

  group('sessionCards', () {
    final cards = cardsForPair([
      for (var i = 0; i < 10; i++) card('a$i', 'A1', 'en$i', 'de$i', 'fa$i'),
      for (var i = 0; i < 5; i++) card('b$i', 'A2', 'x$i', 'y$i', 'z$i'),
    ], pair);

    test('takes every new card of the chosen level, with no daily limit', () {
      final result = sessionCards(cards: cards, schedules: {}, level: 'A2', now: now, seed: 1);
      expect(result.fresh.length, 5);
      expect(result.fresh.every((i) => i.isNew && i.card.level == 'A2'), isTrue);
    });

    test('with no level, takes every new card, A1 first, then A2', () {
      final fresh = sessionCards(cards: cards, schedules: {}, level: null, now: now, seed: 1).fresh;
      expect(fresh.length, 15);
      expect(fresh.take(10).every((i) => i.card.level == 'A1'), isTrue);
      expect(fresh.skip(10).every((i) => i.card.level == 'A2'), isTrue);
    });

    test('reviews are cards due within the session horizon, oldest first', () {
      final schedules = {
        for (var i = 0; i < 4; i++)
          'b$i': Schedule(
            state: State.review,
            due: now.subtract(Duration(days: i)),
          ),
        'a0': Schedule(state: State.review, due: now.add(const Duration(hours: 2))),
        'b4': Schedule(state: State.review, due: now.add(const Duration(days: 3))),
      };
      final result = sessionCards(
        cards: cards,
        schedules: schedules,
        level: 'A1',
        now: now,
        seed: 1,
      );
      expect(result.reviews.map((i) => i.card.id), ['b3', 'b2', 'b1', 'b0', 'a0']);
      expect(result.fresh.length, 9);
    });

    test('new card order is shuffled but stable', () {
      List<String> ids() => sessionCards(
        cards: cards,
        schedules: {},
        level: 'A1',
        now: now,
        seed: 42,
      ).fresh.map((i) => i.card.id).toList();
      expect(ids(), ids());
      expect(ids(), isNot([for (var i = 0; i < 10; i++) 'a$i']));
    });
  });

  group('StudySession', () {
    final srs = Srs(fuzz: false);
    final cards = cardsForPair([
      card('1', 'A1', 'a', 'b', 'c'),
      card('2', 'A1', 'd', 'e', 'f'),
      card('3', 'A1', 'g', 'h', 'i'),
    ], pair);

    StudySession session(Map<String, Schedule> schedules, DateTime Function() clock) {
      final result = sessionCards(
        cards: cards,
        schedules: schedules,
        level: 'A1',
        now: clock(),
        seed: 1,
      );
      return StudySession(reviews: result.reviews, fresh: result.fresh, clock: clock);
    }

    test('due reviews come before new cards', () {
      final s = session({
        '2': Schedule(
          state: State.review,
          stability: 5,
          difficulty: 5,
          due: now.subtract(const Duration(days: 1)),
          lastReview: now.subtract(const Duration(days: 6)),
        ),
      }, () => now);
      expect(s.current!.card.id, '2');
      expect(s.dueCount, 1);
      s.answer(srs, Rating.good, now);
      expect(s.current!.isNew, isTrue);
      expect(s.freshCount, 2);
    });

    test('a forgotten card comes back when it is due again', () {
      var time = now;
      final s = session({}, () => time);
      final first = s.current!.card.id;
      final result = s.answer(srs, Rating.again, time);
      expect(result.wasNew, isTrue);
      expect(s.current!.card.id, isNot(first));
      expect(s.current!.isNew, isTrue);
      time = time.add(const Duration(minutes: 2));
      s.answer(srs, Rating.good, time);
      expect(s.current!.card.id, first);
      expect(s.current!.isNew, isFalse);
      expect(s.newAnswered, 2);
    });

    test('the shown card stays the same until it is answered', () {
      var time = now;
      final s = session({
        '3': Schedule(state: State.review, due: now.add(const Duration(minutes: 5))),
      }, () => time);
      final shown = s.current!;
      expect(shown.isNew, isTrue);
      time = time.add(const Duration(minutes: 10));
      expect(s.current, same(shown));
      s.answer(srs, Rating.good, time);
      expect(s.current!.card.id, '3');
    });

    test('the session ends only when nothing is due and no new card is left', () {
      final s = session({}, () => now);
      for (var i = 0; i < 3; i++) {
        s.answer(srs, rememberedRating('easy', s.current!.schedule), now, wordDifficulty: 'easy');
      }
      expect(s.isFinished, isTrue);
      expect(s.answered, 3);
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
        state: State.review,
        stability: 10,
        difficulty: 5,
        due: now,
        lastReview: now.subtract(const Duration(days: 10)),
        reps: 3,
      );
      final after = srs.review(learned, Rating.again, now);
      expect(after.lapses, 1);
      expect(after.reps, 4);
      expect(after.state, State.relearning);
    });
  });

  group('difficulty', () {
    final srs = Srs(fuzz: false);

    /// Days between reviews when a word is remembered every time it comes back.
    List<int> rememberedGaps(String difficulty) {
      var time = now;
      var schedule = Schedule.fresh(time);
      final days = <int>[];
      while (days.length < 4) {
        schedule = srs.review(
          schedule,
          rememberedRating(difficulty, schedule),
          time,
          wordDifficulty: difficulty,
        );
        final gap = schedule.due.difference(time);
        if (gap.inDays >= 1) days.add(gap.inDays);
        time = schedule.due;
      }
      return days;
    }

    test('a new easy word first comes back after a week', () {
      final fresh = Schedule.fresh(now);
      final easy = srs.preview(fresh, rememberedRating('easy', fresh), now, wordDifficulty: 'easy');
      expect(easy.inDays, 7);
    });

    test('each remembered answer brings the word back later than the last', () {
      for (final difficulty in difficulties) {
        final days = rememberedGaps(difficulty);
        for (var i = 1; i < days.length; i++) {
          expect(days[i], greaterThan(days[i - 1]), reason: '$difficulty: $days');
        }
      }
    });

    test('easy words space out faster than medium, medium faster than advanced', () {
      final easy = rememberedGaps('easy');
      final medium = rememberedGaps('medium');
      final advanced = rememberedGaps('advanced');
      for (var i = 0; i < 4; i++) {
        expect(easy[i], greaterThan(medium[i]), reason: 'easy $easy, medium $medium');
        expect(
          medium[i],
          greaterThanOrEqualTo(advanced[i]),
          reason: 'medium $medium, advanced $advanced',
        );
      }
      expect(medium[3], greaterThan(advanced[3]));
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
