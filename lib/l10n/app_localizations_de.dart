// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Karteikarten';

  @override
  String get navStudy => 'Lernen';

  @override
  String get navWords => 'Wörter';

  @override
  String get navStats => 'Statistik';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get welcomeTitle => 'Willkommen';

  @override
  String get welcomeBody =>
      'Wähle die Sprache, die du lernen möchtest, die Sprache, die du schon kannst, und dein Niveau. Später kannst du in den Einstellungen weitere Profile anlegen, jedes mit eigenem Fortschritt.';

  @override
  String get languageToLearn => 'Sprache zum Lernen';

  @override
  String get languageYouKnow => 'Sprache, die du kannst';

  @override
  String get level => 'Niveau';

  @override
  String get start => 'Los geht\'s';

  @override
  String get sameLanguageError => 'Wähle zwei verschiedene Sprachen.';

  @override
  String get levelAllInOrder => 'Alle, der Reihe nach';

  @override
  String get levelAllHint => 'Neue Karten kommen zuerst aus A1, dann aus A2 und so weiter bis C2.';

  @override
  String get dueNow => 'Zur Wiederholung fällig';

  @override
  String get newLeft => 'Neue Wörter übrig';

  @override
  String get newTodayLabel => 'Neue Wörter heute';

  @override
  String get reviewedToday => 'Heute beantwortet';

  @override
  String get streak => 'Tage in Folge';

  @override
  String get studyNow => 'Jetzt lernen';

  @override
  String get allDone =>
      'Gerade gibt es nichts zu lernen: Keine Wiederholung ist fällig, und alle Wörter wurden gelernt. Wiederholungen kommen zurück, sobald sie fällig sind.';

  @override
  String learningPair(String target, String native) {
    return '$target aus $native';
  }

  @override
  String levelLabel(String level) {
    return 'Niveau $level';
  }

  @override
  String get showAnswer => 'Antwort zeigen';

  @override
  String get forgot => 'Vergessen';

  @override
  String get remembered => 'Gewusst';

  @override
  String get difficulty => 'Schwierigkeit';

  @override
  String get diffEasy => 'Leicht';

  @override
  String get diffMedium => 'Mittel';

  @override
  String get diffAdvanced => 'Fortgeschritten';

  @override
  String get changeDifficulty => 'Schwierigkeit ändern';

  @override
  String dueInSession(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wiederholungen fällig',
      one: '1 Wiederholung fällig',
      zero: 'Keine Wiederholung fällig',
    );
    return '$_temp0';
  }

  @override
  String goalProgress(int done, int goal) {
    return 'Tagesziel: $done von $goal neuen Wörtern';
  }

  @override
  String newTodayCount(int count) {
    return 'Neue Wörter heute: $count';
  }

  @override
  String get goalReached => 'Tagesziel erreicht. Mach weiter, so lange du möchtest.';

  @override
  String get endSession => 'Sitzung beenden';

  @override
  String get sessionFinished => 'Sitzung beendet';

  @override
  String sessionSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du hast $count Karten beantwortet.',
      one: 'Du hast 1 Karte beantwortet.',
    );
    return '$_temp0';
  }

  @override
  String get backHome => 'Zurück';

  @override
  String get keyboardHint => 'Leertaste: Antwort zeigen   1: vergessen   2: gewusst';

  @override
  String get pluralLabel => 'Plural:';

  @override
  String get noPlural => 'Kein Plural';

  @override
  String get pronounce => 'Aussprechen';

  @override
  String get noVoice => 'Auf diesem Gerät ist keine Stimme für diese Sprache installiert';

  @override
  String get newCardBadge => 'Neu';

  @override
  String minutes(int n) {
    return '$n Min.';
  }

  @override
  String hours(int n) {
    return '$n Std.';
  }

  @override
  String days(int n) {
    return '$n T.';
  }

  @override
  String months(int n) {
    return '$n Mon.';
  }

  @override
  String years(int n) {
    return '$n J.';
  }

  @override
  String get searchHint => 'In beiden Sprachen suchen';

  @override
  String get allLevels => 'Alle';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wörter',
      one: '1 Wort',
    );
    return '$_temp0';
  }

  @override
  String get statusNew => 'Nicht gelernt';

  @override
  String get statusLearning => 'Wird gelernt';

  @override
  String statusLearned(String date) {
    return 'Nächste Wiederholung $date';
  }

  @override
  String get noResults => 'Keine Wörter gefunden.';

  @override
  String get statsToday => 'Heute';

  @override
  String get statsLast30 => 'Letzte 30 Tage';

  @override
  String get statsByLevel => 'Gelernt pro Niveau';

  @override
  String learnedOf(int learned, int total) {
    return '$learned von $total';
  }

  @override
  String get settingsMenuLanguage => 'Menüsprache';

  @override
  String get settingsStudy => 'Lernen';

  @override
  String get settingsDailyGoal => 'Tagesziel (neue Wörter)';

  @override
  String get settingsDailyGoalHint => 'Nur zur Übersicht. Du kannst immer mehr lernen.';

  @override
  String get noGoal => 'Keins';

  @override
  String get settingsReversed => 'Karten umdrehen';

  @override
  String get settingsReversedHint =>
      'Zuerst die Bedeutung zeigen und das Wort erinnern. Der Fortschritt wird getrennt gespeichert.';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get themeSystem => 'Wie das System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get settingsAbout =>
      'Jedes Profil hat seinen eigenen Fortschritt. Für ein anderes Sprachpaar legst du ein neues Profil an.';

  @override
  String get typeNoun => 'Nomen';

  @override
  String get typeVerb => 'Verb';

  @override
  String get typeAdj => 'Adjektiv';

  @override
  String get typeAdv => 'Adverb';

  @override
  String get typePrep => 'Präposition';

  @override
  String get typePron => 'Pronomen';

  @override
  String get typeConj => 'Konjunktion';

  @override
  String get typeDet => 'Artikelwort';

  @override
  String get typeParticle => 'Partikel';

  @override
  String get typeInterj => 'Interjektion';

  @override
  String get typeNum => 'Zahlwort';

  @override
  String get typePhrasalVerb => 'Phrasal Verb';

  @override
  String get typePhrase => 'Wendung';

  @override
  String get typeIdiom => 'Redewendung';

  @override
  String get profiles => 'Profile';

  @override
  String get profileName => 'Profilname';

  @override
  String get profileNameHint =>
      'Optional. Leer lassen, um das Profil nach seinen Sprachen zu benennen.';

  @override
  String profileDefaultName(String native, String target) {
    return '$native → $target';
  }

  @override
  String get newProfile => 'Neues Profil';

  @override
  String get createProfile => 'Profil anlegen';

  @override
  String get switchProfile => 'Profil wechseln';

  @override
  String get renameProfile => 'Umbenennen';

  @override
  String deleteProfileTitle(String name) {
    return '„$name“ löschen?';
  }

  @override
  String get deleteProfileBody =>
      'Der gesamte Fortschritt dieses Profils wird entfernt. Das lässt sich nicht rückgängig machen.';

  @override
  String get delete => 'Löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String settingsStudyIn(String profile) {
    return 'Lernen: $profile';
  }

  @override
  String get settingsShowForms => 'Wortformen zeigen';

  @override
  String get settingsShowFormsHint =>
      'Plural, Verbformen und Steigerung auf der Rückseite der Karte.';

  @override
  String get conjugation => 'Konjugation';

  @override
  String get formInfinitive => 'Infinitiv';

  @override
  String get formPast => 'Präteritum';

  @override
  String get formPerfect => 'Perfekt';

  @override
  String get formPastParticiple => 'Partizip II';

  @override
  String get formPastStem => 'Vergangenheitsstamm';

  @override
  String get formPresentStem => 'Präsensstamm';

  @override
  String get formComparative => 'Komparativ';

  @override
  String get formSuperlative => 'Superlativ';

  @override
  String get tensePresent => 'Gegenwart';

  @override
  String get tensePresentProgressive => 'Verlaufsform Gegenwart';

  @override
  String get tenseSimplePast => 'Vergangenheit';

  @override
  String get tensePastImperfect => 'Gewohnheit in der Vergangenheit';

  @override
  String get tensePastProgressive => 'Verlaufsform Vergangenheit';

  @override
  String get tensePresentPerfect => 'Perfekt';

  @override
  String get tensePastPerfect => 'Plusquamperfekt';

  @override
  String get tenseFuture => 'Zukunft';

  @override
  String get about => 'Über die App';

  @override
  String get aboutBody =>
      'Lerne Vokabeln mit Karteikarten und verteilter Wiederholung. Kostenlos und quelloffen. Funktioniert offline, und dein Fortschritt bleibt auf diesem Gerät.';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutFeedback => 'Fehler melden oder Idee vorschlagen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get aboutSource => 'Quellcode';

  @override
  String get aboutLicenses => 'Lizenzen';

  @override
  String get reportMistake => 'Fehler melden';
}
