import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/language.dart';
import '../core/vocabulary_source.dart';
import '../domain/pair.dart';
import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import 'labels.dart';
import 'term_text.dart';
import 'word_forms.dart';

/// Personal pronouns for the six persons of a conjugation row.
const _pronouns = {
  'en': ['I', 'you', 'he/she', 'we', 'you', 'they'],
  'de': ['ich', 'du', 'er/sie', 'wir', 'ihr', 'sie'],
  'nl': ['ik', 'jij', 'hij/zij', 'wij', 'jullie', 'zij'],
  'fa': ['من', 'تو', 'او', 'ما', 'شما', 'آن‌ها'],
};

/// Name of each tense in its own language, as learners of it know it.
const _grammarNames = {
  'en': {
    'present': 'present simple',
    'present_progressive': 'present continuous',
    'simple_past': 'past simple',
    'past_progressive': 'past continuous',
    'present_perfect': 'present perfect',
    'past_perfect': 'past perfect',
    'future': 'future simple',
  },
  'de': {
    'present': 'Präsens',
    'simple_past': 'Präteritum',
    'present_perfect': 'Perfekt',
    'past_perfect': 'Plusquamperfekt',
    'future': 'Futur I',
  },
  'nl': {
    'present': 'o.t.t.',
    'present_progressive': 'aan het + infinitief',
    'simple_past': 'o.v.t.',
    'past_progressive': 'was aan het + infinitief',
    'present_perfect': 'v.t.t.',
    'past_perfect': 'v.v.t.',
    'future': 'o.t.t.t.',
  },
  'fa': {
    'present': 'مضارع اخباری',
    'present_progressive': 'مضارع مستمر',
    'simple_past': 'ماضی ساده',
    'past_imperfect': 'ماضی استمراری',
    'past_progressive': 'ماضی مستمر',
    'present_perfect': 'ماضی نقلی',
    'past_perfect': 'ماضی بعید',
    'future': 'آینده',
  },
};

/// Closest tenses when a language lacks one, nearest first.
const _closeTenses = {
  'present_progressive': ['present'],
  'past_progressive': ['past_imperfect', 'simple_past'],
  'past_imperfect': ['past_progressive', 'simple_past'],
};

/// The tense among [tenses] that best matches [tense], if any.
Conjugation? matchingTense(String tense, List<Conjugation> tenses) {
  for (final name in [tense, ...?_closeTenses[tense]]) {
    for (final c in tenses) {
      if (c.tense == name) return c;
    }
  }
  return null;
}

String tenseLabel(AppLocalizations l, String tense) => switch (tense) {
  'present' => l.tensePresent,
  'present_progressive' => l.tensePresentProgressive,
  'simple_past' => l.tenseSimplePast,
  'past_imperfect' => l.tensePastImperfect,
  'past_progressive' => l.tensePastProgressive,
  'present_perfect' => l.tensePresentPerfect,
  'past_perfect' => l.tensePastPerfect,
  'future' => l.tenseFuture,
  _ => tense,
};

/// A word of the current profile with all of its forms and, for verbs, the
/// conjugation in both languages side by side.
class WordScreen extends ConsumerStatefulWidget {
  const WordScreen({super.key, required this.card});

  final PairCard card;

  static Future<void> open(BuildContext context, PairCard card) => Navigator.of(
    context,
    rootNavigator: true,
  ).push(MaterialPageRoute<void>(builder: (_) => WordScreen(card: card)));

