import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/language.dart';
import '../core/vocabulary_source.dart';
import '../domain/srs.dart';
import '../domain/study_session.dart';
import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import 'labels.dart';
import 'term_text.dart';

/// Today's summary, and the flashcard session once started.
class StudyScreen extends ConsumerStatefulWidget {
  const StudyScreen({super.key});

  @override
  ConsumerState<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<StudyScreen> {
  StudySession? _session;

  Future<void> _start() async {
    final settings = ref.read(settingsProvider);
    final now = ref.read(clockProvider)();
    final schedules = await ref.read(schedulesProvider.future);
    final today = await ref.read(progressRepositoryProvider).today(settings.pair, now);
    final items = buildSessionItems(
      cards: ref.read(pairCardsProvider),
      schedules: schedules,
      level: settings.level,
      newLimit: settings.newPerDay - today.newCards,
      now: now,
      seed: pairSeed(settings.pair),
    );
    setState(() => _session = StudySession(items));
  }

  void _close() {
    ref.read(progressVersionProvider.notifier).bump();
    setState(() => _session = null);
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session == null) return _Overview(onStart: _start);
    if (session.isFinished) return _Finished(answered: session.answered, onClose: _close);
    return _SessionView(
      key: ValueKey(session),
      session: session,
      onChanged: () => setState(() {}),
      onEnd: _close,
    );
  }
}

class _Overview extends ConsumerWidget {
  const _Overview({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final vocab = ref.watch(vocabularyProvider);
    final ui = settings.uiLanguage;
    final today = ref.watch(todayProvider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.learningPair(vocab.language(settings.target!).nameIn(ui),
                    vocab.language(settings.native!).nameIn(ui)),
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(l.levelLabel(settings.level), style: theme.textTheme.titleMedium),
              const SizedBox(height: 32),
              switch (today) {
                AsyncData(:final value) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          StatTile(label: l.dueNow, value: value.due),
                          StatTile(label: l.newToday, value: value.newAvailable),
                          StatTile(label: l.reviewedToday, value: value.reviewedToday),
                          StatTile(label: l.streak, value: value.streak),
                        ],
                      ),
                      const SizedBox(height: 32),
                      if (value.due + value.newAvailable > 0)
                        FilledButton.icon(
                          onPressed: onStart,
                          icon: const Icon(Icons.play_arrow),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(l.studyNow),
                          ),
                        )
                      else
                        Text(l.allDone, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                AsyncError(:final error) => Text('$error'),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ],
          ),
        ),
      ),
    );
  }
}

