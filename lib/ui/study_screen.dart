import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/language.dart';
import '../core/vocabulary_source.dart';
import '../domain/srs.dart';
import '../domain/study_session.dart';
import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import 'difficulty_menu.dart';
import 'labels.dart';
import 'profiles.dart';
import 'layout.dart';
import 'links.dart';
import 'term_text.dart';
import 'word_forms.dart';
import 'word_screen.dart';

/// Today's summary, and the flashcard session once started.
class StudyScreen extends ConsumerStatefulWidget {
  const StudyScreen({super.key});

  @override
  ConsumerState<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<StudyScreen> {
  StudySession? _session;

  /// New cards studied today before the session started.
  int _newBefore = 0;

  Future<void> _start() async {
    final settings = ref.read(settingsProvider);
    final clock = ref.read(clockProvider);
    final now = clock();
    final schedules = await ref.read(schedulesProvider.future);
    final today = await ref.read(progressRepositoryProvider).today(settings.profile!.id, now);
    final cards = sessionCards(
      cards: ref.read(pairCardsProvider),
      schedules: schedules,
      level: settings.level,
      now: now,
      seed: pairSeed(settings.pair),
    );
    setState(() {
      _newBefore = today.newCards;
      _session = StudySession(reviews: cards.reviews, fresh: cards.fresh, clock: clock);
    });
  }

  void _close() {
    ref.read(progressVersionProvider.notifier).bump();
    setState(() => _session = null);
  }

  @override
  Widget build(BuildContext context) {
    // A session belongs to one profile and direction.
    ref.listen(
      settingsProvider.select((s) => (s.profile?.id, s.reversed)),
      (_, _) => setState(() => _session = null),
    );
    final session = _session;
    if (session == null) return _Overview(onStart: _start);
    if (session.isFinished) return _Finished(answered: session.answered, onClose: _close);
    return _SessionView(
      key: ValueKey(session),
      session: session,
      newBefore: _newBefore,
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
              const Align(alignment: AlignmentDirectional.centerStart, child: ProfileSwitcher()),
              const SizedBox(height: 4),
              Text(
                profilePair(l, vocab, ui, settings.profile!),
                style: theme.textTheme.titleMedium,
              ),
              Text(
                settings.level == null ? l.levelAllHint : l.levelLabel(settings.level!),
                style: theme.textTheme.bodyMedium,
              ),
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
                        StatTile(
                          label: l.newTodayLabel,
                          value: settings.dailyGoal > 0
                              ? '${value.newToday} / ${settings.dailyGoal}'
                              : value.newToday,
                        ),
                        StatTile(label: l.newLeft, value: value.newLeft),
                        StatTile(label: l.streak, value: value.streak),
                      ],
                    ),
                    const SizedBox(height: 32),
                    if (value.due + value.newLeft > 0)
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

  /// A number, or a text such as "12 / 20".
  final Object value;

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
    required this.newBefore,
    required this.onChanged,
    required this.onEnd,
  });

  final StudySession session;
  final int newBefore;
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

  Future<void> _answer(Rating rating, String difficulty) async {
    if (!_revealed || _saving) return;
    _saving = true;
    final now = ref.read(clockProvider)();
    final result = widget.session.answer(
      ref.read(srsProvider),
      rating,
      now,
      wordDifficulty: difficulty,
    );
    await ref
        .read(progressRepositoryProvider)
        .saveReview(
          profile: ref.read(settingsProvider).profile!.id,
          reversed: ref.read(settingsProvider).reversed,
          cardId: result.item.card.id,
          schedule: result.schedule,
          rating: rating,
          wasNew: result.wasNew,
          at: now,
        );
    _saving = false;
    ref.read(progressVersionProvider.notifier).bump();
    if (!mounted) return;
    final goal = ref.read(settingsProvider).dailyGoal;
    if (result.wasNew && goal > 0 && widget.newBefore + widget.session.newAnswered == goal) {
      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).goalReached)));
    }
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
    final goal = settings.dailyGoal;
    final newToday = widget.newBefore + widget.session.newAnswered;
    final compact = isCompact(context);
    final progress = goal > 0
        ? LinearProgressIndicator(value: (newToday / goal).clamp(0, 1))
        : null;
    final goalText = Text(
      goal > 0 ? l.goalProgress(newToday, goal) : l.newTodayCount(newToday),
      style: theme.textTheme.titleSmall,
    );
    final dueText = Text(l.dueInSession(widget.session.dueCount), style: theme.textTheme.bodySmall);
    final now = ref.watch(clockProvider)();

    final target = vocab.language(settings.target!);
    final native = vocab.language(settings.native!);
    final targetTerm = item.card.target;
    final nativeTerm = item.card.native;
    final (frontLang, frontTerm, backLang, backTerm) = settings.reversed
        ? (native, nativeTerm, target, targetTerm)
        : (target, targetTerm, native, nativeTerm);

    final overrides = ref.watch(difficultyOverridesProvider).value ?? const {};
    final difficulty = effectiveDifficulty(item.card, overrides);
    // Forms belong to the answer, so they wait until it is shown.
    final forms = _revealed && settings.showForms;
    final answers = [
      (
        false,
        l.forgot,
        Rating.again,
        theme.colorScheme.error,
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.numpad1,
      ),
      (
        true,
        l.remembered,
        rememberedRating(difficulty, item.schedule),
        theme.colorScheme.primary,
        LogicalKeyboardKey.digit2,
        LogicalKeyboardKey.numpad2,
      ),
    ];

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): () => setState(() => _revealed = true),
        const SingleActivator(LogicalKeyboardKey.enter): () => setState(() => _revealed = true),
        for (final (_, _, rating, _, key, numpadKey) in answers) ...{
          SingleActivator(key): () => _answer(rating, difficulty),
          SingleActivator(numpadKey): () => _answer(rating, difficulty),
        },
      },
      child: Focus(
        focusNode: _focus,
        autofocus: true,
        child: Padding(
          padding: EdgeInsets.all(compact ? 16 : 24),
          child: Column(
            children: [
              if (compact) ...[
                Row(
                  children: [
                    Expanded(child: goalText),
                    dueText,
                    IconButton(
                      tooltip: l.endSession,
                      onPressed: widget.onEnd,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                ?progress,
              ] else
                Row(
                  children: [
                    goalText,
                    const SizedBox(width: 16),
                    Expanded(child: progress ?? const SizedBox()),
                    const SizedBox(width: 16),
                    dueText,
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
                          padding: EdgeInsets.symmetric(
                            horizontal: compact ? 20 : 32,
                            vertical: compact ? 28 : 40,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  DifficultyMenu(cardId: item.card.id, difficulty: difficulty),
                                  const Spacer(),
                                  if (item.isNew) Chip(label: Text(l.newCardBadge)),
                                  IconButton(
                                    key: const Key('reportMistake'),
                                    tooltip: l.reportMistake,
                                    onPressed: () => openLink(
                                      context,
                                      mistakeReportUrl(item.card, target, native),
                                    ),
                                    icon: const Icon(Icons.flag_outlined),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _TermBlock(
                                language: frontLang,
                                term: frontTerm,
                                showPlural: frontLang == target || forms,
                                showForms: forms,
                                big: true,
                              ),
                              if (_revealed) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: compact ? 16 : 24),
                                  child: const Divider(),
                                ),
                                _TermBlock(
                                  language: backLang,
                                  term: backTerm,
                                  showPlural: backLang == target || forms,
                                  showForms: forms,
                                  big: false,
                                ),
                                if (forms &&
                                    (vocab.hasConjugation(item.card.id, target.code) ||
                                        vocab.hasConjugation(item.card.id, native.code))) ...[
                                  const SizedBox(height: 16),
                                  FilledButton.tonalIcon(
                                    onPressed: () => WordScreen.open(context, item.card),
                                    icon: const Icon(Icons.table_chart_outlined),
                                    label: Text(l.conjugation),
                                  ),
                                ],
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
                          if (!compact) ...[
                            const SizedBox(height: 8),
                            Text(l.keyboardHint, style: theme.textTheme.bodySmall),
                          ],
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final (_, label, rating, color, _, _) in answers)
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  width: 180,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: color,
                                      side: BorderSide(color: color),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      fixedSize: const Size.fromHeight(60),
                                    ),
                                    onPressed: () => _answer(rating, difficulty),
                                    child: FittedBox(
                                      child: Column(
                                        children: [
                                          Text(label),
                                          Text(
                                            intervalLabel(
                                              l,
                                              srs.preview(
                                                item.schedule,
                                                rating,
                                                now,
                                                wordDifficulty: difficulty,
                                              ),
                                            ),
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
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
    required this.showForms,
    required this.big,
  });

  final Language language;
  final Term term;
  final bool showPlural;

  /// Past forms of verbs and comparison of adjectives.
  final bool showForms;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final plural = term.plural;
    final forms = showForms ? keyForms(l, language.code, term) : const <(String, String)>[];
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
        Text(
          typeLabel(l, term.type),
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
        ),
        if (showPlural && term.type == 'noun' && plural != null) ...[
          const SizedBox(height: 8),
          PluralLine(language: language, plural: plural),
        ],
        if (forms.isNotEmpty) ...[
          const SizedBox(height: 12),
          FormChips(language: language, forms: forms),
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
