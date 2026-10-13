import 'package:flutter/material.dart';

import '../core/language.dart';
import '../core/vocabulary_source.dart';
import '../l10n/app_localizations.dart';
import 'term_text.dart';

/// The key forms of [term] worth showing next to it, each with its label:
/// past forms of verbs, comparison of adjectives. Plurals are shown apart.
List<(String, String)> keyForms(AppLocalizations l, String lang, Term term) {
  final f = term.forms;
  final verb = term.type == 'verb' || term.type == 'phrasal verb';
  final result = <(String, String)>[];
  void add(String? value, String label) {
    if (value != null && value.isNotEmpty) result.add((value, label));
  }

  if (verb) {
    switch (lang) {
      case 'fa':
        add(f['past_stem'], l.formPastStem);
        add(f['present_stem'], l.formPresentStem);
      case 'de' || 'nl':
        add(f['past'], l.formPast);
        add(perfect(lang, term), l.formPerfect);
      default:
        add(f['past'], l.formPast);
        add(f['past_participle'], l.formPastParticiple);
    }
  } else {
    add(f['comparative'], l.formComparative);
    add(f['superlative'], l.formSuperlative);
  }
  return result;
}

/// "ist gegangen", "hat sich erinnert", "heeft gewerkt": the third person
/// perfect of a German or Dutch verb, built from its auxiliary and participle.
String? perfect(String lang, Term term) {
  final participle = term.forms['participle'];
  final auxiliary = term.forms['auxiliary'];
  if (participle == null || auxiliary == null) return null;
  final third = {
    'haben': 'hat',
    'sein': 'ist',
    'haben/sein': 'hat/ist',
    'hebben': 'heeft',
    'zijn': 'is',
    'hebben/zijn': 'heeft/is',
  }[auxiliary];
  if (third == null) return null;
  final reflexive = lang == 'de' ? 'sich ' : 'zich ';
  return term.word.startsWith(reflexive) ? '$third $reflexive$participle' : '$third $participle';
}

/// Small boxes with a form on top and its label below.
class FormChips extends StatelessWidget {
  const FormChips({super.key, required this.language, required this.forms});

  final Language language;
  final List<(String, String)> forms;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      textDirection: language.rtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        for (final (value, label) in forms)
          Container(
            constraints: const BoxConstraints(minWidth: 84),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TermText(
                  value,
                  language: language,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