/// A labelled number.
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 140).copyWith(minHeight: 112),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$value', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(label, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionView extends ConsumerStatefulWidget {
  const _SessionView({
    super.key,
    required this.session,
    required this.onChanged,
    required this.onEnd,
  });

  final StudySession session;
  final VoidCallback onChanged;
  final VoidCallback onEnd;

  @override
  ConsumerState<_SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends ConsumerState<_SessionView> {
  bool _revealed = false;
  bool _saving = false;
  final _focus = FocusNode();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  Future<void> _answer(Rating rating) async {
    if (!_revealed || _saving) return;
    _saving = true;
    final now = ref.read(clockProvider)();
    final result = widget.session.answer(ref.read(srsProvider), rating, now);
    await ref.read(progressRepositoryProvider).saveReview(
          pair: ref.read(settingsProvider).pair,
          cardId: result.item.card.id,
          schedule: result.schedule,
          rating: rating,
          wasNew: result.wasNew,
          at: now,
        );
    _saving = false;
    ref.read(progressVersionProvider.notifier).bump();
    if (!mounted) return;
    setState(() => _revealed = false);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final vocab = ref.watch(vocabularyProvider);
    final srs = ref.watch(srsProvider);
    final item = widget.session.current!;
    final now = ref.watch(clockProvider)();

    final target = vocab.language(settings.target!);
    final native = vocab.language(settings.native!);
    final targetTerm = item.card.target;
    final nativeTerm = item.card.native;
    final (frontLang, frontTerm, backLang, backTerm) = settings.reversed
        ? (native, nativeTerm, target, targetTerm)
        : (target, targetTerm, native, nativeTerm);

    final ratings = [
      (Rating.again, l.again, theme.colorScheme.error),
      (Rating.hard, l.hard, theme.colorScheme.tertiary),
      (Rating.good, l.good, theme.colorScheme.primary),
      (Rating.easy, l.easy, theme.colorScheme.secondary),
    ];

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): () => setState(() => _revealed = true),
        const SingleActivator(LogicalKeyboardKey.enter): () => setState(() => _revealed = true),
        for (var i = 0; i < 4; i++) ...{
          SingleActivator(LogicalKeyboardKey(LogicalKeyboardKey.digit1.keyId + i)): () =>
              _answer(ratings[i].$1),
          SingleActivator(LogicalKeyboardKey(LogicalKeyboardKey.numpad1.keyId + i)): () =>
              _answer(ratings[i].$1),
        },
      },
      child: Focus(
        focusNode: _focus,
        autofocus: true,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Text(l.cardsLeft(widget.session.remaining), style: theme.textTheme.titleSmall),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: widget.session.answered /
                          (widget.session.answered + widget.session.remaining),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: widget.onEnd,
                    icon: const Icon(Icons.close),
                    label: Text(l.endSession),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: GestureDetector(
                      onTap: () => setState(() => _revealed = true),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item.isNew)
                                Align(
                                  alignment: AlignmentDirectional.topEnd,
                                  child: Chip(label: Text(l.newCardBadge)),
                                ),
                              _TermBlock(
                                language: frontLang,
                                term: frontTerm,
                                showPlural: frontLang == target,
                                big: true,
                              ),
                              if (_revealed) ...[
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Divider(),
                                ),
                                _TermBlock(
                                  language: backLang,
                                  term: backTerm,
                                  showPlural: backLang == target,
                                  big: false,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 72,
                child: !_revealed
                    ? Column(
                        children: [
                          FilledButton(
                            onPressed: () => setState(() => _revealed = true),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              child: Text(l.showAnswer),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(l.keyboardHint, style: theme.textTheme.bodySmall),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final (i, (rating, label, color)) in ratings.indexed)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: SizedBox(
                                width: 132,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: color,
                                    side: BorderSide(color: color),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  onPressed: () => _answer(rating),
                                  child: Column(
                                    children: [
                                      Text('${i + 1}  $label'),
                                      Text(
                                        intervalLabel(l, srs.preview(item.schedule, rating, now)),
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermBlock extends StatelessWidget {
  const _TermBlock({
    required this.language,
    required this.term,
    required this.showPlural,
    required this.big,
  });

  final Language language;
  final Term term;
  final bool showPlural;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final plural = term.plural;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: TermText(
                term.word,
                language: language,
                textAlign: TextAlign.center,
                style: big ? theme.textTheme.displaySmall : theme.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(width: 8),
            SpeakButton(language: language, text: term.word),
          ],
        ),
        const SizedBox(height: 8),
        Text(typeLabel(l, term.type),
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
        if (showPlural && term.type == 'noun' && plural != null) ...[
          const SizedBox(height: 8),
          plural == '-'
              ? Text(l.noPlural, style: theme.textTheme.bodyLarge)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l.pluralLabel, style: theme.textTheme.bodyLarge),
                    const SizedBox(width: 6),
                    TermText(plural, language: language, style: theme.textTheme.bodyLarge),
                  ],
                ),
        ],
      ],
    );
  }
}

class _Finished extends StatelessWidget {
  const _Finished({required this.answered, required this.onClose});

  final int answered;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(l.sessionFinished, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(l.sessionSummary(answered)),
          const SizedBox(height: 24),
          FilledButton(onPressed: onClose, child: Text(l.backHome)),
        ],
      ),
    );
  }
}
