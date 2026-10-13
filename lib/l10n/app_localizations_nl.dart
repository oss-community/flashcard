// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Flashcards';

  @override
  String get navStudy => 'Leren';

  @override
  String get navWords => 'Woorden';

  @override
  String get navStats => 'Statistieken';

  @override
  String get navSettings => 'Instellingen';

  @override
  String get welcomeTitle => 'Welkom';

  @override
  String get welcomeBody =>
      'Kies de taal die je wilt leren, de taal die je al kent en je niveau. Je kunt dit later in Instellingen wijzigen.';

  @override
  String get languageToLearn => 'Taal om te leren';

  @override
  String get languageYouKnow => 'Taal die je kent';

  @override
  String get level => 'Niveau';

  @override
  String get start => 'Beginnen';

  @override
  String get sameLanguageError => 'Kies twee verschillende talen.';

  @override
  String get dueNow => 'Te herhalen';

  @override
  String get newToday => 'Nieuwe kaarten over vandaag';

  @override
  String get reviewedToday => 'Vandaag beantwoord';

  @override
  String get streak => 'Dagen op rij';

  @override
  String get studyNow => 'Begin met leren';

  @override
  String get allDone =>
      'Alles is voor nu klaar. Kom later terug of verhoog het aantal nieuwe kaarten per dag in Instellingen.';

  @override
  String learningPair(String target, String native) {
    return '$target vanuit het $native';
  }

  @override
  String levelLabel(String level) {
    return 'Niveau $level';
  }

  @override
  String get showAnswer => 'Toon antwoord';

  @override
  String get again => 'Opnieuw';

  @override
  String get hard => 'Moeilijk';

  @override
  String get good => 'Goed';

  @override
  String get easy => 'Makkelijk';

  @override
  String cardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nog $count kaarten',
      one: 'Nog 1 kaart',
    );
    return '$_temp0';
  }

  @override
  String get endSession => 'Sessie beëindigen';

  @override
  String get sessionFinished => 'Sessie klaar';

  @override
  String sessionSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Je hebt $count kaarten beantwoord.',
      one: 'Je hebt 1 kaart beantwoord.',
    );
    return '$_temp0';
  }

  @override
  String get backHome => 'Terug';

  @override
  String get keyboardHint => 'Spatie: toon antwoord   1 tot 4: antwoorden';

  @override
  String get pluralLabel => 'Meervoud:';

  @override
  String get noPlural => 'Geen meervoud';

  @override
  String get pronounce => 'Uitspreken';

  @override
  String get noVoice => 'Voor deze taal is in Windows geen stem geïnstalleerd';

  @override
  String get newCardBadge => 'Nieuw';

  @override
  String minutes(int n) {
    return '$n min';
  }

  @override
  String hours(int n) {
    return '$n u';
  }

  @override
  String days(int n) {
    return '$n d';
  }

  @override
  String months(int n) {
    return '$n mnd';
  }

  @override
  String years(int n) {
    return '$n j';
  }

  @override
  String get searchHint => 'Zoeken in beide talen';

  @override
  String get allLevels => 'Alle';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count woorden',
      one: '1 woord',
    );
    return '$_temp0';
  }

  @override
  String get statusNew => 'Niet geleerd';

  @override
  String get statusLearning => 'Wordt geleerd';

  @override
  String statusLearned(String date) {
    return 'Volgende herhaling $date';
  }

  @override
  String get noResults => 'Geen woorden gevonden.';

  @override
  String get statsToday => 'Vandaag';

  @override
  String get statsLast30 => 'Laatste 30 dagen';

  @override
  String get statsByLevel => 'Geleerd per niveau';

  @override
  String learnedOf(int learned, int total) {
    return '$learned van $total';
  }

  @override
  String get statsAllPairs => 'Alle taalparen';

  @override
  String get statsThisPair => 'Huidig taalpaar';

  @override
  String get settingsMenuLanguage => 'Menutaal';

  @override
  String get settingsLanguages => 'Talen';

  @override
  String get settingsStudy => 'Leren';

  @override
  String get settingsNewPerDay => 'Nieuwe kaarten per dag';

  @override
  String get settingsReversed => 'Kaarten omdraaien';

  @override
  String get settingsReversedHint =>
      'Eerst de betekenis tonen en het woord herinneren. De voortgang wordt apart bijgehouden.';

  @override
  String get settingsAppearance => 'Weergave';

  @override
  String get themeSystem => 'Zoals Windows';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get settingsAbout =>
      'De voortgang wordt voor elk taalpaar apart bijgehouden.';

  @override
  String get typeNoun => 'zelfstandig naamwoord';

  @override
  String get typeVerb => 'werkwoord';

  @override
  String get typeAdj => 'bijvoeglijk naamwoord';

  @override
  String get typeAdv => 'bijwoord';

  @override
  String get typePrep => 'voorzetsel';

  @override
  String get typePron => 'voornaamwoord';

  @override
  String get typeConj => 'voegwoord';

  @override
  String get typeDet => 'lidwoord of determinator';

  @override
  String get typeParticle => 'partikel';

  @override
  String get typeInterj => 'tussenwerpsel';

  @override
  String get typeNum => 'telwoord';

  @override
  String get typePhrasalVerb => 'phrasal verb';

  @override
  String get typePhrase => 'uitdrukking';

  @override
  String get typeIdiom => 'idioom';
}
