/// Calendar day of [time] in local time, at midnight.
DateTime dayOf(DateTime time) {
  final local = time.toLocal();
  return DateTime(local.year, local.month, local.day);
}

/// Number of consecutive days with at least one review, counting back from
/// today. A streak still counts if today has no reviews yet but yesterday had.
int streakDays(Set<DateTime> reviewDays, DateTime now) {
  var day = dayOf(now);
  if (!reviewDays.contains(day)) {
    day = DateTime(day.year, day.month, day.day - 1);
    if (!reviewDays.contains(day)) return 0;
  }
  var streak = 0;
  while (reviewDays.contains(day)) {
    streak++;
    day = DateTime(day.year, day.month, day.day - 1);
  }
  return streak;
}

/// Review counts for the last [days] days, oldest first, today last.
List<({DateTime day, int count})> dailyCounts(
  Map<DateTime, int> countsByDay,
  DateTime now,
  int days,
) {
  final today = dayOf(now);
  return [
    for (var i = days - 1; i >= 0; i--)
      () {
        final day = DateTime(today.year, today.month, today.day - i);
        return (day: day, count: countsByDay[day] ?? 0);
      }(),
  ];
}
