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
      'Kies de taal die je wilt leren, de taal die je al kent en je niveau. Later kun je in de instellingen meer profielen toevoegen, elk met een eigen voortgang.';

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
  String get levelAllInOrder => 'Alle, op volgorde';

  @override
  String get levelAllHint => 'Nieuwe kaarten komen eerst uit A1, dan uit A2 en zo verder tot C2.';

  @override
  String get dueNow => 'Te herhalen';

  @override
  String get newLeft => 'Nieuwe woorden over';

  @override
  String get newTodayLabel => 'Nieuwe woorden vandaag';

  @override
  String get reviewedToday => 'Vandaag beantwoord';

  @override
  String get streak => 'Dagen op rij';

  @override
  String get studyNow => 'Begin met leren';

  @override
  String get allDone =>
      'Er is nu niets te leren: er staat geen herhaling klaar en alle woorden zijn geleerd. Herhalingen komen terug zodra ze aan de beurt zijn.';

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
  String get forgot => 'Vergeten';

  @override
  String get remembered => 'Geweten';

  @override
  String get difficulty => 'Moeilijkheid';

  @override
  String get diffEasy => 'Makkelijk';

  @override
  String get diffMedium => 'Gemiddeld';

  @override
  String get diffAdvanced => 'Gevorderd';

  @override
  String get changeDifficulty => 'Moeilijkheid wijzigen';

  @override
  String dueInSession(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count herhalingen klaar',
      one: '1 herhaling klaar',
      zero: 'Geen herhaling klaar',
    );
    return '$_temp0';
  }

  @override
  String goalProgress(int done, int goal) {
    return 'Dagdoel: $done van $goal nieuwe woorden';
  }

  @override
  String newTodayCount(int count) {
    return 'Nieuwe woorden vandaag: $count';
  }

  @override
  String get goalReached => 'Dagdoel gehaald. Ga gerust door zo lang je wilt.';

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
  String get keyboardHint => 'Spatie: toon antwoord   1: vergeten   2: geweten';

  @override
  String get pluralLabel => 'Meervoud:';

  @override
  String get noPlural => 'Geen meervoud';

  @override
  String get pronounce => 'Uitspreken';

  @override
  String get noVoice => 'Op dit apparaat is geen stem voor deze taal geïnstalleerd';

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
  String get settingsMenuLanguage => 'Menutaal';

  @override
  String get settingsStudy => 'Leren';

  @override
  String get settingsDailyGoal => 'Dagdoel (nieuwe woorden)';

  @override
  String get settingsDailyGoalHint => 'Alleen om bij te houden. Je kunt altijd meer leren.';

  @override
  String get noGoal => 'Geen';

  @override
  String get settingsReversed => 'Kaarten omdraaien';

  @override
  String get settingsReversedHint =>
      'Eerst de betekenis tonen en het woord herinneren. De voortgang wordt apart bijgehouden.';

  @override
  String get settingsAppearance => 'Weergave';

  @override
  String get themeSystem => 'Zoals het systeem';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get settingsAbout =>
      'Elk profiel heeft een eigen voortgang. Voeg een nieuw profiel toe om een ander taalpaar te leren.';

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

  @override
  String get profiles => 'Profielen';

  @override
  String get profileName => 'Profielnaam';

  @override
  String get profileNameHint => 'Optioneel. Laat leeg om het profiel naar zijn talen te noemen.';

  @override
  String profileDefaultName(String native, String target) {
    return '$native → $target';
  }

  @override
  String get newProfile => 'Nieuw profiel';

  @override
  String get createProfile => 'Profiel maken';

  @override
  String get switchProfile => 'Ander profiel';

  @override
  String get renameProfile => 'Naam wijzigen';

  @override
  String deleteProfileTitle(String name) {
    return '‘$name’ verwijderen?';
  }

  @override
  String get deleteProfileBody =>
      'Alle voortgang van dit profiel wordt verwijderd. Dit kan niet ongedaan worden gemaakt.';

  @override
  String get delete => 'Verwijderen';

  @override
  String get cancel => 'Annuleren';

  @override
  String get save => 'Opslaan';

  @override
  String settingsStudyIn(String profile) {
    return 'Leren: $profile';
  }

  @override
  String get settingsShowForms => 'Woordvormen tonen';

  @override
  String get settingsShowFormsHint =>
      'Meervoud, werkwoordsvormen en trappen van vergelijking op de achterkant van de kaart.';

  @override
  String get conjugation => 'Vervoeging';

  @override
  String get formInfinitive => 'Infinitief';

  @override
  String get formPast => 'Verleden tijd';

  @override
  String get formPerfect => 'Voltooid';

  @override
  String get formPastParticiple => 'Voltooid deelwoord';

  @override
  String get formPastStem => 'Verledentijdsstam';

  @override
  String get formPresentStem => 'Tegenwoordigetijdsstam';

  @override
  String get formComparative => 'Vergrotende trap';

  @override
  String get formSuperlative => 'Overtreffende trap';

  @override
  String get tensePresent => 'Tegenwoordige tijd';

  @override
  String get tensePresentProgressive => 'Bezig in het heden';

  @override
  String get tenseSimplePast => 'Verleden tijd';

  @override
  String get tensePastImperfect => 'Gewoonte in het verleden';

  @override
  String get tensePastProgressive => 'Bezig in het verleden';

  @override
  String get tensePresentPerfect => 'Voltooid tegenwoordige tijd';

  @override
  String get tensePastPerfect => 'Voltooid verleden tijd';

  @override
  String get tenseFuture => 'Toekomende tijd';
}
