import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/language.dart';
import '../data/progress_repository.dart';
import '../data/speech.dart';
import '../data/vocabulary_repository.dart';
import '../domain/pair.dart';
import '../domain/profile.dart';
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

/// Largest daily goal the settings offer.
const maxDailyGoal = 200;

/// Every profile, read before the app starts.
final initialProfilesProvider = Provider<List<Profile>>((ref) => throw UnimplementedError());

/// What the learner chose: menus and look for the whole app, and the
/// profile being studied with its languages, level and options.
@immutable
class AppSettings {
  const AppSettings({
    required this.uiLanguage,
    this.themeMode = ThemeMode.system,
    this.profiles = const [],
    this.activeId,
  });

  /// Menu language; English unless the learner changes it.
  final String uiLanguage;
  final ThemeMode themeMode;
  final List<Profile> profiles;
  final int? activeId;

  /// The profile being studied; null before the first one is made.
  Profile? get profile {
    for (final p in profiles) {
      if (p.id == activeId) return p;
    }
    return profiles.firstOrNull;
  }

  String? get native => profile?.native;
  String? get target => profile?.target;
  String? get level => profile?.level;
  int get dailyGoal => profile?.dailyGoal ?? 0;
  bool get reversed => profile?.reversed ?? false;
  bool get showForms => profile?.showForms ?? true;

  /// True once a profile exists.
  bool get hasPair => profile != null;

  LanguagePair get pair => profile!.pair;

  AppSettings copyWith({
    String? uiLanguage,
    ThemeMode? themeMode,
    List<Profile>? profiles,
    int? Function()? activeId,
  }) => AppSettings(
    uiLanguage: uiLanguage ?? this.uiLanguage,
    themeMode: themeMode ?? this.themeMode,
    profiles: profiles ?? this.profiles,
    activeId: activeId != null ? activeId() : this.activeId,
  );

  Map<String, String> toMap() => {
    'uiLanguage': uiLanguage,
    'themeMode': themeMode.name,
    if (profile case final p?) 'activeProfile': '${p.id}',
  };

