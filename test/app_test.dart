import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flashcard/app.dart';
import 'package:flashcard/data/progress_database.dart';
import 'package:flashcard/data/progress_repository.dart';
import 'package:flashcard/data/speech.dart';
import 'package:flashcard/data/vocabulary_repository.dart';
import 'package:flashcard/domain/pair.dart';
import 'package:flashcard/domain/srs.dart';
import 'package:flashcard/state/providers.dart';
import 'package:flashcard/ui/difficulty_menu.dart';
import 'package:flashcard/ui/term_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Needs assets/vocabulary.db: run `dart run tool/build_vocabulary_db.dart` first.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final vocabulary = Vocabulary.fromFile('assets/vocabulary.db');
  final now = DateTime.utc(2026, 10, 13, 9);

  test('vocabulary.db holds every card in every language', () {
    expect(vocabulary.cards.length, greaterThan(9000));
    expect(vocabulary.languages.map((l) => l.code), ['en', 'de', 'nl', 'fa']);
    final card = vocabulary.cards.firstWhere((c) => c.terms['de']!.word == 'die Frau');
    expect(card.terms['de']!.plural, 'Frauen');
    expect(card.terms['nl']!.word, startsWith('de '));
    expect(vocabulary.cards.map((c) => c.difficulty).toSet(), {'easy', 'medium', 'advanced'});
  });

  group('ProgressRepository', () {
    late ProgressRepository repo;
    setUp(() => repo = ProgressRepository(ProgressDatabase(NativeDatabase.memory())));

    test('keeps progress per language pair', () async {
      const deFa = LanguagePair(target: 'de', native: 'fa');
      const nlEn = LanguagePair(target: 'nl', native: 'en');
      final schedule = Srs(fuzz: false).review(Schedule.fresh(now), Rating.good, now);
      await repo.saveReview(
        pair: deFa,
        cardId: 'a1-0001',
        schedule: schedule,
        rating: Rating.good,
        wasNew: true,
        at: now,
      );

      expect((await repo.schedules(deFa)).keys, ['a1-0001']);
      expect(await repo.schedules(nlEn), isEmpty);
      final today = await repo.today(deFa, now);
      expect(today.reviews, 1);
      expect(today.newCards, 1);
      expect(await repo.reviewDays(), hasLength(1));
    });

    test('upgrades a version 1 progress database', () async {
      final dir = Directory.systemTemp.createTempSync('progress');
      final file = File('${dir.path}/progress.sqlite');
      final first = ProgressDatabase(NativeDatabase(file));
      await first.customStatement('DROP TABLE difficulty_overrides');
      await first.customStatement('PRAGMA user_version = 1');
      await first.close();

      final upgraded = ProgressRepository(ProgressDatabase(NativeDatabase(file)));
      await upgraded.setDifficulty('a1-0001', 'de', 'easy');
      expect(await upgraded.difficultyOverrides('de'), {'a1-0001': 'easy'});
      dir.deleteSync(recursive: true);
    });

    test('stores settings', () async {
      await repo.writeSetting('uiLanguage', 'fa');
      await repo.writeSetting('uiLanguage', 'de');
      expect(await repo.readSettings(), {'uiLanguage': 'de'});
    });
  });

  testWidgets('choose a pair, study a card, and switch the menus to Persian', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1100, 800));
    final repo = ProgressRepository(ProgressDatabase(NativeDatabase.memory()));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vocabularyProvider.overrideWithValue(vocabulary),
          progressRepositoryProvider.overrideWithValue(repo),
          initialSettingsProvider.overrideWithValue(const {}),
          speechProvider.overrideWithValue(Speech.silent()),
          srsProvider.overrideWithValue(Srs(fuzz: false)),
        ],
        child: const FlashcardApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Menus start in English.
    expect(find.text('Welcome'), findsOneWidget);
    await tester.tap(find.byKey(const Key('target')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('German').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('native')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Persian').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.text('German from Persian'), findsOneWidget);
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start studying'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();

    expect(find.text('New words today: 0'), findsOneWidget);
    expect(find.text('Again'), findsNothing);
    final firstWord = tester.widget<TermText>(find.byType(TermText).first).text;

    // Mark the word as advanced; the choice is saved for German.
    await tester.tap(find.byType(DifficultyMenu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Advanced').last);
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();
    expect((await repo.difficultyOverrides('de')).values, ['advanced']);

    await tester.tap(find.text('Show answer'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Remembered'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();
    expect(find.text('New words today: 1'), findsOneWidget);
    expect(
      tester.widget<TermText>(find.byType(TermText).first).text,
      isNot(firstWord),
      reason: 'the next new word is shown while the first one waits for its next step',
    );
    expect(await repo.schedules(const LanguagePair(target: 'de', native: 'fa')), hasLength(1));

    // Switch the menu language in Settings.
    await tester.tap(find.text('End session'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Persian').last);
    await tester.pumpAndSettle();
    expect(find.text('تنظیمات'), findsWidgets);
    expect(Directionality.of(tester.element(find.text('تنظیمات').first)), TextDirection.rtl);
  });
}
