import '../core/vocabulary_source.dart';

/// The two languages a learner studies with: the one being learned and the
/// one they already know. [reversed] cards show the known language first.
class LanguagePair {
  const LanguagePair({required this.target, required this.native, this.reversed = false});

  final String target;
  final String native;
  final bool reversed;

  @override
  bool operator ==(Object other) =>
      other is LanguagePair &&
      other.target == target &&
      other.native == native &&
      other.reversed == reversed;

  @override
  int get hashCode => Object.hash(target, native, reversed);

  @override
  String toString() => '$target<-$native${reversed ? ' (reversed)' : ''}';
}

/// A card as seen through a language pair: only two of its languages.
class PairCard {
  const PairCard({
    required this.id,
    required this.level,
    required this.difficulty,
    required this.target,
    required this.native,
  });

  final String id;
  final String level;

  /// Difficulty from the data; the learner may override it (see
  /// `ProgressRepository.difficultyOverrides`).
  final String difficulty;
  final Term target;
  final Term native;
}

/// Picks the two languages of [pair] out of every card, dropping cards that
/// would look identical in this pair (same word and same meaning).
List<PairCard> cardsForPair(List<VocabCard> cards, LanguagePair pair) {
  final seen = <String>{};
  final result = <PairCard>[];
  for (final card in cards) {
    final target = card.terms[pair.target];
    final native = card.terms[pair.native];
    if (target == null || native == null) continue;
    final key = '${target.word.toLowerCase()}\u0000${native.word.toLowerCase()}';
    if (!seen.add(key)) continue;
    result.add(
      PairCard(
        id: card.id,
        level: card.level,
        difficulty: card.difficulty,
        target: target,
        native: native,
      ),
    );
  }
  return result;
}

/// Case-insensitive search over both languages of a pair card.
bool matchesQuery(PairCard card, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  return card.target.word.toLowerCase().contains(q) ||
      card.native.word.toLowerCase().contains(q) ||
      (card.target.plural?.toLowerCase().contains(q) ?? false);
}
