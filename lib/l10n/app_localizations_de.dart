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
      'Wähle die Sprache, die du lernen möchtest, die Sprache, die du schon kannst, und dein Niveau. Du kannst alles später in den Einstellungen ändern.';

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
  String get dueNow => 'Zur Wiederholung fällig';

  @override
  String get newToday => 'Neue Karten heute übrig';

  @override
  String get reviewedToday => 'Heute beantwortet';

  @override
  String get streak => 'Tage in Folge';

  @override
  String get studyNow => 'Jetzt lernen';

  @override
  String get allDone =>
      'Für jetzt ist alles erledigt. Komm später wieder oder erhöhe die Zahl neuer Karten pro Tag in den Einstellungen.';

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
  String get again => 'Nochmal';

  @override
  String get hard => 'Schwer';

  @override
  String get good => 'Gut';

  @override
  String get easy => 'Leicht';

  @override
  String cardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Karten',
      one: 'Noch 1 Karte',
    );
    return '$_temp0';
  }

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
  String get keyboardHint => 'Leertaste: Antwort zeigen   1 bis 4: antworten';

  @override
  String get pluralLabel => 'Plural:';

  @override
  String get noPlural => 'Kein Plural';

  @override
  String get pronounce => 'Aussprechen';

  @override
  String get noVoice =>
      'Für diese Sprache ist in Windows keine Stimme installiert';

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
  String get statsAllPairs => 'Alle Sprachpaare';

  @override
  String get statsThisPair => 'Aktuelles Sprachpaar';

  @override
  String get settingsMenuLanguage => 'Menüsprache';

  @override
  String get settingsLanguages => 'Sprachen';

  @override
  String get settingsStudy => 'Lernen';

  @override
  String get settingsNewPerDay => 'Neue Karten pro Tag';

  @override
  String get settingsReversed => 'Karten umdrehen';

  @override
  String get settingsReversedHint =>
      'Zuerst die Bedeutung zeigen und das Wort erinnern. Der Fortschritt wird getrennt gespeichert.';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get themeSystem => 'Wie Windows';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get settingsAbout =>
      'Der Fortschritt wird für jedes Sprachpaar getrennt gespeichert.';

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
}
