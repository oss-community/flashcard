import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fa'),
    Locale('nl'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get appTitle;

  /// No description provided for @navStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get navStudy;

  /// No description provided for @navWords.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get navWords;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get navStats;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you want to learn, the language you already know, and your level. You can change all of this later in Settings.'**
  String get welcomeBody;

  /// No description provided for @languageToLearn.
  ///
  /// In en, this message translates to:
  /// **'Language to learn'**
  String get languageToLearn;

  /// No description provided for @languageYouKnow.
  ///
  /// In en, this message translates to:
  /// **'Language you know'**
  String get languageYouKnow;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @sameLanguageError.
  ///
  /// In en, this message translates to:
  /// **'Choose two different languages.'**
  String get sameLanguageError;

  /// No description provided for @levelAllInOrder.
  ///
  /// In en, this message translates to:
  /// **'All, in order'**
  String get levelAllInOrder;

  /// No description provided for @levelAllHint.
  ///
  /// In en, this message translates to:
  /// **'New cards come from A1 first, then A2, and so on up to C2.'**
  String get levelAllHint;

  /// No description provided for @dueNow.
  ///
  /// In en, this message translates to:
  /// **'Due for review'**
  String get dueNow;

  /// No description provided for @newLeft.
  ///
  /// In en, this message translates to:
  /// **'New words left'**
  String get newLeft;

  /// No description provided for @newTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'New words today'**
  String get newTodayLabel;

  /// No description provided for @reviewedToday.
  ///
  /// In en, this message translates to:
  /// **'Answered today'**
  String get reviewedToday;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get streak;

  /// No description provided for @studyNow.
  ///
  /// In en, this message translates to:
  /// **'Start studying'**
  String get studyNow;

  /// No description provided for @allDone.
  ///
  /// In en, this message translates to:
  /// **'Nothing to study right now: no review is due and every word has been studied. Reviews come back when they are due.'**
  String get allDone;

  /// No description provided for @learningPair.
  ///
  /// In en, this message translates to:
  /// **'{target} from {native}'**
  String learningPair(String target, String native);

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelLabel(String level);

  /// No description provided for @showAnswer.
  ///
  /// In en, this message translates to:
  /// **'Show answer'**
  String get showAnswer;

  /// No description provided for @forgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot'**
  String get forgot;

  /// No description provided for @remembered.
  ///
  /// In en, this message translates to:
  /// **'Remembered'**
  String get remembered;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @diffEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get diffEasy;

  /// No description provided for @diffMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get diffMedium;

  /// No description provided for @diffAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get diffAdvanced;

  /// No description provided for @changeDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Change difficulty'**
  String get changeDifficulty;

  /// No description provided for @dueInSession.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No reviews due} =1{1 review due} other{{count} reviews due}}'**
  String dueInSession(int count);

  /// No description provided for @goalProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s goal: {done} of {goal} new words'**
  String goalProgress(int done, int goal);

  /// No description provided for @newTodayCount.
  ///
  /// In en, this message translates to:
  /// **'New words today: {count}'**
  String newTodayCount(int count);

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Daily goal reached. Keep going as long as you like.'**
  String get goalReached;

  /// No description provided for @endSession.
  ///
  /// In en, this message translates to:
  /// **'End session'**
  String get endSession;

  /// No description provided for @sessionFinished.
  ///
  /// In en, this message translates to:
  /// **'Session finished'**
  String get sessionFinished;

  /// No description provided for @sessionSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You answered 1 card.} other{You answered {count} cards.}}'**
  String sessionSummary(int count);

  /// No description provided for @backHome.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backHome;

  /// No description provided for @keyboardHint.
  ///
  /// In en, this message translates to:
  /// **'Space: show answer   1: forgot   2: remembered'**
  String get keyboardHint;

  /// No description provided for @pluralLabel.
  ///
  /// In en, this message translates to:
  /// **'Plural:'**
  String get pluralLabel;

  /// No description provided for @noPlural.
  ///
  /// In en, this message translates to:
  /// **'No plural'**
  String get noPlural;

  /// No description provided for @pronounce.
  ///
  /// In en, this message translates to:
  /// **'Pronounce'**
  String get pronounce;

  /// No description provided for @noVoice.
  ///
  /// In en, this message translates to:
  /// **'No voice for this language is installed on this device'**
  String get noVoice;

  /// No description provided for @newCardBadge.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newCardBadge;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String minutes(int n);

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'{n} h'**
  String hours(int n);

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'{n} d'**
  String days(int n);

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'{n} mo'**
  String months(int n);

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'{n} y'**
  String years(int n);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search in both languages'**
  String get searchHint;

  /// No description provided for @allLevels.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allLevels;

  /// No description provided for @wordCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 word} other{{count} words}}'**
  String wordCount(int count);

  /// No description provided for @statusNew.
  ///
  /// In en, this message translates to:
  /// **'Not studied'**
  String get statusNew;

  /// No description provided for @statusLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get statusLearning;

  /// No description provided for @statusLearned.
  ///
  /// In en, this message translates to:
  /// **'Next review {date}'**
  String statusLearned(String date);

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No words found.'**
  String get noResults;

  /// No description provided for @statsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statsToday;

  /// No description provided for @statsLast30.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get statsLast30;

  /// No description provided for @statsByLevel.
  ///
  /// In en, this message translates to:
  /// **'Learned per level'**
  String get statsByLevel;

  /// No description provided for @learnedOf.
  ///
  /// In en, this message translates to:
  /// **'{learned} of {total}'**
  String learnedOf(int learned, int total);

  /// No description provided for @statsAllPairs.
  ///
  /// In en, this message translates to:
  /// **'All language pairs'**
  String get statsAllPairs;

  /// No description provided for @statsThisPair.
  ///
  /// In en, this message translates to:
  /// **'Current language pair'**
  String get statsThisPair;

  /// No description provided for @settingsMenuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Menu language'**
  String get settingsMenuLanguage;

  /// No description provided for @settingsLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get settingsLanguages;

  /// No description provided for @settingsStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get settingsStudy;

  /// No description provided for @settingsDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal (new words)'**
  String get settingsDailyGoal;

  /// No description provided for @settingsDailyGoalHint.
  ///
  /// In en, this message translates to:
  /// **'Only for keeping track. You can always study more.'**
  String get settingsDailyGoalHint;

  /// No description provided for @noGoal.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noGoal;

  /// No description provided for @settingsReversed.
  ///
  /// In en, this message translates to:
  /// **'Reverse cards'**
  String get settingsReversed;

  /// No description provided for @settingsReversedHint.
  ///
  /// In en, this message translates to:
  /// **'Show the meaning first and recall the word. Progress is kept separately.'**
  String get settingsReversedHint;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Same as system'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'Progress is kept separately for every language pair.'**
  String get settingsAbout;

  /// No description provided for @typeNoun.
  ///
  /// In en, this message translates to:
  /// **'noun'**
  String get typeNoun;

  /// No description provided for @typeVerb.
  ///
  /// In en, this message translates to:
  /// **'verb'**
  String get typeVerb;

  /// No description provided for @typeAdj.
  ///
  /// In en, this message translates to:
  /// **'adjective'**
  String get typeAdj;

  /// No description provided for @typeAdv.
  ///
  /// In en, this message translates to:
  /// **'adverb'**
  String get typeAdv;

  /// No description provided for @typePrep.
  ///
  /// In en, this message translates to:
  /// **'preposition'**
  String get typePrep;

  /// No description provided for @typePron.
  ///
  /// In en, this message translates to:
  /// **'pronoun'**
  String get typePron;

  /// No description provided for @typeConj.
  ///
  /// In en, this message translates to:
  /// **'conjunction'**
  String get typeConj;

  /// No description provided for @typeDet.
  ///
  /// In en, this message translates to:
  /// **'determiner'**
  String get typeDet;

  /// No description provided for @typeParticle.
  ///
  /// In en, this message translates to:
  /// **'particle'**
  String get typeParticle;

  /// No description provided for @typeInterj.
  ///
  /// In en, this message translates to:
  /// **'interjection'**
  String get typeInterj;

  /// No description provided for @typeNum.
  ///
  /// In en, this message translates to:
  /// **'number'**
  String get typeNum;

  /// No description provided for @typePhrasalVerb.
  ///
  /// In en, this message translates to:
  /// **'phrasal verb'**
  String get typePhrasalVerb;

  /// No description provided for @typePhrase.
  ///
  /// In en, this message translates to:
  /// **'phrase'**
  String get typePhrase;

  /// No description provided for @typeIdiom.
  ///
  /// In en, this message translates to:
  /// **'idiom'**
  String get typeIdiom;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'fa', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
