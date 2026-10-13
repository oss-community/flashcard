import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/language.dart';
import '../data/progress_repository.dart';
import '../data/speech.dart';
import '../data/vocabulary_repository.dart';
import '../domain/pair.dart';
import '../domain/srs.dart';
import '../domain/stats.dart';

/// Loaded before the app starts and provided through overrides in `main`.
final vocabularyProvider = Provider<Vocabulary>((ref) => throw UnimplementedError());
final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => throw UnimplementedError(),
);
final speechProvider = Provider<Speech>((ref) => throw UnimplementedError());
final initialSettingsProvider = Provider<Map<String, String>>((ref) => throw UnimplementedError());

final srsProvider = Provider<Srs>((ref) => Srs());

/// Clock, replaceable in tests.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// What the learner chose: languages, level, menus and look.
@immutable
class AppSettings {
  const AppSettings({
    required this.uiLanguage,
    this.native,
    this.target,
    this.level,
    this.newPerDay = 20,
    this.reversed = false,
    this.themeMode = ThemeMode.system,
  });

  /// Menu language; English unless the learner changes it.
  final String uiLanguage;
  final String? native;
  final String? target;

  /// Level new cards come from; null means every level in order, A1 first.
  final String? level;
  final int newPerDay;
  final bool reversed;
  final ThemeMode themeMode;

  /// True once both languages of the pair have been chosen.
  bool get hasPair => native != null && target != null && native != target;

  LanguagePair get pair => LanguagePair(target: target!, native: native!, reversed: reversed);

  AppSettings copyWith({
    String? uiLanguage,
    String? native,
    String? target,
    String? Function()? level,
    int? newPerDay,
    bool? reversed,
    ThemeMode? themeMode,
  }) => AppSettings(
    uiLanguage: uiLanguage ?? this.uiLanguage,
    native: native ?? this.native,
    target: target ?? this.target,
    level: level != null ? level() : this.level,
    newPerDay: newPerDay ?? this.newPerDay,
    reversed: reversed ?? this.reversed,
    themeMode: themeMode ?? this.themeMode,
  );

  Map<String, String> toMap() => {
    'uiLanguage': uiLanguage,
    'native': ?native,
    'target': ?target,
    'level': level ?? 'all',
    'newPerDay': '$newPerDay',
    'reversed': '$reversed',
    'themeMode': themeMode.name,
  };

  static AppSettings fromMap(Map<String, String> map, List<Language> languages) {
    final codes = languages.map((l) => l.code).toSet();
    String? lang(String key) => codes.contains(map[key]) ? map[key] : null;
    return AppSettings(
      uiLanguage: lang('uiLanguage') ?? 'en',
      native: lang('native'),
      target: lang('target'),
      level: levels.contains(map['level']) ? map['level'] : null,
      newPerDay: int.tryParse(map['newPerDay'] ?? '')?.clamp(0, 200) ?? 20,
      reversed: map['reversed'] == 'true',
      themeMode: ThemeMode.values.firstWhere(
        (m) => m.name == map['themeMode'],
        orElse: () => ThemeMode.system,
      ),
    );
  }
}

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => AppSettings.fromMap(
    ref.watch(initialSettingsProvider),
    ref.watch(vocabularyProvider).languages,
  );

  Future<void> update(AppSettings Function(AppSettings) change) async {
    final next = change(state);
    state = next;
    final repo = ref.read(progressRepositoryProvider);
    for (final entry in next.toMap().entries) {
      await repo.writeSetting(entry.key, entry.value);
    }
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

/// Language currently used for the menus.
final uiLanguageProvider = Provider<Language>((ref) {
  final code = ref.watch(settingsProvider.select((s) => s.uiLanguage));
  return ref.watch(vocabularyProvider).language(code);
});

/// Cards of the current pair (two languages each).
final pairCardsProvider = Provider<List<PairCard>>((ref) {
  final settings = ref.watch(settingsProvider);
  if (!settings.hasPair) return const [];
  return cardsForPair(ref.watch(vocabularyProvider).cards, settings.pair);
});

/// Difficulty labels the learner changed for the language being learned.
final difficultyOverridesProvider = FutureProvider<Map<String, String>>((ref) async {
  ref.watch(progressVersionProvider);
  final target = ref.watch(settingsProvider.select((s) => s.target));
  if (target == null) return const {};
  return ref.watch(progressRepositoryProvider).difficultyOverrides(target);
});

/// Difficulty of [card] as the learner sees it: their own label, or the data's.
String effectiveDifficulty(PairCard card, Map<String, String> overrides) =>
    overrides[card.id] ?? card.difficulty;

/// Bumped after each answer so progress views reload.
final progressVersionProvider = NotifierProvider<ProgressVersion, int>(ProgressVersion.new);

class ProgressVersion extends Notifier<int> {
  @override
  int build() => 0;
  void bump() => state++;
}

/// Schedules of the current pair, by card id.
final schedulesProvider = FutureProvider<Map<String, Schedule>>((ref) async {
  ref.watch(progressVersionProvider);
  final settings = ref.watch(settingsProvider);
  if (!settings.hasPair) return const {};
  return ref.watch(progressRepositoryProvider).schedules(settings.pair);
});

/// Today's numbers for the home and statistics screens.
class TodaySummary {
  const TodaySummary({
    required this.due,
    required this.newAvailable,
    required this.reviewedToday,
    required this.newToday,
    required this.streak,
  });

  final int due;
  final int newAvailable;
  final int reviewedToday;
  final int newToday;
  final int streak;
}

final todayProvider = FutureProvider<TodaySummary>((ref) async {
  ref.watch(progressVersionProvider);
  final settings = ref.watch(settingsProvider);
  final repo = ref.watch(progressRepositoryProvider);
  final now = ref.watch(clockProvider)();
  final schedules = await ref.watch(schedulesProvider.future);
  final cards = ref.watch(pairCardsProvider);
  final today = await repo.today(settings.pair, now);
  final streak = streakDays(await repo.reviewDays(), now);

  final dueLimit = now.toUtc();
  final due = schedules.values.where((s) => !s.due.isAfter(dueLimit)).length;
  final unseen = cards
      .where(
        (c) =>
            (settings.level == null || c.level == settings.level) && !schedules.containsKey(c.id),
      )
      .length;
  final newLeft = (settings.newPerDay - today.newCards).clamp(0, unseen);
  return TodaySummary(
    due: due,
    newAvailable: newLeft,
    reviewedToday: today.reviews,
    newToday: today.newCards,
    streak: streak,
  );
});

/// Review counts per day for the last 30 days, all pairs.
final historyProvider = FutureProvider<List<({DateTime day, int count})>>((ref) async {
  ref.watch(progressVersionProvider);
  final now = ref.watch(clockProvider)();
  final counts = await ref.watch(progressRepositoryProvider).countsByDay(now, 30);
  return dailyCounts(counts, now, 30);
});
