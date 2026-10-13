import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/vocabulary_source.dart';
import '../l10n/app_localizations.dart';
import '../state/providers.dart';
import 'labels.dart';

/// Chip showing a word's difficulty; tapping it lets the learner pick another.
class DifficultyMenu extends ConsumerWidget {
  const DifficultyMenu({super.key, required this.cardId, required this.difficulty});

  final String cardId;
  final String difficulty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final color = switch (difficulty) {
      'easy' => scheme.primary,
      'advanced' => scheme.error,
      _ => scheme.tertiary,
    };
    return PopupMenuButton<String>(
      tooltip: l.changeDifficulty,
      initialValue: difficulty,
      onSelected: (value) async {
        final target = ref.read(settingsProvider).target!;
        await ref.read(progressRepositoryProvider).setDifficulty(cardId, target, value);
        ref.read(progressVersionProvider.notifier).bump();
      },
      itemBuilder: (_) => [
        for (final d in difficulties) PopupMenuItem(value: d, child: Text(difficultyLabel(l, d))),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(difficultyLabel(l, difficulty), style: TextStyle(color: color)),
            Icon(Icons.arrow_drop_down, size: 18, color: color),
          ],
        ),
      ),
    );
  }
}