  @override
  ConsumerState<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends ConsumerState<WordScreen> {
  /// Language whose table is shown; the one being learned unless switched.
  String? _shown;
  final _tables = <String, List<Conjugation>>{};

  List<Conjugation> _table(String lang) =>
      _tables[lang] ??= ref.read(vocabularyProvider).conjugations(widget.card.id, lang);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final vocab = ref.watch(vocabularyProvider);
    final ui = settings.uiLanguage;
    final card = widget.card;
    final sides = [
      (vocab.language(settings.target!), card.target),
      (vocab.language(settings.native!), card.native),
    ];
    final conjugated = [
      for (final side in sides)
        if (vocab.hasConjugation(card.id, side.$1.code)) side,
    ];
    final shown = conjugated.where((s) => s.$1.code == _shown).followedBy(conjugated).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TermText(card.target.word, language: sides[0].$1),
            const Text('  ·  '),
            TermText(card.native.word, language: sides[1].$1),
          ],
        ),
      ),
      body: Align(
        alignment: AlignmentDirectional.topStart,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Text(
                '${typeLabel(l, card.target.type)} · ${card.level}',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
              ),
              const SizedBox(height: 16),
              if (shown == null)
                for (final (language, term) in sides) ...[
                  _WordBlock(language: language, term: term, ui: ui),
                  const SizedBox(height: 16),
                ]
              else ...[
                if (conjugated.length > 1) ...[
                  SegmentedButton<String>(
                    segments: [
                      for (final (language, _) in conjugated)
                        ButtonSegment(value: language.code, label: Text(language.nameIn(ui))),
                    ],
                    selected: {shown.$1.code},
                    onSelectionChanged: (v) => setState(() => _shown = v.first),
                  ),
                  const SizedBox(height: 16),
                ],
                FormChips(
                  language: shown.$1,
                  forms: [
                    (shown.$2.word, l.formInfinitive),
                    ...keyForms(l, shown.$1.code, shown.$2),
                  ],
                ),
                const SizedBox(height: 16),
                ..._tenseCards(context, shown.$1, sides.firstWhere((s) => s != shown).$1),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _tenseCards(BuildContext context, Language language, Language other) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final pronouns = _pronouns[language.code] ?? List.filled(6, '');
    final otherTable = _table(other.code);
    return [
      for (final tense in _table(language.code))
        if (tense.forms.any((f) => f != '-'))
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Builder(
                builder: (context) {
                  final match = matchingTense(tense.tense, otherTable);
                  final names = [
                    _grammarNames[language.code]?[tense.tense],
                    if (match != null) _grammarNames[other.code]?[match.tense],
                  ].nonNulls.join(' · ');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        children: [
                          Text(tenseLabel(l, tense.tense), style: theme.textTheme.titleMedium),
                          Text(
                            names,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      for (var i = 0; i < 6; i++)
                        if (tense.forms[i] != '-')
                          _PersonRow(
                            language: language,
                            other: other,
                            pronoun: pronouns[i],
                            form: tense.forms[i],
                            equivalent: match == null || match.forms[i] == '-'
                                ? null
                                : match.forms[i],
                            divider: i > 0,
                          ),
                    ],
                  );
                },
              ),
            ),
          ),
    ];
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({
    required this.language,
    required this.other,
    required this.pronoun,
    required this.form,
    required this.equivalent,
    required this.divider,
  });

  final Language language;
  final Language other;
  final String pronoun;
  final String form;
  final String? equivalent;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.outline;
    return Directionality(
      textDirection: language.rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: divider
              ? Border(top: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 64,
              child: TermText(
                pronoun,
                language: language,
                style: TextStyle(color: muted),
              ),
            ),
            Expanded(
              flex: 3,
              child: TermText(form, language: language, style: theme.textTheme.bodyLarge),
            ),
            if (equivalent case final value?)
              Expanded(
                flex: 2,
                child: TermText(
                  value,
                  language: other,
                  textAlign: language.rtl == other.rtl ? TextAlign.end : TextAlign.start,
                  style: TextStyle(color: muted),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A word with its plural or key forms, for words without a conjugation.
class _WordBlock extends StatelessWidget {
  const _WordBlock({required this.language, required this.term, required this.ui});

  final Language language;
  final Term term;
  final String ui;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final forms = keyForms(l, language.code, term);
    final plural = term.plural;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(language.nameIn(ui), style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: TermText(
                    term.word,
                    language: language,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                SpeakButton(language: language, text: term.word),
              ],
            ),
            Text(
              typeLabel(l, term.type),
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
            ),
            if (term.type == 'noun' && plural != null) ...[
              const SizedBox(height: 8),
              PluralLine(language: language, plural: plural),
            ],
            if (forms.isNotEmpty) ...[
              const SizedBox(height: 12),
              FormChips(language: language, forms: forms),
            ],
          ],
        ),
      ),
    );
  }
}

/// "Plural: Bücher", or "No plural".
class PluralLine extends StatelessWidget {
  const PluralLine({super.key, required this.language, required this.plural});

  final Language language;
  final String plural;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final style = Theme.of(context).textTheme.bodyLarge;
    if (plural == '-') return Text(l.noPlural, style: style);
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(l.pluralLabel, style: style),
        const SizedBox(width: 6),
        TermText(plural, language: language, style: style),
      ],
    );
  }
}
