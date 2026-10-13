import '../l10n/app_localizations.dart';

/// Menu name of a word type from the data (`noun`, `phrasal verb`, ...).
String typeLabel(AppLocalizations l, String type) => switch (type) {
      'noun' => l.typeNoun,
      'verb' => l.typeVerb,
      'adj' => l.typeAdj,
      'adv' => l.typeAdv,
      'prep' => l.typePrep,
      'pron' => l.typePron,
      'conj' => l.typeConj,
      'det' => l.typeDet,
      'particle' => l.typeParticle,
      'interj' => l.typeInterj,
      'num' => l.typeNum,
      'phrasal verb' => l.typePhrasalVerb,
      'phrase' => l.typePhrase,
      'idiom' => l.typeIdiom,
      _ => type,
    };

/// Short interval such as "10 min" or "3 d".
String intervalLabel(AppLocalizations l, Duration d) {
  if (d.inMinutes < 60) return l.minutes(d.inMinutes < 1 ? 1 : d.inMinutes);
  if (d.inHours < 24) return l.hours(d.inHours);
  final days = (d.inHours / 24).round();
  if (days < 30) return l.days(days);
  if (days < 365) return l.months((days / 30).round());
  return l.years((days / 365).round());
}
