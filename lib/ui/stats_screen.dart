import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/language.dart';
import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import 'study_screen.dart';

/// Today's numbers, the last 30 days, and progress per level.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final today = ref.watch(todayProvider).value;
    final history = ref.watch(historyProvider).value ?? const [];
    final schedules = ref.watch(schedulesProvider).value ?? const {};
    final cards = ref.watch(pairCardsProvider);
    final ui = ref.watch(settingsProvider).uiLanguage;

    final perLevel = {
      for (final level in levels)
        level: (
          total: cards.where((c) => c.level == level).length,
          learned: cards
              .where((c) => c.level == level && (schedules[c.id]?.isLearned ?? false))
              .length,
        ),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.statsToday, style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          if (today != null)
            Wrap(spacing: 16, runSpacing: 16, children: [
              StatTile(label: l.reviewedToday, value: today.reviewedToday),
              StatTile(label: l.dueNow, value: today.due),
              StatTile(label: l.streak, value: today.streak),
            ]),
          const SizedBox(height: 32),
          Text(l.statsLast30, style: theme.textTheme.titleLarge),
          Text(l.statsAllPairs, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          SizedBox(height: 160, child: _HistoryChart(history: history, locale: ui)),
          const SizedBox(height: 32),
          Text(l.statsByLevel, style: theme.textTheme.titleLarge),
          Text(l.statsThisPair, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          for (final MapEntry(key: level, value: count) in perLevel.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(width: 40, child: Text(level, style: theme.textTheme.titleSmall)),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: count.total == 0 ? 0 : count.learned / count.total,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text(l.learnedOf(count.learned, count.total),
                        textAlign: TextAlign.end, style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HistoryChart extends StatelessWidget {
  const _HistoryChart({required this.history, required this.locale});

  final List<({DateTime day, int count})> history;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (history.isEmpty) return const SizedBox();
    final maxCount = max(1, history.map((e) => e.count).reduce(max));
    final format = DateFormat.MMMd(locale);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final entry in history)
          Expanded(
            child: Tooltip(
              message: '${format.format(entry.day)}: ${entry.count}',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: max(2, 140 * entry.count / maxCount),
                      decoration: BoxDecoration(
                        color: entry.count == 0
                            ? theme.colorScheme.outlineVariant
                            : theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
