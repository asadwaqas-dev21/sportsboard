/// Tournament status enumeration.
enum TournamentStatus {
  upcoming("Upcoming", "upcoming"),
  active("Active", "active"),
  completed("Completed", "completed");

  final String label;
  final String key;

  const TournamentStatus(this.label, this.key);

  static TournamentStatus fromKey(String key) {
    return TournamentStatus.values.firstWhere(
      (e) => e.key == key,
      orElse: () => TournamentStatus.upcoming,
    );
  }
}