  static AppSettings fromMap(
    Map<String, String> map,
    List<Language> languages,
    List<Profile> profiles,
  ) {
    final codes = languages.map((l) => l.code).toSet();
    return AppSettings(
      uiLanguage: codes.contains(map['uiLanguage']) ? map['uiLanguage']! : 'en',
      themeMode: ThemeMode.values.firstWhere(
        (m) => m.name == map['themeMode'],
        orElse: () => ThemeMode.system,
      ),
      profiles: [
        for (final p in profiles)
          if (codes.contains(p.native) && codes.contains(p.target) && p.native != p.target) p,
      ],
      activeId: int.tryParse(map['activeProfile'] ?? ''),
    );
  }
}

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => AppSettings.fromMap(
    ref.watch(initialSettingsProvider),
    ref.watch(vocabularyProvider).languages,
    ref.watch(initialProfilesProvider),
  );

  ProgressRepository get _repo => ref.read(progressRepositoryProvider);

  Future<void> _save() async {
    for (final entry in state.toMap().entries) {
      await _repo.writeSetting(entry.key, entry.value);
    }
  }

  /// Changes the settings shared by every profile.
  Future<void> update(AppSettings Function(AppSettings) change) async {
    state = change(state);
    await _save();
  }

  /// Changes the profile being studied.
  Future<void> updateProfile(Profile Function(Profile) change) async {
    final current = state.profile;
    if (current == null) return;
    await saveProfile(change(current));
  }

  Future<void> saveProfile(Profile profile) async {
    state = state.copyWith(
      profiles: [for (final p in state.profiles) p.id == profile.id ? profile : p],
    );
    await _repo.updateProfile(profile);
  }

  /// Adds a profile and starts studying it.
  Future<void> createProfile({
    String? name,
    required String native,
    required String target,
    String? level,
  }) async {
    final profile = await _repo.createProfile(
      name: name,
      native: native,
      target: target,
      level: level,
    );
    state = state.copyWith(profiles: [...state.profiles, profile], activeId: () => profile.id);
    await _save();
  }

  Future<void> switchProfile(int id) async {
    state = state.copyWith(activeId: () => id);
    await _save();
  }

  /// Removes a profile and its progress; the first one left is studied next.
  Future<void> deleteProfile(int id) async {
    await _repo.deleteProfile(id);
    final rest = [
      for (final p in state.profiles)
        if (p.id != id) p,
    ];
    state = state.copyWith(
      profiles: rest,
      activeId: () => state.activeId == id ? rest.firstOrNull?.id : state.activeId,
    );
    await _save();
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

/// Language currently used for the menus.
final uiLanguageProvider = Provider<Language>((ref) {
  final code = ref.watch(settingsProvider.select((s) => s.uiLanguage));
  return ref.watch(vocabularyProvider).language(code);
});

/// Cards of the current profile (two languages each).
final pairCardsProvider = Provider<List<PairCard>>((ref) {
  final pair = ref.watch(settingsProvider.select((s) => s.hasPair ? s.pair : null));
  if (pair == null) return const [];
  return cardsForPair(ref.watch(vocabularyProvider).cards, pair);
});

/// Difficulty labels the learner changed in the current profile.
final difficultyOverridesProvider = FutureProvider<Map<String, String>>((ref) async {
  ref.watch(progressVersionProvider);
  final id = ref.watch(settingsProvider.select((s) => s.profile?.id));
  if (id == null) return const {};
  return ref.watch(progressRepositoryProvider).difficultyOverrides(id);
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

/// Schedules of the current profile and direction, by card id.
final schedulesProvider = FutureProvider<Map<String, Schedule>>((ref) async {
  ref.watch(progressVersionProvider);
  final profile = ref.watch(
    settingsProvider.select(
      (s) => s.profile == null ? null : (id: s.profile!.id, reversed: s.reversed),
    ),
  );
  if (profile == null) return const {};
  final ids = {for (final card in ref.watch(pairCardsProvider)) card.id};
  final schedules = await ref
      .watch(progressRepositoryProvider)
      .schedules(profile.id, reversed: profile.reversed);
  // Progress of cards no longer in the vocabulary (removed duplicates) is ignored.
  return {
    for (final entry in schedules.entries)
      if (ids.contains(entry.key)) entry.key: entry.value,
  };
});

/// Today's numbers for the home and statistics screens.
class TodaySummary {
  const TodaySummary({
    required this.due,
    required this.newLeft,
    required this.reviewedToday,
    required this.newToday,
    required this.streak,
  });

  final int due;

  /// Cards never studied, in the chosen level or all levels.
  final int newLeft;
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
  final id = settings.profile?.id;
  if (id == null) {
    return const TodaySummary(due: 0, newLeft: 0, reviewedToday: 0, newToday: 0, streak: 0);
  }
  final today = await repo.today(id, now);
  final streak = streakDays(await repo.reviewDays(id), now);

  final dueLimit = now.toUtc();
  final due = schedules.values.where((s) => !s.due.isAfter(dueLimit)).length;
  final unseen = cards
      .where(
        (c) =>
            (settings.level == null || c.level == settings.level) && !schedules.containsKey(c.id),
      )
      .length;
  return TodaySummary(
    due: due,
    newLeft: unseen,
    reviewedToday: today.reviews,
    newToday: today.newCards,
    streak: streak,
  );
});

/// Review counts per day for the last 30 days in the current profile.
final historyProvider = FutureProvider<List<({DateTime day, int count})>>((ref) async {
  ref.watch(progressVersionProvider);
  final id = ref.watch(settingsProvider.select((s) => s.profile?.id));
  final now = ref.watch(clockProvider)();
  if (id == null) return const [];
  final counts = await ref.watch(progressRepositoryProvider).countsByDay(id, now, 30);
  return dailyCounts(counts, now, 30);
});
