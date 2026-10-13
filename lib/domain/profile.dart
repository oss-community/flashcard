import 'package:flutter/foundation.dart';

import 'pair.dart';

/// A learner's study setup: two languages, a name and study options. Each
/// profile keeps its own progress.
@immutable
class Profile {
  const Profile({
    required this.id,
    this.name,
    required this.native,
    required this.target,
    this.level,
    this.dailyGoal = 0,
    this.reversed = false,
    this.showForms = true,
  });

  final int id;

  /// Chosen by the learner; null shows a name made from the two languages.
  final String? name;
  final String native;
  final String target;

  /// Level new cards come from; null means every level in order, A1 first.
  final String? level;

  /// New words the learner aims for each day; 0 means no goal. It never
  /// stops the learner from going on.
  final int dailyGoal;
  final bool reversed;

  /// Show plurals, verb forms and comparisons on the back of the card.
  final bool showForms;

  LanguagePair get pair => LanguagePair(target: target, native: native, reversed: reversed);

  Profile copyWith({
    String? Function()? name,
    String? Function()? level,
    int? dailyGoal,
    bool? reversed,
    bool? showForms,
  }) => Profile(
    id: id,
    name: name != null ? name() : this.name,
    native: native,
    target: target,
    level: level != null ? level() : this.level,
    dailyGoal: dailyGoal ?? this.dailyGoal,
    reversed: reversed ?? this.reversed,
    showForms: showForms ?? this.showForms,
  );

  @override
  bool operator ==(Object other) =>
      other is Profile &&
      other.id == id &&
      other.name == name &&
      other.native == native &&
      other.target == target &&
      other.level == level &&
      other.dailyGoal == dailyGoal &&
      other.reversed == reversed &&
      other.showForms == showForms;

  @override
  int get hashCode => Object.hash(id, name, native, target, level, dailyGoal, reversed, showForms);
}

/// A name the learner typed, or null when it is empty.
String? cleanName(String? name) {
  final trimmed = name?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}
