import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/language.dart';
import '../domain/pair.dart';
import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import 'difficulty_menu.dart';
import 'labels.dart';
import 'layout.dart';
import 'term_text.dart';
import 'word_screen.dart';

/// List of all words of the current pair, with search and a level filter.
class WordsScreen extends ConsumerStatefulWidget {
  const WordsScreen({super.key});

  @override
  ConsumerState<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends ConsumerState<WordsScreen> {
  String _query = '';
  String? _level;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final vocab = ref.watch(vocabularyProvider);
    final target = vocab.language(settings.target!);
    final native = vocab.language(settings.native!);
    final schedules = ref.watch(schedulesProvider).value ?? const {};
    final overrides = ref.watch(difficultyOverridesProvider).value ?? const {};
    final now = DateTime.now().toUtc();
    final dateFormat = DateFormat.yMMMd(settings.uiLanguage);
    final compact = isCompact(context);

    final cards =
        ref
            .watch(pairCardsProvider)
            .where((c) => (_level == null || c.level == _level) && matchesQuery(c, _query))
            .toList()
          ..sort((a, b) {
            final byLevel = levels.indexOf(a.level).compareTo(levels.indexOf(b.level));
            if (byLevel != 0) return byLevel;
            return target.sortKey(a.target.word).compareTo(target.sortKey(b.target.word));
          });

    return Padding(
      padding: EdgeInsets.all(compact ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            autofocus: !compact,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l.searchHint,
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: compact ? 4 : 8,
                  runSpacing: compact ? 4 : 0,
                  children: [
                    ChoiceChip(
                      label: Text(l.allLevels),
                      selected: _level == null,
                      showCheckmark: !compact,
                      visualDensity: compact ? VisualDensity.compact : null,
                      onSelected: (_) => setState(() => _level = null),
                    ),
                    for (final level in levels)
                      ChoiceChip(
                        label: Text(level),
                        selected: _level == level,
                        showCheckmark: !compact,
                        visualDensity: compact ? VisualDensity.compact : null,
                        onSelected: (_) => setState(() => _level = level),
                      ),
                  ],
                ),
              ),
              Text(l.wordCount(cards.length), style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: cards.isEmpty
                ? Center(child: Text(l.noResults))
                : ListView.separated(
                    itemCount: cards.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final card = cards[i];
                      final schedule = schedules[card.id];
                      final status = schedule == null
                          ? l.statusNew
                          : schedule.isLearned && schedule.due.isAfter(now)
                          ? l.statusLearned(dateFormat.format(schedule.due.toLocal()))
                          : l.statusLearning;
                      final plural = card.target.plural;
                      return ListTile(
                        onTap: () => WordScreen.open(context, card),
                        contentPadding: compact ? EdgeInsets.zero : null,
                        leading: compact
                            ? null
                            : CircleAvatar(
                                radius: 18,
                                child: Text(card.level, style: theme.textTheme.labelSmall),
                              ),
                        title: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            TermText(card.target.word, language: target),
                            if (card.target.type == 'noun' && plural != null && plural != '-')
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 8),
                                child: TermText(
                                  plural,
                                  language: target,
                                  style: TextStyle(color: theme.colorScheme.outline),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: TermText(card.native.word, language: native),
                                ),
                                Flexible(
                                  child: Text(
                                    '  ${typeLabel(l, card.target.type)}',
                                    style: TextStyle(color: theme.colorScheme.outline),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (compact)
                              Text('${card.level} · $status', style: theme.textTheme.bodySmall),
                          ],
                        ),
                        trailing: compact
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DifficultyMenu(
                                    cardId: card.id,
                                    difficulty: effectiveDifficulty(card, overrides),
                                  ),
                                  SpeakButton(language: target, text: card.target.word),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: Align(
                                      alignment: AlignmentDirectional.centerStart,
                                      child: DifficultyMenu(
                                        cardId: card.id,
                                        difficulty: effectiveDifficulty(card, overrides),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      status,
                                      textAlign: TextAlign.end,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                  SpeakButton(language: target, text: card.target.word),
                                ],
                              ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
