// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flashcards';

  @override
  String get navStudy => 'Study';

  @override
  String get navWords => 'Words';

  @override
  String get navStats => 'Statistics';

  @override
  String get navSettings => 'Settings';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get welcomeBody =>
      'Choose the language you want to learn, the language you already know, and your level. You can change all of this later in Settings.';

  @override
  String get languageToLearn => 'Language to learn';

  @override
  String get languageYouKnow => 'Language you know';

  @override
  String get level => 'Level';

  @override
  String get start => 'Start';

  @override
  String get sameLanguageError => 'Choose two different languages.';

  @override
  String get levelAllInOrder => 'All, in order';

  @override
  String get levelAllHint =>
      'New cards come from A1 first, then A2, and so on up to C2.';

  @override
  String get dueNow => 'Due for review';

  @override
  String get newLeft => 'New words left';

  @override
  String get newTodayLabel => 'New words today';

  @override
  String get reviewedToday => 'Answered today';

  @override
  String get streak => 'Day streak';

  @override
  String get studyNow => 'Start studying';

  @override
  String get allDone =>
      'Nothing to study right now: no review is due and every word has been studied. Reviews come back when they are due.';

  @override
  String learningPair(String target, String native) {
    return '$target from $native';
  }

  @override
  String levelLabel(String level) {
    return 'Level $level';
  }

  @override
  String get showAnswer => 'Show answer';

  @override
  String get forgot => 'Forgot';

  @override
  String get remembered => 'Remembered';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get diffEasy => 'Easy';

  @override
  String get diffMedium => 'Medium';

  @override
  String get diffAdvanced => 'Advanced';

  @override
  String get changeDifficulty => 'Change difficulty';

  @override
  String dueInSession(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews due',
      one: '1 review due',
      zero: 'No reviews due',
    );
    return '$_temp0';
  }

  @override
  String goalProgress(int done, int goal) {
    return 'Today\'s goal: $done of $goal new words';
  }

  @override
  String newTodayCount(int count) {
    return 'New words today: $count';
  }

  @override
  String get goalReached =>
      'Daily goal reached. Keep going as long as you like.';

  @override
  String get endSession => 'End session';

  @override
  String get sessionFinished => 'Session finished';

  @override
  String sessionSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You answered $count cards.',
      one: 'You answered 1 card.',
    );
    return '$_temp0';
  }

  @override
  String get backHome => 'Back';

  @override
  String get keyboardHint => 'Space: show answer   1: forgot   2: remembered';

  @override
  String get pluralLabel => 'Plural:';

  @override
  String get noPlural => 'No plural';

  @override
  String get pronounce => 'Pronounce';

  @override
  String get noVoice => 'No voice for this language is installed in Windows';

  @override
  String get newCardBadge => 'New';

  @override
  String minutes(int n) {
    return '$n min';
  }

  @override
  String hours(int n) {
    return '$n h';
  }

  @override
  String days(int n) {
    return '$n d';
  }

  @override
  String months(int n) {
    return '$n mo';
  }

  @override
  String years(int n) {
    return '$n y';
  }

  @override
  String get searchHint => 'Search in both languages';

  @override
  String get allLevels => 'All';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '1 word',
    );
    return '$_temp0';
  }

  @override
  String get statusNew => 'Not studied';

  @override
  String get statusLearning => 'Learning';

  @override
  String statusLearned(String date) {
    return 'Next review $date';
  }

  @override
  String get noResults => 'No words found.';

  @override
  String get statsToday => 'Today';

  @override
  String get statsLast30 => 'Last 30 days';

  @override
  String get statsByLevel => 'Learned per level';

  @override
  String learnedOf(int learned, int total) {
    return '$learned of $total';
  }

  @override
  String get statsAllPairs => 'All language pairs';

  @override
  String get statsThisPair => 'Current language pair';

  @override
  String get settingsMenuLanguage => 'Menu language';

  @override
  String get settingsLanguages => 'Languages';

  @override
  String get settingsStudy => 'Study';

  @override
  String get settingsDailyGoal => 'Daily goal (new words)';

  @override
  String get settingsDailyGoalHint =>
      'Only for keeping track. You can always study more.';

  @override
  String get noGoal => 'None';

  @override
  String get settingsReversed => 'Reverse cards';

  @override
  String get settingsReversedHint =>
      'Show the meaning first and recall the word. Progress is kept separately.';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get themeSystem => 'Same as Windows';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsAbout =>
      'Progress is kept separately for every language pair.';

  @override
  String get typeNoun => 'noun';

  @override
  String get typeVerb => 'verb';

  @override
  String get typeAdj => 'adjective';

  @override
  String get typeAdv => 'adverb';

  @override
  String get typePrep => 'preposition';

  @override
  String get typePron => 'pronoun';

  @override
  String get typeConj => 'conjunction';

  @override
  String get typeDet => 'determiner';

  @override
  String get typeParticle => 'particle';

  @override
  String get typeInterj => 'interjection';

  @override
  String get typeNum => 'number';

  @override
  String get typePhrasalVerb => 'phrasal verb';

  @override
  String get typePhrase => 'phrase';

  @override
  String get typeIdiom => 'idiom';
}
