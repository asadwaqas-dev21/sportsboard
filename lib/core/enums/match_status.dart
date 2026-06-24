/// Match status enumeration.
enum MatchStatus {
  upcoming("Upcoming", "upcoming"),
  live("Live", "live"),
  completed("Completed", "completed"),
  postponed("Postponed", "postponed"),
  cancelled("Cancelled", "cancelled");

  final String label;
  final String key;

  const MatchStatus(this.label, this.key);

  static MatchStatus fromKey(String key) {
    return MatchStatus.values.firstWhere(
      (e) => e.key == key,
      orElse: () => MatchStatus.upcoming,
    );
  }

  bool get isUpcoming => this == MatchStatus.upcoming;
  bool get isLive => this == MatchStatus.live;
  bool get isCompleted => this == MatchStatus.completed;
}
