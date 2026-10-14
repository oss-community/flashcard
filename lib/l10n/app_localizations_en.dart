// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Wordeck';

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
      'Choose the language you want to learn, the language you already know, and your level. You can add more profiles later in Settings, each with its own progress.';

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
  String get noVoice =>
      'No voice for this language is installed on this device';

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
  String get settingsMenuLanguage => 'Menu language';

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
  String get themeSystem => 'Same as system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsAbout =>
      'Each profile keeps its own progress. To study another pair of languages, add a new profile.';

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

  @override
  String get profiles => 'Profiles';

  @override
  String get profileName => 'Profile name';

  @override
  String get profileNameHint =>
      'Optional. Leave it empty to name the profile after its languages.';

  @override
  String profileDefaultName(String native, String target) {
    return '$native → $target';
  }

  @override
  String get newProfile => 'New profile';

  @override
  String get createProfile => 'Create profile';

  @override
  String get switchProfile => 'Switch profile';

  @override
  String get renameProfile => 'Rename';

  @override
  String deleteProfileTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String get deleteProfileBody =>
      'All progress of this profile will be removed. This cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String settingsStudyIn(String profile) {
    return 'Study: $profile';
  }

  @override
  String get settingsShowForms => 'Show word forms';

  @override
  String get settingsShowFormsHint =>
      'Plurals, verb forms and comparisons on the back of the card.';

  @override
  String get conjugation => 'Conjugation';

  @override
  String get formInfinitive => 'Infinitive';

  @override
  String get formPast => 'Past';

  @override
  String get formPerfect => 'Perfect';

  @override
  String get formPastParticiple => 'Past participle';

  @override
  String get formPastStem => 'Past stem';

  @override
  String get formPresentStem => 'Present stem';

  @override
  String get formComparative => 'Comparative';

  @override
  String get formSuperlative => 'Superlative';

  @override
  String get tensePresent => 'Present';

  @override
  String get tensePresentProgressive => 'Present progressive';

  @override
  String get tenseSimplePast => 'Past';

  @override
  String get tensePastImperfect => 'Past habitual';

  @override
  String get tensePastProgressive => 'Past progressive';

  @override
  String get tensePresentPerfect => 'Present perfect';

  @override
  String get tensePastPerfect => 'Past perfect';

  @override
  String get tenseFuture => 'Future';

  @override
  String get about => 'About';

  @override
  String get aboutBody =>
      'Learn vocabulary with flashcards and spaced repetition. Free and open source. Works offline, and your progress stays on this device.';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutFeedback => 'Report a problem or suggest an idea';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get aboutSource => 'Source code';

  @override
  String get aboutLicenses => 'Licenses';

  @override
  String get reportMistake => 'Report a mistake';
}
